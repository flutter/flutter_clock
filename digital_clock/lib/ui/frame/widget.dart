import 'dart:ui';

import 'package:flutter/material.dart';

import 'painter.dart' as painters;

import 'themes/dark.dart' as themes;
import 'themes/light.dart' as themes;

class Frame extends StatelessWidget {
  @override
  Widget build(
          BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? CustomPaint(
              painter: painters.Frame(
                  firstColor: themes.Light.foreground,
                  firstShadowColor: themes.Light.foregroundShadow,
                  secondColor: themes.Light.background,
                  secondShadowColor: themes.Light.backgroundShadow))
          : CustomPaint(
              painter: painters.Frame(
                  firstColor: themes.Dark.foreground,
                  firstShadowColor: themes.Dark.foregroundShadow,
                  secondColor: themes.Dark.background,
                  secondShadowColor: themes.Dark.backgroundShadow));
}
