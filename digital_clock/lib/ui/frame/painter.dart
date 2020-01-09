import 'package:flutter/material.dart';

class Frame extends CustomPainter {
  final Color firstColor;
  final Color firstShadowColor;

  final Color secondColor;
  final Color secondShadowColor;

  const Frame(
      {this.firstColor,
      this.firstShadowColor,
      this.secondColor,
      this.secondShadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    _buildFirstLayer(canvas, size);
  }

  void _buildFirstLayer(Canvas canvas, Size size) {
    makeBackground(canvas, size);
    makeForeground(canvas, size);
  }

  void makeBackground(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round
      ..color = secondColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round
      ..color = secondShadowColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke;

    const double padding = 25;

    final clipPath = Path()
      ..moveTo(padding, padding)
      ..cubicTo(240, padding / 2, width / 3 - 20, 60, width / 2, padding - 10)
      ..cubicTo(width / 2 + 160, padding, width / 2 + 180, 80,
          width - padding - 60, padding * 2)
      ..cubicTo(width + padding, padding - 30, width, height / 2 - 90, width,
          height / 2 + 40)
      ..cubicTo(width - padding + 60, height / 2 + 70, width - padding - 60,
          height / 2 + 100, width - padding, height - padding)
      ..cubicTo(width - padding - 90, height - 30, width - padding - 30,
          height + 10, width / 2 + 100, height - 20)
      ..cubicTo(width / 2 - 60, height - padding - 50, 120, height,
          padding - 30, height - 30)
      ..cubicTo(padding + 20, height - 70, padding + 40, height / 2 + 120,
          padding, height / 2)
      ..cubicTo(0, 120, 20, 80, padding, padding)
      ..close();

    final originPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    final path = Path.combine(PathOperation.difference, originPath, clipPath);

    canvas
      ..translate(6, 6)
      ..drawShadow(path, Colors.black.withOpacity(0.3), 2, true)
      ..drawPath(path, shadowPaint)
      ..translate(-6, -6)
      ..drawPath(path, paint)
      ..drawPath(path, borderPaint);
  }

  void makeForeground(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round
      ..color = firstColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round
      ..color = firstShadowColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke;

    const double padding = 10;

    final clipPath = Path()
      ..moveTo(padding + 30, padding)
      ..cubicTo(120, padding / 2, width / 3 - 60, 60, width / 2, padding + 20)
      ..cubicTo(width / 2 + 160, padding, width / 2 + 180, 60,
          width - padding - 60, padding * 2)
      ..cubicTo(width + padding, padding - 30, width, height / 2 - 90,
          width - padding, height / 2)
      ..cubicTo(width - padding + 30, height / 2 + 130, width - padding - 60,
          height / 2 + 100, width - padding, height - padding)
      ..cubicTo(width - padding - 90, height - 30, width - padding - 30,
          height + 10, width / 2 + 100, height - 20)
      ..cubicTo(width / 2 - 60, height - padding - 40, 120, height, padding,
          height - 30)
      ..cubicTo(padding + 20, height - 70, padding + 20, height / 2 + 80,
          padding, height / 2)
      ..cubicTo(0, 120, 20, 80, padding, padding)
      ..close();

    final originPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    final path = Path.combine(PathOperation.difference, originPath, clipPath);

    canvas
      ..translate(6, 6)
      ..drawShadow(path, Colors.black.withOpacity(0.3), 2, true)
      ..drawPath(path, shadowPaint)
      ..translate(-6, -6)
      ..drawPath(path, paint)
      ..drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
