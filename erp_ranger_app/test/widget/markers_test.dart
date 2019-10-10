
import 'package:erp_ranger_app/screens/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {

  Widget markersWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new MarkersScreen())
  );

  group('Markers Widget Tests', () {
    testWidgets('Markers Widget is generated', (WidgetTester tester) async {
      await tester.pumpWidget(markersWidget);

      final finderGoogleMap = find.byType(GoogleMap);
      final finderButton = find.byType(FloatingActionButton);

      expect(finderGoogleMap, findsOneWidget);
      expect(finderButton, findsOneWidget);
    });
  });

}
