import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';

class ReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<ReportScreen> {
  final TextEditingController reportTextFieldController =
      new TextEditingController();
  final Geoflutterfire geoFlutterFire = Geoflutterfire();

  Location location = new Location();
  GeoFirePoint userPointLocation;
  DateTime now = DateTime.now();
  String reportDetails;
  String reportType = "Intruder";
  File imageOne;
  bool flagOne = false;
  File imageTwo;
  bool flagTwo = false;
  File imageThree;
  bool flagThree = false;
  bool reportFlag = false;
  bool uploading = false;

  Auth tempAuth = new Auth();
  String user;
  String park;

  void _performReport() async {
    setState(() {
      this.uploading = true;
    });

    park = await Park.getParkId();
    user = await tempAuth.getUserUid();

    var _userPos = await location.getLocation();
    userPointLocation = geoFlutterFire.point(//latitude: -25.762415, longitude: 28.234624);
        latitude: _userPos.latitude, longitude: _userPos.longitude);
    now = new DateTime.now();
    DocumentReference result = await Firestore.instance.collection('reports').add({
        "location": userPointLocation.data,
        "park": park,
        "report": reportDetails,
        "time": now,
        "type": reportType,
        "user": user,
      });

    _sendImages(result);

    reportTextFieldController.clear();
    Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context) => DashboardScreen()));
  }

  Future _sendImages(DocumentReference doc) async {
    if(flagOne) {
      StorageReference storageRefOne =
      FirebaseStorage.instance.ref().child(
          "reports/" + doc.documentID + '/1.jpeg');
      StorageUploadTask uploadTaskOne = storageRefOne.putFile(imageOne);
      StorageTaskSnapshot taskSnapshotOne = await uploadTaskOne.onComplete;
    }
    if(flagTwo) {
      StorageReference storageRefTwo =
      FirebaseStorage.instance.ref().child(
          "reports/" + doc.documentID + '/2.jpeg');
      StorageUploadTask uploadTaskTwo = storageRefTwo.putFile(imageTwo);
      StorageTaskSnapshot taskSnapshotTwo = await uploadTaskTwo.onComplete;
    }
    if(flagThree) {
      StorageReference storageRefThree =
      FirebaseStorage.instance.ref().child(
          "reports/" + doc.documentID + '/3.jpeg');
      StorageUploadTask uploadTaskThree = storageRefThree.putFile(imageThree);
      StorageTaskSnapshot taskSnapshotThree = await uploadTaskThree.onComplete;
    }
  }

  Future _pickImage(int num) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera);
    print("Picking image based on num");

    if(num == 1){
    setState(() {
      print("1 picked");
      imageOne = image;
      flagOne = true;
      print(imageOne.toString());
    });
    }
    if(num == 2){
      setState(() {
        print("2 picked");
        imageTwo = image;
        print(imageTwo);
        flagTwo = true;
      });
    }
    if(num == 3) {
      setState(() {
        print("3 picked");
        imageThree = image;
        print(imageThree);
        flagThree = true;
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
            _showReportButton(),
            this.uploading == true ? _showUploading() : new Container(),
          ],
        ),
      ),
    );
  }

  Widget _showReportTypeList() {
    return Card(
      child: new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
        child: new DropdownButtonHideUnderline(
          child: DropdownButton<String>(
          value: reportType,
          onChanged: (String value) {
            setState(() {
              reportType = value;
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

      ),
    );
  }

  Widget _showImagePicker() {
    return new Row(children: <Widget>[
      new Container(padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0), child: imageOne == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(1),) : Image.file(imageOne, height: 50.0, width: 100.0,)),
      new Container(padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0), child: imageTwo == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(2),) : Image.file(imageTwo, height: 50.0, width: 100.0,)),
      new Container(padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0), child: imageThree == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(3),) : Image.file(imageThree, height: 50.0, width: 100.0,))
    ],);
  }

  Widget _showReportTextField() {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextField(
          controller: reportTextFieldController,
          autofocus: true,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Report Details',
              labelStyle: TextStyle(fontSize: 25.0)),
          onChanged: (value) => this.reportDetails = value,
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
                onPressed: (){
                  if(this.uploading == false){
                    _performReport();
                  }
                  FocusScope.of(context).requestFocus(new FocusNode());},)));
  }

  Widget _showUploading() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          width: 50.0,
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
            ),
            height: 50.0,
            width: 50.0,
          ),
        )
    );
  }
}
