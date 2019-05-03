
import 'package:erp_ranger_app/screens/shifts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget shiftsWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new ShiftsScreen())
  );

  group('Shifts Widget Tests', () {
    testWidgets('Shifts Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(shiftsWidget);

      final createdFinder = find.text('Monday - 22/04/2019');

      expect(createdFinder, findsOneWidget);
    });

    testWidgets('Shifts Widget has a second tab', (WidgetTester tester) async {
      await tester.pumpWidget(shiftsWidget);

      await tester.tap(find.text('All Shifts'));
      await tester.pumpAndSettle();
      final tabFinder = find.text('April');

      expect(tabFinder, findsOneWidget);
    });
  });

}
