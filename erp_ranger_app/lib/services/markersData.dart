import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';

class markersData {

  static final markersData _instance = new markersData._internal();

  factory markersData() {
    return _instance;
  }

  markersData._internal();

  static Future<void> addMarker(String id) async {
    if (id != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String> markers = preferences.getStringList('markers');
      if (markers == null) {
        markers=[];
      }
      markers.add('{"id":"'+id+'","time":"'+DateTime.now().toIso8601String()+'"}');
      preferences.setStringList('markers', markers);
    }
  }

  static Future<void> sendMarkers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> markers = preferences.getStringList('markers');
    if (markers != null) {
      String user = await Auth().getUserUid();
      for(String markerStr in markers){
        var marker = json.decode(markerStr);
        await Firestore.instance.collection('marker_log').add({
          "marker": marker['id'],
          "reward": 0,
          "time": DateTime.parse(marker['time']),
          "user": user,
        });
      }
    }
    preferences.remove('markers');
  }
}