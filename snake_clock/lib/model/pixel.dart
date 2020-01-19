import 'dart:math';

/// Automatically creates pixels with the initial value being the [points].
///
/// [counter] is used to add the ids to the units.
Iterable<PixelDisplay> createPixelDisplayFromPoints(
        List<Point> points, PixelDisplayCounter counter) =>
    points.map((x) => PixelDisplay(counter.getNextInSequence())..list.add(x));

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
  Point createPoint(double value, [double addedY = 0]) {
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

    if (addedY == 0) {
      return list[0] * (1 - value) + list[1] * value;
    }

    final midPoint = (list[0] + list[1]) * 0.5;
    final extraPoint = Point(midPoint.x, midPoint.y + addedY);

    //return list[0] * (1 - value) + list[1] * value;
    return list[0] * pow((1 - value), 2) +
        extraPoint * 2 * (1 - value) * value +
        list[1] * pow(value, 2);
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
