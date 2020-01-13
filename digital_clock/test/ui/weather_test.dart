import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_clock_helper/model.dart' as models;
import 'package:digital_clock/blocs/settings.dart' as blocs;
import 'package:digital_clock/ui/weather/widget.dart' as ui;

void main() {
  group('Weather widget', () {
    models.ClockModel clock;
    blocs.Settings settings;

    setUp(() {
      clock = models.ClockModel();
      settings = blocs.Settings(clock: clock);
    });

    testWidgets('can change weather and temperature by settings event',
        (tester) async {
      final widget = ui.Weather(settings);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      const firstWeather = models.WeatherCondition.sunny;
      const firstTemperature = 1;

      clock
        ..weatherCondition = firstWeather
        ..temperature = firstTemperature;

      await tester.pumpAndSettle();

      expect(find.text('Sunny'), findsOneWidget);
      expect(find.text('1.0°C'), findsOneWidget);

      const secondWeather = models.WeatherCondition.snowy;
      const secondTemperature = 2;

      clock
        ..weatherCondition = secondWeather
        ..temperature = secondTemperature;

      await tester.pumpAndSettle();

      expect(find.text('Sunny'), findsNothing);
      expect(find.text('1.0°C'), findsNothing);

      expect(find.text('Snowy'), findsOneWidget);
      expect(find.text('2.0°C'), findsOneWidget);
    });
  });
}
