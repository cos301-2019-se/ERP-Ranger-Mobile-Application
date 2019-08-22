
import 'package:erp_ranger_app/screens/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget feedbackWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new FeedbackScreen())
  );

  group('Feedback Widget Tests', () {
    testWidgets('Feedback Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(feedbackWidget);

      final finderTextField = find.byType(TextField);
      final finderButton = find.byType(RaisedButton);

      expect(finderTextField, findsOneWidget);
      expect(finderButton, findsOneWidget);
    });
  });

}
