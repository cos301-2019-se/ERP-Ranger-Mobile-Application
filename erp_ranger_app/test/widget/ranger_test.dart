
import 'package:erp_ranger_app/screens/ranger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget rangerWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new RangersScreen())
  );

  group('Ranger Widget Tests', () {
    testWidgets('Ranger Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(rangerWidget);

      final finderText = find.text('Current rangers in park:');
      final finderListView = find.byType(ListView);

      expect(finderText, findsOneWidget);
      expect(finderListView, findsOneWidget);
    });
  });

}
