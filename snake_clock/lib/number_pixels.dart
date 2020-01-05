import 'dart:math';

import 'package:digital_clock/pixel.dart';

const _pixelWidthCount = 13;
const _pixelHeightCount = 27;

/// Creates the pixels for a given [number]
///
/// Pixels will be adjusted based on the given [rectangle]
List<PixelDisplay> createNumberPixels(Rectangle rectangle, int number) {
  assert(number <= 9 && number >= 0);

  final pixelWidth = rectangle.width / _pixelWidthCount;
  final pixelHeight = rectangle.height / _pixelHeightCount;
}

const zero = [
  [4, 5, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 21, 22],
  [3, 6, 9, 13, 17, 20, 23],
  [2, 4, 5, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 21, 22, 24],
  [1, 3, 23, 25],
  [0, 2, 24, 26],
  [0, 2, 24, 26],
  [1, 25],
  [0, 2, 24, 26],
  [0, 2, 24, 26],
  [1, 3, 23, 25],
  [4, 5, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 21, 22],
  [3, 6, 9, 13, 17, 20, 23],
  [2, 4, 5, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 21, 22, 24]
];

const one = [
  [7, 9],
  [6, 8],
  [5, 7],
  [5, 7],
  [4, 6],
  [3, 5],
  [3, 5],
  [2, 4],
  [1, 3],
  [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25],
  [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26],
  [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26],
  [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25],
];

const two = [];

const three = [];

const four = [];

const five = [];

const six = [];

const seven = [];

const eight = [];

const nine = [];
