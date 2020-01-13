import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';

void main() {
  group('Application', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    setUp(() async {
      await driver.waitForCondition(NoPendingFrame());
    });

    test('can auto animate position', () async {
      final firstTopLeftPosition = await driver.getTopLeft(find.text('0'));

      await Future.delayed(Duration(seconds: 1));

      final secondTopLeftPosition = await driver.getTopLeft(find.text('0'));

      expect(firstTopLeftPosition, isNot(secondTopLeftPosition));
    });
  });
}
