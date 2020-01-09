import 'dart:ui';

class Light {
  const Light();

  static Color get foregroundColor => const Color(0xFFc46c95);

  static List<Color> get foregroundGradientColor =>
      const [Color(0xFFe0a984), Color(0xFFc46c95), Color(0xFF8e459a)];

  static List<Shadow> get shadow => const [
        Shadow(
          offset: Offset(0.1, 0.1),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.2),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.3),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.4),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.5),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.6),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.7),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.8),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.9),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
        Shadow(
          offset: Offset(0.1, 0.10),
          blurRadius: 1,
          color: Color(0xFFe6dff0),
        ),
      ];
}
