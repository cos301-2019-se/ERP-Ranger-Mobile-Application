import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class Tracker {

  static Timer _timer;
  static bool _isTracking=false;
  static int _waitTime = 1; //in minutes

  static final Geoflutterfire _geoFlutterFire = Geoflutterfire();
  static Location _location = new Location();
  static GeoFirePoint _userPointLocation;
  static DateTime _now;


  static void startTracking() async {
    if(!_isTracking) {
      _isTracking=true;
      sendLocation();
      _timer = Timer.periodic(Duration(minutes: _waitTime), (Timer t) => sendLocation());
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
    _userPointLocation = _geoFlutterFire.point(latitude: _userPos.latitude, longitude: _userPos.longitude);
    _now = new DateTime.now();
    await Firestore.instance.collection('position').add({
                                                        "time": _now,
                                                        "location": _userPointLocation.data,
                                                        "user": "gQvk9DfM0KSrdSONKfXtnLJ6e0P2",
                                                        "park": "iwGnWNuDC3m1hRzNNBT5"
                                                      });
  }
}