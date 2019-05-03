
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget dashboardWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new DashboardScreen())
  );

  group('Dashboard Widget Tests', () {
    testWidgets('Dashboard Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(dashboardWidget);

      final createdFinder = find.text('Log Feedback');

      expect(createdFinder, findsOneWidget);
    });
  });

}
