import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_clock_helper/model.dart' as models;
import 'package:digital_clock/blocs/settings.dart' as blocs;
import 'package:digital_clock/ui/location/widget.dart' as ui;

void main() {
  group('Location widget', () {
    models.ClockModel clock;
    blocs.Settings settings;

    setUp(() {
      clock = models.ClockModel();
      settings = blocs.Settings(clock: clock);
    });

    testWidgets('can change location by settings event', (tester) async {
      final widget = ui.Location(settings);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      const firstLocation = 'Mountain View, CA';
      clock.location = firstLocation;
      await tester.pumpAndSettle();
      expect(find.text(firstLocation), findsOneWidget);

      const secondLocation = 'Moscow';
      clock.location = secondLocation;
      await tester.pumpAndSettle();
      expect(find.text(firstLocation), findsNothing);
      expect(find.text(secondLocation), findsOneWidget);
    });
  });
}
