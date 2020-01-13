import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_clock_helper/model.dart' as models;

import 'package:digital_clock/models/time.dart' as models;
import 'package:digital_clock/screens/clock/widget.dart' as screens;

void main() {
  group('Clock screen widget', () {
    models.ClockModel clock;
    models.Time time;

    setUp(() async {
      clock = models.ClockModel();
      time = models.Time();

      await Future.delayed(Duration(seconds: 1));
    });

    testWidgets('can show time', (tester) async {
      final widget = screens.Clock(clock: clock, time: time);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      await tester.pump();

      expect(find.text(time.hour.firstPart), findsWidgets);
      expect(find.text(time.hour.lastPart), findsWidgets);

      expect(find.text(time.minute.firstPart), findsWidgets);
      expect(find.text(time.minute.lastPart), findsWidgets);

      expect(find.text(time.second.firstPart), findsWidgets);
      expect(find.text(time.second.lastPart), findsWidgets);
    });

    testWidgets('can show weather', (tester) async {
      final widget = screens.Clock(clock: clock, time: time);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.byKey(Key('weather')), findsOneWidget);
    });

    testWidgets('can show frame', (tester) async {
      final widget = screens.Clock(clock: clock, time: time);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.byKey(Key('frame')), findsOneWidget);
    });

    testWidgets('can show location', (tester) async {
      final widget = screens.Clock(clock: clock, time: time);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.byKey(Key('location')), findsOneWidget);
    });
  });
}
