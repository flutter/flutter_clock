import 'dart:math';

import 'package:snake_clock/model/pixel.dart';

/// Holds a list of pixels and a rectangle representing the drawing area.
class EmbeddedRectangle {
  final Rectangle rectangle;
  final List<PixelDisplay> pixels = [];

  EmbeddedRectangle(this.rectangle);
}
