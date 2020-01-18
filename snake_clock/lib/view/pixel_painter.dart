import 'dart:math';

import 'package:flutter/cupertino.dart';

/// All Pixels are given as a percentage of the overall size. (ie. 0 - 1)
class PixelPainter extends CustomPainter {
  final Iterable<Point> pixels;
  final Color color;
  final num pixelWidth;
  final num pixelHeight;

  PixelPainter(this.pixels, this.color, this.pixelWidth, this.pixelHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;

    final width = pixelWidth * size.width;
    final height = pixelHeight * size.height;

    pixels.forEach((pixel) => canvas.drawRect(
        Rect.fromLTWH(
            pixel.x * size.width, pixel.y * size.height, width, height),
        paint));
  }

  @override
  bool shouldRepaint(PixelPainter oldDelegate) {
    return true;
  }
}
