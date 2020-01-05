import 'dart:math';

/// Holds the information on how to display a pixel, the basic building
/// block of the snake clock.
class PixelDisplay {
  PixelDisplay(this.id);

  final List<Point> list = [];
  final int id;

  /// Creates a point that is a linear interpolation between the first
  /// and second point of this.
  ///
  /// [value] refers to the current point in this linear interpolation. If
  /// this is 1, will automatically remove the first point.
  ///
  /// [addedY] is added in full to the midpoint of the interpolation, falling
  /// to zero at either end.
  Point createPoint(double value, [double addedY]) {
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

    final deltaY = (1 - (0.5 - value).abs() * 2) * addedY;

    final interpolation = list[0] * (1 - value) + list[1] * value;

    return Point(interpolation.x, interpolation.y + deltaY);
  }
}

/// Keeps track of the id to be used in new [PixelDisplay]s
class PixelDisplayCounter {
  final List<int> _unusedIds = [];
  int _currentId = 0;

  int getNextInSequence() =>
      _unusedIds.isEmpty ? _currentId++ : _unusedIds.removeAt(0);

  /// Returns the [val] to the possible ids for [PixelDisplay]
  void setIdToUnused(int val) => _unusedIds.add(val);
}
