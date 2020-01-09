import 'dart:ui';

import 'package:flutter/widgets.dart';

class Light {
  const Light();

  static List<Color> get gradientBackground =>
      const [Color(0xFFf4f8fd), Color(0xFFdee1f7)];

  static List<BoxShadow> get glyphShadows => [
        BoxShadow(color: Color(0xFFc46c95).withOpacity(0.5), blurRadius: 60),
        BoxShadow(color: Color(0xFF8e459a).withOpacity(0.3), blurRadius: 30),
      ];
}
