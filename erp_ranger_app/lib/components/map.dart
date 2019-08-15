import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'dart:async';
import 'dart:math';
import 'dart:core';

class MapComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapComponent> {

  Timer _timer;

  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  static Location _location = new Location();
  Firestore _firestore = Firestore.instance;

  @override
  void initState(){
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 30), (Timer t)=>_updateMarkers());
  }

  @override
  build(context) {
    return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 10),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
            compassEnabled: true,
            mapType: MapType.hybrid,
            markers: Set<Marker>.of(_markers.values),

          )
        ]
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _animateToPark();
    _updateMarkers();
    setState(() {
      _mapController = controller;
    });
  }

  _animateToPark() async {
    DocumentSnapshot document = await _firestore.collection('parks').document(await Park.getParkId()).get();

    GeoPoint pos = document.data['center'];

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 13.0,
        )
    )
    );
  }

  void _updateMarkers() async {
    QuerySnapshot querySnapshot = await _firestore.collection('markers').getDocuments();
    List<DocumentSnapshot> documentList = querySnapshot.documents;
    print(documentList);
    _markers.clear();
    documentList.forEach((DocumentSnapshot document) {

      GeoPoint pos = document.data['location']['geopoint'];
      String name = document.data['name'];
      int points = document.data['points'];
      String id = document.data['id'];

      final String markerIdVal = 'marker_id_$_markerIdCounter';
      _markerIdCounter++;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: name, snippet: '$points Points', onTap: (){_onMarkerTapped(id,pos);})
      );

      setState(() {
        _markers[markerId] = marker;
      });
      //Future.delayed(const Duration(seconds: 5), () {
      //  _updateMarkers();
      //});
    });
  }

  Future<void> _onMarkerTapped(String id, GeoPoint pos) async{
    switch (await showDialog(context: context,child:
      SimpleDialog(
      title: new Text('Activate marker?'),
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
            child: SizedBox(
                height: 40.0,
                child: new RaisedButton(
                    elevation: 5.0,
                    color: Colors.blue,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                    ),
                    child: Text(
                        'Yes',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        )
                    ),
                    onPressed: (){Navigator.pop(context, 'yes');}
                )
            )
        ),
        new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
            child: SizedBox(
                height: 40.0,
                child: new RaisedButton(
                    elevation: 5.0,
                    color: Colors.blue,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                    ),
                    child: Text(
                        'No',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        )
                    ),
                    onPressed: (){Navigator.pop(context, 'no');}
                )
            )
        )
      ],
    ))) {
      case 'yes':
        _logMarker(id, pos);
        break;
    }

    }

  void _logMarker(String id, GeoPoint pos) async{
    String user = await Auth().getUserUid();
    var _userPos = await _location.getLocation();
    var _latAngleDist = (((_userPos.latitude-pos.latitude).abs())/360)*2*pi*6378000;
    var _longAngleDist = (((_userPos.longitude-pos.longitude).abs())/360)*2*pi*6378000;
    var _distance = sqrt(pow(_latAngleDist,2)+pow(_longAngleDist,2));
    if(_distance<=10)
    {
      await Firestore.instance.collection('marker_log').add({
        "marker": id,
        "reward": 0,
        "time": new DateTime.now(),
        "user": user,
      });
      _updateMarkers();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
