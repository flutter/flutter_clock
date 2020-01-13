import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_clock_helper/model.dart' as models;

import 'package:digital_clock/models/time.dart' as models;
import 'package:digital_clock/models/glyph.dart' as models;

import 'package:digital_clock/blocs/clock.dart' as blocs;
import 'package:digital_clock/blocs/settings.dart' as blocs;

import 'package:digital_clock/ui/frame/widget.dart' as ui;
import 'package:digital_clock/ui/glyph/widget.dart' as ui;
import 'package:digital_clock/ui/location/widget.dart' as ui;
import 'package:digital_clock/ui/weather/widget.dart' as ui;

import 'themes/dark.dart' as themes;
import 'themes/light.dart' as themes;

class Clock extends StatefulWidget {
  final models.ClockModel clock;
  final models.Time time;

  const Clock({this.clock, this.time});

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  blocs.Clock clock;
  blocs.Settings settings;

  StreamController<bool> isReadyController;
  Stream<bool> isReady;

  @override
  void initState() {
    super.initState();

    isReadyController = StreamController<bool>();
    isReady = isReadyController.stream;

    settings = blocs.Settings(clock: widget.clock);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      clock = blocs.Clock(
          settings: settings,
          time: widget.time,
          positionLimitInHeight: MediaQuery.of(context).size.height,
          positionLimitInWidth: MediaQuery.of(context).size.width);

      for (List<models.Glyph> glyphs in clock.timeGlyphs.values) {
        clock.changeRandomPositionOfGlyphs(glyphs);
      }

      isReadyController.add(true);
    });
  }

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;

    if (!isDisposed) widget.time.dispose();

    clock.dispose();
    settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClipRect(
        child: Stack(
          children: <Widget>[
            _buildBackground(child: _buildClockLayout()),
            _buildWeather(Offset(45, 280)),
            _buildFrame(),
            _buildLocation(Offset(160, 5)),
          ],
        ),
      );

  Widget _buildFrame() => Positioned.fill(child: ui.Frame());

  Widget _buildBackground({Widget child}) => Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.light
            ? RadialGradient(colors: themes.Light.gradientBackground)
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themes.Dark.gradientBackground),
      ),
      child: child);

  Widget _buildClockLayout() => StreamBuilder<bool>(
        key: Key('clock_layout'),
        stream: isReady,
        initialData: false,
        builder: (context, snapshot) => snapshot.data
            ? _buildGradientClockGlyphsShadows(child: _buildClockGlyphs())
            : Container(),
      );

  Widget _buildClockGlyphs() => Stack(
        children: <Widget>[
          Stack(
              children: _buildTimeGlyphs(
                  timeGlyphsModels: clock.timeGlyphs.values.toList())),
          _buildDivider(key: Key('first_divider'), offset: Offset(220, 170)),
          _buildDivider(key: Key('second_divider'), offset: Offset(415, 170)),
        ],
      );

  Widget _buildGradientClockGlyphsShadows({Widget child}) => Stack(
        children: <Widget>[
          _buildClockGlyphShadow(offset: Offset(55, 150)),
          _buildClockGlyphShadow(offset: Offset(135, 150)),
          _buildClockGlyphShadow(offset: Offset(255, 150)),
          _buildClockGlyphShadow(offset: Offset(335, 150)),
          _buildClockGlyphShadow(offset: Offset(450, 150)),
          _buildClockGlyphShadow(offset: Offset(535, 150)),
          child,
        ],
      );

  Widget _buildClockGlyphShadow({Offset offset}) => Transform.translate(
        offset: offset,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: Theme.of(context).brightness == Brightness.light
                  ? themes.Light.glyphShadows
                  : themes.Dark.glyphShadows),
        ),
      );

  ui.Glyph _buildDivider({Offset offset, Key key}) => ui.Glyph(
        key: key,
        time: widget.time,
        glyph: models.Glyph(value: ':', maxScale: 8)
          ..changeScale(isMustBeScale: true)
          ..changeAutoAnimatePosition(isPositionMustBeAutoAnimate: false)
          ..changePosition(offset),
      );

  List<ui.Glyph> _buildTimeGlyphs({List<List<models.Glyph>> timeGlyphsModels}) {
    final _glyphs = <ui.Glyph>[];

    for (List<models.Glyph> glyphsModels in timeGlyphsModels) {
      for (models.Glyph glyph in glyphsModels) {
        final _glyph = ui.Glyph(glyph: glyph, time: widget.time);
        _glyphs.add(_glyph);
      }
    }

    return _glyphs;
  }

  Widget _buildLocation(Offset offset) =>
      Transform.translate(offset: offset, child: ui.Location(settings));

  Widget _buildWeather(Offset offset) =>
      Transform.translate(offset: offset, child: ui.Weather(settings));
}
