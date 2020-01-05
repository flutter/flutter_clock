import 'dart:math';

class PixelDisplay {
  PixelDisplay(this.id);

  final List<Point> list = [];
  final int id;

  Point createPoint(double value) {
    if (list.length == 1) {
      return list[0];
    }

    assert(value >= 0 && value <= 1);

    if (value >= 1) {
      list.removeAt(0);

      return list[0];
    }

    if (value == 0) {
      return list[0];
    }

    return list[0] * (1 - value) + list[1] * value;
  }
}
