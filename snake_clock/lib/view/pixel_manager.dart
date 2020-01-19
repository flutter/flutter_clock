import 'dart:math';

import 'package:snake_clock/model/embedded_rectangle.dart';
import 'package:snake_clock/model/main_clock_display.dart';
import 'package:snake_clock/model/number_pixels.dart';
import 'package:snake_clock/model/pixel.dart';
import 'package:snake_clock/view/constants.dart';
import 'package:snake_clock/view/pixel_sheet.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:tuple/tuple.dart';

/// Handles where and how the pixels will be drawn.
class PixelManager {
  final counter = PixelDisplayCounter();
  final mainClockDisplay = MainClockDisplay(Rectangle(clockDisplayLeft,
      clockDisplayTop, clockDisplayWidth, clockDisplayHeight));
  final pixelSheet = PixelSheet();

  void minuteUpdated(ClockModel model) {
    updateTimeDisplayed(
        model,
        (rects) => pixelSheet.inheritPixelDisplays(
            counter, rects.map((val) => val.item2).toList()));
  }

  void secondUpdated(int second){

    pixelSheet.updateSecond(counter, second);
  }

  void createInitialTime(ClockModel model) {
    updateTimeDisplayed(model, (_) => pixelSheet.createInitialDisplay(counter));
  }

  /// Updates the current time to a new value. Doesn't include all the extra animations, just updates the
  /// currently displayed time.
  ///
  /// [hook] gives access to the list of EmbeddedRectangles in the mainClockDisplay that are about to be changed.
  void updateTimeDisplayed(ClockModel model,
      [void Function(List<Tuple2<num, EmbeddedRectangle>>) hook]) {
    final list = mainClockDisplay.changeDisplayedTime(
        convertDateTimeToClockDisplayString(
            DateTime.now(), model?.is24HourFormat ?? true));

    if (list.isEmpty) {
      return;
    }

    if (hook != null) {
      hook(list);
    }

    /// Update the display.
    list.forEach((val) {
      final points = createNumberPixels(val.item2.rectangle, val.item1);
      final pixels = createPixelDisplayFromPoints(points, counter);

      val.item2.pixels.clear();
      val.item2.pixels.addAll(pixels);
    });
  }

  /// Creates the frame for the current
  Iterable<Point> createFrame(DateTime dateTime) {
    return <EmbeddedRectangle>[
      mainClockDisplay.hourTens,
      mainClockDisplay.hourOnes,
      mainClockDisplay.minOnes,
      mainClockDisplay.minTens
    ]
        .expand<Point>(
            (val) => val.pixels.map<Point>((pixel) => pixel.createPoint(0)))
        .toList()
          ..addAll(pixelSheet.createPoints(dateTime.millisecond / 1000));
  }
}
