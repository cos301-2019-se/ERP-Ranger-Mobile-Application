import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/services/tracker.dart';

class patrolData {

  static final patrolData _instance = new patrolData._internal();

  factory patrolData() {
    return _instance;
  }

  patrolData._internal();

  static DateTime _start;

  static Future<void> switchPatrol() async{
    if(!(await patrolData.getIsOnPatrol())) {
      String user = await Auth().getUserUid();
      String park = await Park.getParkId();
      DocumentReference docRef = await Firestore.instance.collection('patrol')
          .add({
        "park": park,
        "start": new DateTime.now(),
        "user": user
      });
      await patrolData.setPatrolId(docRef.documentID);
      Tracker.startTracking();
      await patrolData.setIsOnPatrol(true);
    }
  }

  static Future<DateTime> getPatrolStart() async{
    if(await patrolData.getIsOnPatrol()) {
      if (_start == null) {
        String patrol = await patrolData.getPatrolId();
        var document = await Firestore.instance.collection('patrol').document(
            patrol).get();
        _start = document['start'].toDate();
      }
      return _start;
    }
    else {
      _start=null;
    }
  }

  static Future<void> setIsOnPatrol(bool isOnPatrol) async {
    if (isOnPatrol != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('isOnPatrol', isOnPatrol);
      if(isOnPatrol==false)
      {
        _start=null;
      }
    }
  }

  static Future<bool> getIsOnPatrol() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isOnPatrol = preferences.getBool('isOnPatrol');
    if (isOnPatrol != null) {
      return isOnPatrol;
    }
    else
    {
      setIsOnPatrol(false);
      return false;
    }
  }

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