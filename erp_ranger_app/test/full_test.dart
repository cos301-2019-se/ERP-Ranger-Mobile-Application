
import 'package:test_api/test_api.dart';

import 'integration_test.dart' as integration_test;
import 'unit_test.dart' as unit_test;
import 'widget_test.dart' as widget_test;

void main() {

  group('Full Test', () {
    unit_test.main();
    widget_test.main();
    integration_test.main();
  });

}