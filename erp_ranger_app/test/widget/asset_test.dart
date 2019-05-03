
import 'package:erp_ranger_app/screens/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget assetWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new AssetScreen())
  );

  group('Asset Widget Tests', () {
    testWidgets('Asset Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(assetWidget);

      final createdFinder = find.text('Asset Name');

      expect(createdFinder, findsOneWidget);
    });
  });

}
