import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:digital_clock/models/time.dart' as models;
import 'package:digital_clock/models/glyph.dart' as models;

import 'themes/dark.dart' as theme;
import 'themes/light.dart' as theme;

class Glyph extends StatefulWidget {
  final models.Glyph glyph;
  final models.Time time;

  const Glyph({Key key, this.glyph, this.time}) : super(key: key);

  @override
  _GlyphState createState() => _GlyphState();
}

class _GlyphState extends State<Glyph> with TickerProviderStateMixin {
  AnimationController animationScaleController;
  Animation animationScale;

  StreamController<DateTime> dateTimeController;
  Stream<DateTime> dateTime;

  Random random;

  @override
  void initState() {
    super.initState();

    random = Random();

    dateTimeController = StreamController();
    dateTime = dateTimeController.stream.asBroadcastStream();

    widget.time.addListener(updateByTime);

    try {
      animationScaleController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));

      animationScale = Tween<double>(begin: 1, end: widget.glyph.maxScale)
          .animate(animationScaleController);
    } on TickerCanceled catch (_) {}
  }

  @override
  void dispose() {
    dateTimeController.close();
    widget.time.removeListener(updateByTime);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildLayout();

  void updateByTime() => dateTimeController.add(widget.time.dateTime);

  Widget _buildGlyph() => Text(widget.glyph.value.toString(),
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? theme.Light.foregroundColor
            : theme.Dark.foregroundColor,
      ));

  Widget _buildGlyphWithShadowAndGradient() => ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.light
                    ? theme.Light.foregroundGradientColor
                    : theme.Dark.foregroundGradientColor)
            .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(widget.glyph.value.toString(),
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Spectral',
                shadows: Theme.of(context).brightness == Brightness.light
                    ? theme.Light.shadow
                    : theme.Dark.shadow)),
      );

  Widget _buildLayout() => Container(
        key: Key('glyph_${widget.glyph.value}_${widget.glyph.id}'),
        child: _buildControllerPositionedGlyph(
          child: _buildControllerScaleGlyph(
            child: StreamBuilder<bool>(
                stream: widget.glyph.autoAnimatePositionChange,
                initialData: true,
                builder: (context, snapshot) => snapshot.data
                    ? _buildAutoAnimatePositionGlyph()
                    : _buildGlyphWithShadowAndGradient()),
          ),
        ),
      );

  Widget _buildControllerPositionedGlyph({Widget child}) =>
      StreamBuilder<Object>(
          builder: (context, snapshot) => StreamBuilder<Offset>(
              stream: widget.glyph.positionChange,
              initialData: Offset(0, 0),
              builder: (context, snapshot) => AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  top: snapshot.data.dy,
                  left: snapshot.data.dx,
                  child: child)));

  Widget _buildControllerScaleGlyph({Widget child}) => StreamBuilder<bool>(
      stream: widget.glyph.scale,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data) {
          animationScaleController.forward().orCancel;
        } else {
          animationScaleController.reverse().orCancel;
        }

        return ScaleTransition(scale: animationScale, child: child);
      });

  Widget _buildAutoAnimatePositionGlyph() => StreamBuilder<DateTime>(
      stream: dateTime,
      builder: (context, snapshot) => SizedBox(
            width: widget.glyph.maxMoveRange.toDouble(),
            height: widget.glyph.maxMoveRange.toDouble(),
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                AnimatedPositioned(
                    duration: Duration(milliseconds: 3000),
                    curve: Curves.elasticOut,
                    top: random.nextInt(widget.glyph.maxMoveRange).toDouble(),
                    left: random.nextInt(widget.glyph.maxMoveRange).toDouble(),
                    child: _buildGlyph()),
              ],
            ),
          ));
}
