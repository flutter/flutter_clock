import 'dart:math';

import 'package:snake_clock/model/embedded_rectangle.dart';
import 'package:tuple/tuple.dart';

/// Holds the 4 embedded rectangles used to represent a main clock display.
class MainClockDisplay {
  /// Creates a main clock display spanning the given [rectangle].
  ///
  /// Make sure to set the displayed time before using the clock display.
  factory MainClockDisplay(Rectangle rectangle) {
    final clockRectangles = _createClockRectangles(rectangle);

    final hourTens = EmbeddedRectangle(clockRectangles[0]);
    final hourOnes = EmbeddedRectangle(clockRectangles[1]);
    final minTens = EmbeddedRectangle(clockRectangles[2]);
    final minOnes = EmbeddedRectangle(clockRectangles[3]);

    return MainClockDisplay._(hourTens, hourOnes, minTens, minOnes);
  }

  MainClockDisplay._(this.hourTens, this.hourOnes, this.minTens, this.minOnes);

  final hourTens;
  final hourOnes;
  final minTens;
  final minOnes;

  String _displayedTime = "----";

  /// Changes the displayed time on this clock display. Will not change the embedded rectangles.
  ///
  /// Returns a List of the changes that occurred when the displayed time was changed. It's given
  /// in the form of <NewNumber, EmbeddedRectangle>
  List<Tuple2<num, EmbeddedRectangle>> changeDisplayedTime(
      String newDisplayedTime) {
    assert(newDisplayedTime.length == 4);

    if (newDisplayedTime == _displayedTime) {
      return [];
    }

    final retVal = <Tuple2<num, EmbeddedRectangle>>[];

    for (int i = 0; i < 4; i++) {
      if (newDisplayedTime.codeUnitAt(i) == _displayedTime.codeUnitAt(i)) {
        continue;
      }

      final rectangle =
          i == 0 ? hourTens : i == 1 ? hourOnes : i == 2 ? minTens : minOnes;

      retVal.add(
          Tuple2(int.parse(newDisplayedTime.substring(i, i + 1)), rectangle));
    }

    _displayedTime = newDisplayedTime;
    return retVal;
  }

  void changeSpannedRectangle(Rectangle rectangle) {
    final clockRectangles = _createClockRectangles(rectangle);

    hourTens.rectangle = clockRectangles[0];
    hourOnes.rectangle = clockRectangles[1];
    minTens.rectangle = clockRectangles[2];
    minOnes.rectangle = clockRectangles[3];
  }
}

String convertDateTimeToClockDisplayString(DateTime dateTime,
        [bool is24Hour]) =>
    (dateTime.hour % (is24Hour ? 24 : 12)).toString().padLeft(2, "0") +
    dateTime.minute.toString().padLeft(2, "0");

/// Creates the clock rectangles given a total area of [rectangle].
///
/// Is returned in the form of [hourTens, hourOnes, minTens, minOnes].
List<Rectangle> _createClockRectangles(Rectangle rectangle) {
  final widthPartition = rectangle.width / 72;
  final rectWidth = widthPartition * 14;

  final hourTens =
      Rectangle(rectangle.left, rectangle.top, rectWidth, rectangle.height);
  final hourOnes = Rectangle(rectangle.left + widthPartition * 17, rectangle.top,
      rectWidth, rectangle.height);
  final minTens = Rectangle(rectangle.left + widthPartition * 39, rectangle.top,
      rectWidth, rectangle.height);
  final minOnes = Rectangle(rectangle.left + widthPartition * 56, rectangle.top,
      rectWidth, rectangle.height);

  return [hourTens, hourOnes, minTens, minOnes];
}