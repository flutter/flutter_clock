import 'dart:math';

import 'package:snake_clock/model/number_pixels.dart';

const clockDisplayWidth = .65;
const clockDisplayHeight = .65;
const clockDisplayLeft = (1 - clockDisplayWidth) / 2;
const clockDisplayTop = (1 - clockDisplayHeight) / 2;

const outerDisplayRadius = 1.5;
const innerDisplayRadius = sqrt1_2;

const pixelWidth = clockDisplayWidth * 0.19 / pixelWidthCount;
const pixelHeight = clockDisplayHeight * 0.5 / pixelHeightCount;

const explosionAnimationTime = 1;
const explosionHeight = -0.35;
const innerPixelCount = 60 - explosionAnimationTime;
const degreeDivision = 2 * pi / innerPixelCount;

const translationPoint = Point(0.5, 0.5);
