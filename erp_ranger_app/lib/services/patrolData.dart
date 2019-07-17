import 'package:shared_preferences/shared_preferences.dart';

class patrolData {

  static final patrolData _instance = new patrolData._internal();

  factory patrolData() {
    return _instance;
  }

  patrolData._internal();

  static Future<void> setPatrolId(String patrolId) async {
    if (patrolId != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('patrol', patrolId);
    }
  }

  static Future<String> getPatrolId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('patrol');
  }

}