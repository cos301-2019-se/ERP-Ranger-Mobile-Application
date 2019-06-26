import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<ReportScreen> {
  final TextEditingController _reportTextFieldController =
      new TextEditingController();
  final Geoflutterfire _geoFlutterFire = Geoflutterfire();

  Location _location = new Location();
  GeoFirePoint _userPointLocation;
  DateTime _now = DateTime.now();
  String _reportDetails;
  String _reportType = "Intruder";
  File _imageOne;
  bool _flagOne = false;
  File _imageTwo;
  bool _flagTwo = false;
  File _imageThree;
  bool _flagThree = false;

  void _performReport() async {
    var _userPos = await _location.getLocation();
    _userPointLocation = _geoFlutterFire.point(
        latitude: _userPos.latitude, longitude: _userPos.longitude);
    _now = new DateTime.now();

    await Firestore.instance.collection('reports').add({
      "location": _userPointLocation.data,
      "park": "iwGnWNuDC3m1hRzNNBT5",
      "report": _reportDetails,
      "time": _now,
      "type": _reportType,
      "user": "gQvk9DfM0KSrdSONKfXtnLJ6e0P2"
    });
    _reportTextFieldController.clear();
  }

  Future _pickImage(int num) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera);
    print("Picking image based on num");

    if(num == 1){
    setState(() {
      print("1 picked");
      _imageOne = image;
      _flagOne = true;
      print(_imageOne.toString());
    });
    }
    if(num == 2){
      setState(() {
        print("2 picked");
        _imageTwo = image;
        _flagTwo = true;
      });
    }
    if(num == 3) {
      setState(() {
        print("3 picked");
        _imageThree = image;
        _flagThree = true;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("ERP Ranger Mobile App"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: new CustomDrawer(),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
        child: ListView(
          children: <Widget>[
            _showReportTypeList(),
            _showImagePicker(),
            _showReportTextField(),
            _showReportButton()
          ],
        ),
      ),
    );
  }

  Widget _showReportTypeList() {
    return Card(
      child: new Padding(
        padding: EdgeInsets.fromLTRB(85.0, 15.0, 65.0, 0.0),
        child: DropdownButton<String>(
          value: _reportType,
          onChanged: (String value) {
            setState(() {
              _reportType = value;
            });
          },
          items: <String>[
            'Damage to property',
            'Harmed animal',
            'Intruder',
            'Other'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _showImagePicker() {
    return new Row(children: <Widget>[
      new Container(padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0), child: _imageOne == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(1),) : Image.file(_imageOne, height: 50.0, width: 100.0,)),
      new Container(padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0), child: _imageTwo == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(2),) : Image.file(_imageTwo, height: 50.0, width: 100.0,)),
      new Container(padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0), child: _imageThree == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(3),) : Image.file(_imageThree, height: 50.0, width: 100.0,))
    ],);
  }

  Widget _showReportTextField() {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextField(
          controller: _reportTextFieldController,
          autofocus: true,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Report Details',
              labelStyle: TextStyle(fontSize: 25.0)),
          onChanged: (value) => this._reportDetails = value,
        ));
  }

  Widget _showReportButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: SizedBox(
            height: 40.0,
            child: new RaisedButton(
                elevation: 5.0,
                color: Color.fromRGBO(18, 27, 65, 1.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: Text('Report',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: _performReport)));
  }
}
