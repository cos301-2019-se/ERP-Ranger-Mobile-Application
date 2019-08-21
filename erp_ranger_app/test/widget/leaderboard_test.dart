
import 'package:erp_ranger_app/screens/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget assetWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new LeaderboardScreen())
  );

  group('Leaderboard Widget Tests', () {
    testWidgets('Leaderboard Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(assetWidget);

      final createdFinder = find.byType(ListView);

      expect(createdFinder, findsOneWidget);
    });
  });

}
