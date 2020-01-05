import 'dart:math';

import 'package:digital_clock/pixel.dart';

class EmbeddedRectangle {
  final Rectangle rectangle;
  final List<PixelDisplay> pixels = [];

  EmbeddedRectangle(this.rectangle);
}