
import 'package:flutter_test/flutter_test.dart';

import 'widget/login_test.dart' as login_test;
import 'widget/dashboard_test.dart' as dashboard_test;
import 'widget/report_test.dart' as report_test;
import 'widget/shifts_test.dart' as shifts_test;

void main() {

  group('Widget Tests', () {
    login_test.main();
    dashboard_test.main();
    report_test.main();
    shifts_test.main();
  });

}

