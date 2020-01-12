import 'dart:ui';

import 'package:flutter/widgets.dart';

class Dark {
  const Dark();

  static List<Color> get gradientBackground => [
        Color(0xFFa55950),
        Color(0xFF6f2e6b),
        Color(0xFF4a275d),
        Color(0xFF382746)
      ];

  static List<BoxShadow> get glyphShadows => [
        BoxShadow(color: Color(0xFFa146ac).withOpacity(0.2), blurRadius: 30),
        BoxShadow(color: Color(0xFF783566).withOpacity(0.8), blurRadius: 60),
      ];
}
