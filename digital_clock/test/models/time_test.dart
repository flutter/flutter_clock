import 'package:flutter_test/flutter_test.dart';

import 'package:digital_clock/models/time.dart' as models;

void main() {
  group('Time model', () {
    models.Time time;

    setUp(() {
      time = models.Time();
    });

    testWidgets('can update time parts and notify about that', (tester) async {
      final dateTime = time.dateTime;

      expect(time.hour.firstPart, isNull);
      expect(time.hour.lastPart, isNull);

      expect(time.minute.firstPart, isNull);
      expect(time.minute.lastPart, isNull);

      expect(time.second.firstPart, isNull);
      expect(time.second.lastPart, isNull);

      DateTime updatedDateTime;

      time.addListener(() => updatedDateTime = time.dateTime);

      await tester.runAsync(() => Future.delayed(Duration(seconds: 1)));

      expect(updatedDateTime, isNotNull);

//      expect(updatedDateTime.difference(dateTime).inSeconds, equals(1));
      expect(updatedDateTime.compareTo(dateTime), equals(1));

      expect(time.hour.firstPart, isNotNull);
      expect(time.hour.lastPart, isNotNull);

      expect(time.minute.firstPart, isNotNull);
      expect(time.minute.lastPart, isNotNull);

      expect(time.second.firstPart, isNotNull);
      expect(time.second.lastPart, isNotNull);

      final firstOfSecondPart = time.second.firstPart;
      final lastOfSecondPart = time.second.lastPart;

      await tester.runAsync(() => Future.delayed(Duration(seconds: 1)));

      expect(firstOfSecondPart == time.second.firstPart, isTrue);
      expect(lastOfSecondPart != time.second.lastPart, isTrue);
    });
  });
}
