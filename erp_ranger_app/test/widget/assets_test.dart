
import 'package:erp_ranger_app/screens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget assetsWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new AssetsScreen(myAssets: false))
  );

  group('Assets Widget Tests', () {
    testWidgets('Assets Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(assetsWidget);

      final createdFinder = find.text('Flashlight 3');

      expect(createdFinder, findsOneWidget);
    });
  });

}
