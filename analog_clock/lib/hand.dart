// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A base class for an analog clock hand-drawing widget.
///
/// This only draws one hand of the analog clock. Put it in a [Stack] to have
/// more than one hand.
abstract class Hand extends StatelessWidget {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const Hand({
    @required this.color,
    @required this.size,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(size != null),
        assert(angleRadians != null);

  /// Hand color.
  final Color color;

  /// Hand length, as a percentage of the smaller side of the clock's parent
  /// container.
  final double size;

  /// The angle, in radians, at which the hand is drawn.
  ///
  /// This angle is measured from the 12 o'clock position.
  final double angleRadians;
}
