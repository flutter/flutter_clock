import 'dart:math';
import 'dart:ui';

import 'package:digital_clock/blocs/settings.dart' as blocs;

import 'package:digital_clock/models/time.dart' as models;
import 'package:digital_clock/models/glyph.dart' as models;

enum TimePositionParts {
  hourFirstPart,
  hourLastPart,
  minuteFirstPart,
  minuteLastPart,
  secondFirstPart,
  secondLastPart
}

class Clock {
  blocs.Settings settings;
  models.Time time;

  Map<TimePositionParts, List<models.Glyph>> timeGlyphs;

  double positionLimitInWidth;
  double positionLimitInHeight;

  Random random;

  Clock(
      {this.settings,
      this.time,
      this.positionLimitInWidth,
      this.positionLimitInHeight})
      : random = Random() {
    timeGlyphs = {
      TimePositionParts.hourFirstPart: prepareGlyphsModels(count: 2),
      TimePositionParts.hourLastPart: prepareGlyphsModels(count: 9),
      TimePositionParts.minuteFirstPart: prepareGlyphsModels(count: 5),
      TimePositionParts.minuteLastPart: prepareGlyphsModels(count: 9),
      TimePositionParts.secondFirstPart: prepareGlyphsModels(count: 5),
      TimePositionParts.secondLastPart: prepareGlyphsModels(count: 9)
    };

    time.addListener(timeChangeListener);

    settings.is24HourFormat.listen((is24HourFormat) {
      time.is24HourFormat = is24HourFormat;
      alreadyShowTime = null;
      changeHourGlyphsPosition();
      changeHourGlyphsSize();
    });
  }

  bool isNotDisposed = false;

  void dispose() {
    isNotDisposed = true;
    time.removeListener(timeChangeListener);

    for (TimePositionParts part in timeGlyphs.keys) {
      for (models.Glyph glyph in timeGlyphs[part]) {
        glyph.dispose();
      }
    }
  }

  models.Time alreadyShowTime;

  void timeChangeListener() {
    final isAlreadyShow = time.compare(alreadyShowTime);
    alreadyShowTime =
        models.Time.fromDateTime(formattedDateTime: time.formattedDateTime);

    const hourFirstPartTopPosition = 180.0;
    const hourFirstPartLeftPosition = 75.0;

    if (!isAlreadyShow.hour.firstPart) {
      changePartGlyph(
          topPosition: hourFirstPartTopPosition,
          leftPosition: hourFirstPartLeftPosition,
          glyphs: timeGlyphs[TimePositionParts.hourFirstPart],
          alreadyShowGlyph: alreadyShowTime.hour.firstPart);
    }

    const hourLastPartTopPosition = 180.0;
    const hourLastPartLeftPosition = 155.0;

    if (!isAlreadyShow.hour.lastPart) {
      changePartGlyph(
          topPosition: hourLastPartTopPosition,
          leftPosition: hourLastPartLeftPosition,
          glyphs: timeGlyphs[TimePositionParts.hourLastPart],
          alreadyShowGlyph: alreadyShowTime.hour.lastPart);
    }

    const minuteFirstPartTopPosition = 180.0;
    const minuteFirstPartLeftPosition = 275.0;

    if (!isAlreadyShow.minute.firstPart) {
      changePartGlyph(
          topPosition: minuteFirstPartTopPosition,
          leftPosition: minuteFirstPartLeftPosition,
          glyphs: timeGlyphs[TimePositionParts.minuteFirstPart],
          alreadyShowGlyph: alreadyShowTime.minute.firstPart);
    }

    const minuteLastPartTopPosition = 180.0;
    const minuteLastPartLeftPosition = 355.0;

    if (!isAlreadyShow.minute.lastPart) {
      changePartGlyph(
          topPosition: minuteLastPartTopPosition,
          leftPosition: minuteLastPartLeftPosition,
          glyphs: timeGlyphs[TimePositionParts.minuteLastPart],
          alreadyShowGlyph: alreadyShowTime.minute.lastPart);
    }

    const secondFirstPartTopPosition = 180.0;
    const secondFirstPartLeftPosition = 470.0;

    if (!isAlreadyShow.second.firstPart) {
      changePartGlyph(
          topPosition: secondFirstPartTopPosition,
          leftPosition: secondFirstPartLeftPosition,
          glyphs: timeGlyphs[TimePositionParts.secondFirstPart],
          alreadyShowGlyph: alreadyShowTime.second.firstPart);
    }

    const secondLastPartTopPosition = 180.0;
    const secondLastPartLeftPosition = 555.0;

    if (!isAlreadyShow.second.lastPart) {
      changePartGlyph(
          topPosition: secondLastPartTopPosition,
          leftPosition: secondLastPartLeftPosition,
          glyphs: timeGlyphs[TimePositionParts.secondLastPart],
          alreadyShowGlyph: alreadyShowTime.second.lastPart);
    }
  }

  void changePartGlyph(
      {double topPosition,
      double leftPosition,
      List<models.Glyph> glyphs,
      String alreadyShowGlyph}) {
    for (models.Glyph glyph in glyphs) {
      if (glyph.value != alreadyShowGlyph) continue;

      final indexOfGlyph = glyphs.indexOf(glyph);

      models.Glyph previousGlyph;

      previousGlyph =
          glyphs[indexOfGlyph == 0 ? glyphs.length - 1 : indexOfGlyph - 1];

      previousGlyph.scaleController.add(false);

      previousGlyph.changeAutoAnimatePosition(
          isPositionMustBeAutoAnimate: true);

      changeRandomPositionOfGlyph(previousGlyph);

      glyph.changePosition(Offset(leftPosition, topPosition));
      glyph.scaleController.add(true);

      glyph.changeAutoAnimatePosition(isPositionMustBeAutoAnimate: false);

      break;
    }
  }

  void changeHourGlyphsPosition() {
    for (models.Glyph glyph in timeGlyphs[TimePositionParts.hourFirstPart]) {
      changeRandomPositionOfGlyph(glyph);
    }

    for (models.Glyph glyph in timeGlyphs[TimePositionParts.hourLastPart]) {
      changeRandomPositionOfGlyph(glyph);
    }
  }

  void changeHourGlyphsSize() {
    for (models.Glyph glyph in timeGlyphs[TimePositionParts.hourFirstPart]) {
      glyph.changeScale(isMustBeScale: false);
    }

    for (models.Glyph glyph in timeGlyphs[TimePositionParts.hourLastPart]) {
      glyph.changeScale(isMustBeScale: false);
    }
  }

  List<models.Glyph> prepareGlyphsModels({int count = 9}) {
    final _glyphs = <models.Glyph>[];

    for (int iterator = 0; iterator <= count; iterator++) {
      final _glyph = models.Glyph(value: iterator.toString(), maxScale: 10);

      _glyphs.add(_glyph);
    }

    return _glyphs;
  }

  void changeRandomPositionOfGlyphs(List<models.Glyph> glyphs) {
    for (models.Glyph glyph in glyphs) {
      changeRandomPositionOfGlyph(glyph);
    }
  }

  void changeRandomPositionOfGlyph(models.Glyph glyph) {
    final topPosition =
        random.nextInt(positionLimitInHeight.toInt()).toDouble();

    final leftPosition =
        random.nextInt(positionLimitInWidth.toInt()).toDouble();

    final position = Offset(leftPosition, topPosition);
    glyph.changePosition(position);
  }
}
