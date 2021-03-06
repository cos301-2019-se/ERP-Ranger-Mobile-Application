
import 'package:erp_ranger_app/screens/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget reportWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new ReportScreen())
  );

  group('Report Widget Tests', () {
    testWidgets('Report Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(reportWidget);

      await tester.tap(find.byType(RaisedButton));
      await tester.enterText(find.byKey(Key('Text')), 'test');
      await tester.tap(find.byType(DropdownButtonHideUnderline));

      await tester.pumpAndSettle();
      final createdFinder = find.text('Report');
      expect(createdFinder, findsOneWidget);
    });
  });

}
