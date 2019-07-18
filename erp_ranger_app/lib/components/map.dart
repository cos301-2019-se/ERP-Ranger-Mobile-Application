import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapComponent> {

  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;

  Location location = new Location();

  Firestore _firestore = Firestore.instance;

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
          ),
        ]
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _animateToUser();
    _updateMarkers();
    setState(() {
      _mapController = controller;
    });
  }


  _animateToUser() async {
    var pos = await location.getLocation();

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 17.0,
        )
    )
    );
  }

  _animateToPark() async {
    var pos = await location.getLocation();

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 17.0,
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

      final String markerIdVal = 'marker_id_$_markerIdCounter';
      _markerIdCounter++;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: name, snippet: '$points Points'),
      );

      setState(() {
        _markers[markerId] = marker;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

}
