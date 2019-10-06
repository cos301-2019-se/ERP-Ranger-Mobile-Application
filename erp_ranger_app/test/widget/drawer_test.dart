
import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget drawerWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new CustomDrawer())
  );

  group('Drawer Widget Tests', () {
    testWidgets('Drawer Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(drawerWidget);

      final finderIconHome = find.byIcon(Icons.home);
      final finderTextHome = find.text("Home");
      final finderIconReports = find.byIcon(Icons.message);
      final finderTextReports = find.text("Reports");
      final finderIconShifts = find.byIcon(Icons.date_range);
      final finderTextShifts = find.text("Shifts");
      final finderIconLeaderboard = find.byIcon(Icons.stars);
      final finderTextLeaderboard = find.text("Leaderboard");
      final finderIconRangers = find.byIcon(Icons.directions_walk);
      final finderTextRangers = find.text("Rangers");
      final finderIconLogout = find.byIcon(Icons.exit_to_app);
      final finderTextLogout= find.text("Logout");

      expect(finderIconHome, findsOneWidget);
      expect(finderTextHome, findsOneWidget);
      expect(finderIconReports, findsOneWidget);
      expect(finderTextReports, findsOneWidget);
      expect(finderIconShifts, findsOneWidget);
      expect(finderTextShifts, findsOneWidget);
      expect(finderIconLeaderboard, findsOneWidget);
      expect(finderTextLeaderboard, findsOneWidget);
      expect(finderIconRangers, findsOneWidget);
      expect(finderTextRangers, findsOneWidget);
      expect(finderIconLogout, findsOneWidget);
      expect(finderTextLogout, findsOneWidget);
    });
  });

}
