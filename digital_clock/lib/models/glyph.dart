import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Glyph {
  String id;
  String value;

  StreamController<Offset> positionChangeController;
  Stream<Offset> positionChange;

  StreamController<bool> scaleController;
  Stream<bool> scale;

  StreamController<bool> autoAnimatePositionChangeController;
  Stream<bool> autoAnimatePositionChange;

  double maxScale;
  int maxMoveRange;

  Glyph(
      {@required this.value,
      this.id,
      this.maxScale = 1,
      this.maxMoveRange = 100}) {
    id ??= Uuid().v4();

    positionChangeController = StreamController<Offset>();
    positionChange = positionChangeController.stream;

    scaleController = StreamController<bool>();
    scale = scaleController.stream;

    autoAnimatePositionChangeController = StreamController<bool>();
    autoAnimatePositionChange = autoAnimatePositionChangeController.stream;
  }

  void dispose() {
    positionChangeController.close();
    scaleController.close();
    autoAnimatePositionChangeController.close();
  }

  void changePosition(Offset offset) => positionChangeController.add(offset);

  // ignore: avoid_positional_boolean_parameters
  void changeScale(bool isMustBeScale) => scaleController.add(isMustBeScale);

  // ignore: avoid_positional_boolean_parameters
  void changeAutoAnimatePosition(bool isPositionMustBeAutoAnimate) =>
      autoAnimatePositionChangeController.add(isPositionMustBeAutoAnimate);
}
