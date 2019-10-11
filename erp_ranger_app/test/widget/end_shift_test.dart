
import 'package:erp_ranger_app/screens/endShift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget endShiftWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new EndOfShiftScreen())
  );

  group('End Shift Widget Tests', () {
    testWidgets('End Shift Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(endShiftWidget);

      final createdFinder = find.text('Feedback to report?');

      expect(createdFinder, findsOneWidget);
    });
  });

}
