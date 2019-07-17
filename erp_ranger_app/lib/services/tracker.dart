import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';

class Tracker {

  static Timer _timer;
  static bool _isTracking=false;
  static int _waitTime = 30; //in seconds

  static final Geoflutterfire _geoFlutterFire = Geoflutterfire();
  static Location _location = new Location();
  static GeoFirePoint _userPointLocation;
  static DateTime _now;

  static Auth tempAuth = new Auth();

  static void startTracking() async {
    if(!_isTracking) {
      _isTracking=true;
      sendLocation();
      _timer = Timer.periodic(Duration(seconds: _waitTime), (Timer t) => sendLocation());
    }
  }

  static void stopTracking() async {
    if(_isTracking) {
      _isTracking=false;
      _timer.cancel();
    }
  }

  static void sendLocation() async {
    var _userPos = await _location.getLocation();
    String user = await tempAuth.getUserUid();
    String park = await Park.getParkId();
    _userPointLocation = _geoFlutterFire.point(latitude: _userPos.latitude, longitude: _userPos.longitude);
    _now = new DateTime.now();
    await Firestore.instance.collection('position').add({
                                                        "time": _now,
                                                        "location": _userPointLocation.data,
                                                        "user": user,
                                                        "park": park
                                                      });
  }
}