import 'dart:math';

import 'package:snake_clock/model/embedded_rectangle.dart';
import 'package:snake_clock/model/pixel.dart';
import 'package:snake_clock/view/constants.dart';
import 'package:tuple/tuple.dart';

final clockDisplayRadius =
    sqrt(pow(clockDisplayWidth / 2, 2) + pow(clockDisplayHeight / 2, 2));

class PixelSheet {
  final List<PixelDisplay> outerDisplay = [];
  final List<PixelDisplay> innerDisplay = [];

  final pointGenerator = PixelSheetPointGenerator();

  PixelSheet();

  int currentSecond = 0;

  /// Creates the initial display for when the clock is first shown.
  void createInitialDisplay(PixelDisplayCounter counter) {
    clearDisplay(counter);

    final initialPoints = pointGenerator.generatePoints(innerPixelCount, true);

    innerDisplay.addAll(createPixelDisplayFromPoints(initialPoints, counter));
  }

  /// Inherit the points in the [rectangle], taking random points from the list for the
  /// inner and outer sheets.
  void inheritPixelDisplays(
      PixelDisplayCounter counter, List<EmbeddedRectangle> rectangle) {
    clearDisplay(counter);

    final pixelsList = rectangle.expand((val) => val.pixels).toList();
    pixelsList.shuffle();

    final innerSheet = pixelsList.sublist(0, innerPixelCount);
    final outerSheet = pixelsList.sublist(innerPixelCount);

    final innerPoints = pointGenerator.generatePoints(innerPixelCount, true);
    final outerPoints = pointGenerator.generatePoints(outerSheet.length, false);

    addPointsToPixels(innerSheet, innerPoints);
    addPointsToPixels(outerSheet, outerPoints);

    innerDisplay.addAll(innerSheet);
    outerDisplay.addAll(outerSheet);
  }

  /// Updates the animation and culls specific portions based on animation count.
  void updateSecond(PixelDisplayCounter counter, int second) {
    currentSecond = second;

    if (second < explosionAnimationTime) {
      return;
    }

    if (outerDisplay.isNotEmpty) {
      outerDisplay.forEach((val) => counter.setIdToUnused(val.id));
      outerDisplay.clear();
    }

    final newCount = 60 - second - explosionAnimationTime + 1;
    if (newCount > innerDisplay.length) {
      return;
    }

    /// Cull points that should no longer be displayed.
    if (newCount < innerDisplay.length) {
      final deltaCount = innerDisplay.length - newCount;

      final subList = innerDisplay.sublist(0, deltaCount);
      innerDisplay.removeRange(0, deltaCount);

      subList.forEach((val) => counter.setIdToUnused(val.id));
    }

    innerDisplay.forEach((val) => val.list.removeRange(0, val.list.length - 1));

    if (innerDisplay.length > 1) {
      innerDisplay[0].list.add(innerDisplay[1].list[0]);
    } else if (innerDisplay.isNotEmpty) {
      innerDisplay[0].list.add(Point(0.5, 0.5));
    }
  }

  /// Clears the display and removes it from the [counter].
  void clearDisplay(PixelDisplayCounter counter) {
    outerDisplay.forEach((val) => counter.setIdToUnused(val.id));
    innerDisplay.forEach((val) => counter.setIdToUnused(val.id));

    outerDisplay.clear();
    innerDisplay.clear();
  }

  Iterable<Point> createPoints(double animation) {
    return <PixelDisplay>[...outerDisplay, ...innerDisplay]
        .map<Point>((val) => val.createPoint(animation, explosionHeight));
  }
}

void addPointsToPixels(List<PixelDisplay> pixels, List<Point> points) {
  assert(pixels.length == points.length);

  for (int i = 0; i < pixels.length; i++) {
    pixels[i].list.add(points[i]);
  }
}

class PixelSheetPointGenerator {
  /// List containing the boundaries of the [innerPixelCount] in <outer, inner, clockdisplay>
  final List<Tuple3<Point, Point, Point>> _referenceSheet = [];

  final random = Random();

  int count = 0;

  PixelSheetPointGenerator() {
    for (int i = 0; i < innerPixelCount; i++) {
      final radians = i * degreeDivision;
      final vector = Point(cos(radians), sin(radians));

      final outerLimit = vector * outerDisplayRadius;
      final innerLimit = limitPoint(vector, innerDisplayRadius, 0.5, 0.5);
      final clockDisplayLimit = limitPoint(vector, clockDisplayRadius,
          clockDisplayWidth / 2, clockDisplayHeight / 2);

      _referenceSheet.add(Tuple3(outerLimit + translationPoint,
          innerLimit + translationPoint, clockDisplayLimit + translationPoint));
    }
  }

  /// Generates [number] points that belong on the pixel sheet.
  ///
  /// [inner] determines whether it is being generated for the inner display or outer display.
  List<Point> generatePoints(int number, bool inner) {
    final retVal = <Point>[];

    while (number-- > 0) {
      final reference = _referenceSheet[count];

      final dist = random.nextDouble();
      final interpolation = reference.item2 * (1 - dist) +
          (inner ? reference.item3 : reference.item1) * dist;

      retVal.add(interpolation);

      count = (count + 1) % innerPixelCount;
    }
    return retVal;
  }
}

/// Limits the point (from [vector] and [radius]) to only be a specific absolute value from the
/// [xLimit] and [yLimit].
Point limitPoint(Point vector, double radius, double xLimit, double yLimit) =>
    Point(limitCoord(vector.x * radius, xLimit),
        limitCoord(vector.y * radius, yLimit));

double limitCoord(double coord, double limit) =>
    coord > 0 ? min(coord, limit) : max(coord, -limit);
