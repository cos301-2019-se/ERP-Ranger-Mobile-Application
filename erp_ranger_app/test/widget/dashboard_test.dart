
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

      final finderIconMap = find.byIcon(Icons.map);
      final finderTextMap = find.text("Map");
      final finderIconReports = find.byIcon(Icons.message);
      final finderTextReports = find.text("Reports");
      final finderIconShifts = find.byIcon(Icons.date_range);
      final finderTextShifts = find.text("Shifts");
      final finderIconLeaderboard = find.byIcon(Icons.stars);
      final finderTextLeaderboard = find.text("Leaderboard");
      final finderIconRangers = find.byIcon(Icons.directions_walk);
      final finderTextRangers = find.text("Rangers");

      expect(finderIconMap, findsOneWidget);
      expect(finderTextMap, findsOneWidget);
      expect(finderIconReports, findsOneWidget);
      expect(finderTextReports, findsOneWidget);
      expect(finderIconShifts, findsOneWidget);
      expect(finderTextShifts, findsOneWidget);
      expect(finderIconLeaderboard, findsOneWidget);
      expect(finderTextLeaderboard, findsOneWidget);
      expect(finderIconRangers, findsOneWidget);
      expect(finderTextRangers, findsOneWidget);
    });
  });

}
