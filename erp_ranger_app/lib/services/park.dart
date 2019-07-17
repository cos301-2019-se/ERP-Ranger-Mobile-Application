
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Park {

  static final Park _instance = new Park._internal();

  factory Park() {
    return _instance;
  }

  Park._internal();

  Firestore _firestore = Firestore.instance;

  CollectionReference read() {
    return this._firestore.collection('parks');
  }

  static Future<void> setParkId(String parkId) async {
    if (parkId != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('park', parkId);
    }
  }

  static Future<String> getParkId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('park');
  }

}