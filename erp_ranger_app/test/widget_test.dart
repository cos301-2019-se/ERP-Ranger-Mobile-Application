
import 'package:flutter_test/flutter_test.dart';

import 'widget/asset_test.dart' as asset_test;
import 'widget/assets_test.dart' as assets_test;
import 'widget/end_shift_test.dart' as end_shift_test;
import 'widget/login_test.dart' as login_test;
import 'widget/dashboard_test.dart' as dashboard_test;
import 'widget/report_test.dart' as report_test;
import 'widget/shifts_test.dart' as shifts_test;
import 'widget/ranger_test.dart' as ranger_test;

void main() {

  group('Widget Tests', () {
    login_test.main();
    dashboard_test.main();
    report_test.main();
    shifts_test.main();
    //asset_test.main();
    //assets_test.main();
    end_shift_test.main();
    ranger_test.main();
  });

}

