//The map component displays a map with markers on it to show the different point
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/services/markersData.dart';
import 'package:erp_ranger_app/services/patrolData.dart';
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

  MapType _defaultMapType = MapType.normal;

  @override
  void initState(){
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 300), (Timer t)=>_updateMarkers());
  }

  //creates the Map component
  @override
  build(context) {
    return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 10),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
            compassEnabled: true,
            mapType: _defaultMapType,//MapType.hybrid,
            markers: Set<Marker>.of(_markers.values),

          ),
          Container(
            margin: EdgeInsets.only(top: 80, right: 10),
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.layers),
                  elevation: 5,
                  backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
                  onPressed: () {
                    _changeMapType();
                  }
                ),
              ]
            ),
          )
        ]
    );
  }

  //A function to swap the map type
  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _animateToPark();
    _updateMarkers();
    setState(() {
      _mapController = controller;
    });
  }

  //moves the view to the location of the park
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

  //updates the markers and adds them to the map
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
        icon: BitmapDescriptor.fromAsset("assets/images/markers.png"),
        onTap: (){_onMarkerTapped(id,name,points,pos);}
        /*infoWindow: InfoWindow(
              title: name,
              snippet: '$points Points',
              onTap: (){_onMarkerTapped(id,pos);}
            )*/
      );

      setState(() {
        _markers[markerId] = marker;
      });
      //Future.delayed(const Duration(seconds: 5), () {
      //  _updateMarkers();
      //});
    });
  }

  //opens a dialog screen allowing for the activation of a marker
  Future<void> _onMarkerTapped(String id, String name, int points, GeoPoint pos) async {
    switch (await showDialog(context: context, child:
    SimpleDialog(
      title: new Text(name),
      children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
            child: SizedBox(
                height: 40.0,
                child: new Text(
                    'Points: '+points.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                    )
                )
            )
        ),
        new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
            child: SizedBox(
                height: 40.0,
                child: new Text(
                    'Activate marker?',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                    )
                )
            )
        ),
        new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
            child: SizedBox(
                height: 40.0,
                child: new RaisedButton(
                    elevation: 5.0,
                    color: Color.fromRGBO(18, 27, 65, 1.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)
                    ),
                    child: Text(
                        'Yes',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        )
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'yes');
                    }
                )
            )
        ),
        new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
            child: SizedBox(
                height: 40.0,
                child: new RaisedButton(
                    elevation: 5.0,
                    color: Color.fromRGBO(18, 27, 65, 1.0),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)
                    ),
                    child: Text(
                        'No',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        )
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'no');
                    }
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

  //adds the marker points to firebase
  void _logMarker(String id, GeoPoint pos) async{
    if(await patrolData.getIsOnPatrol()) {
      String patrol = await patrolData.getPatrolId();
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
          "patrol": patrol,
        });
        //markersData.addMarker(id);
        _updateMarkers();
        showDialog(context: context, child:
        SimpleDialog(
          title: new Text(
              'Activated Marker',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black
              )
          ),
        )
        );
      }
      else {
        showDialog(context: context, child:
        SimpleDialog(
          title: new Text(
              'You must be within 10m of the marker',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red
              )
          ),
        )
        );
      }
    }
    else  {
      showDialog(context: context, child:
      SimpleDialog(
        title: new Text(
            'You must be on patrol',
            style: TextStyle(
                color: Colors.red
            )
        ),
      )
      );
    }

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
