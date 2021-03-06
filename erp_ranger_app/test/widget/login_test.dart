
import 'package:erp_ranger_app/login.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget loginWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new LoginScreen(auth: new Auth()))
  );

  group('Login Widget Tests', () {
    testWidgets('Login Widget take input and reacts to it', (WidgetTester tester) async {
      await tester.pumpWidget(loginWidget);

      await tester.enterText(find.byKey(Key('email_input')), 'test');
      await tester.enterText(find.byKey(Key('password_input')), 'test');

      await tester.tap(find.byType(RaisedButton));

      await tester.pumpAndSettle();

      final validFinder = find.text('Please enter a valid email and password.');
      
      expect(validFinder, findsOneWidget);
    });
  });

}
