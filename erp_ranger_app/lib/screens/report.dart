import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class ReportScreen extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<ReportScreen> {
  final TextEditingController _reportTextFieldController = new TextEditingController();
  final DatabaseReference _firebaseDatabase = FirebaseDatabase.instance.reference();
  final Geolocator _geolocator = Geolocator();

  Position _userLocation;
  DateTime _now;
  String _reportDetails;
  String _reportType;

  void _performReport() async {
    _userLocation = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _now = new DateTime.now();
    _firebaseDatabase.push().set({"location": _userLocation,
      "park": "Rietvlei",
      "report": _reportDetails,
      "time": _now,
      "type": _reportType,
      "user": 1});
    _reportTextFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    _firebaseDatabase.child("reports");
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
            _showReportDetails(),
            _showReportTypeList(),
            _showReportTextField(),
            _showReportButton()
          ],
        ),
      ),
    );
  }

  Widget _showReportDetails() {
    _now = new DateTime.now();
    return RichText (
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.blue
        ),
        children: <TextSpan>[
          new TextSpan(text: 'Park:\n'),
          new TextSpan(text: 'Rietvlei\n',style: new TextStyle(fontSize: 15.0,color: Colors.black)),
          new TextSpan(text: 'Date:\n'),
          new TextSpan(text: _now.day.toString()+'-'+_now.month.toString()+'-'+_now.year.toString()+'\n',style: new TextStyle(fontSize: 15.0,color: Colors.black)),
          new TextSpan(text: 'Time:\n'),
          new TextSpan(text: _now.hour.toString()+':'+_now.minute.toString(),style: new TextStyle(fontSize: 15.0,color: Colors.black)),
        ]
      )
    );
  }

  Widget _showReportTypeList() {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child:DropdownButton<String>(
          value: _reportType,
          onChanged: (String value) {
            setState(() {
              _reportType = value;
            });
          },
          items: <String>['Damage to property', 'Harmed animal', 'Intruder', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
              .toList(),
        ),
    );
  }

  Widget _showReportTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child:TextField(
        controller: _reportTextFieldController,
        autofocus: true,
        autocorrect: true,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Report Details',
          labelStyle: TextStyle(
            fontSize: 25.0
          )
        ),
        onChanged: (value) => this._reportDetails = value,
      )
    );
  }

  Widget _showReportButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: SizedBox(
              height: 40.0,
              child: new RaisedButton(
                  elevation: 5.0,
                  color: Colors.blue,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)
                  ),
                  child: Text(
                      'Report',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      )
                  ),
                  onPressed: _performReport
              )
          )
      );
    }
}
