import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:compressimage/compressimage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:erp_ranger_app/services/patrolData.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<ReportScreen> {
  final TextEditingController reportTextFieldController =
      new TextEditingController();
  final Geoflutterfire geoFlutterFire = Geoflutterfire();

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
  bool _reportFlag = false;
  bool _uploading = false;
  Duration _delayTime = new Duration(seconds: 2);
  QuerySnapshot _querySnapshot;
  static Firestore _db = Firestore.instance;

  Auth tempAuth = new Auth();
  String user;
  String park;
  String patrol;
  bool _handled = false;
  final GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _reportTypes = new List<String>();
  bool _loading = true;

  //Sends all the given data to the database.
  void _performReport() async {
    setState(() {
      this._uploading = true;
    });

    park = await Park.getParkId();
    user = await tempAuth.getUserUid();
    patrol = await patrolData.getPatrolId();

    var _userPos = await _location.getLocation();
    _userPointLocation = geoFlutterFire.point(//latitude: -25.762415, longitude: 28.234624);
        latitude: _userPos.latitude, longitude: _userPos.longitude);
    _now = new DateTime.now();
    var result = await Firestore.instance.collection('reports').add({
        "location": _userPointLocation.data,
        "park": park,
        "patrol": patrol,
        "report": _reportDetails,
        "time": _now,
        "type": _reportType,
        "user": user,
        "Handled" : _handled,
      }).then((result) => {
      _sendImages(result),
      Fluttertoast.showToast(msg: "Success"),
      //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Success'))),
      //Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Success'))),
      Timer(this._delayTime, () {
        Navigator.pop(context);
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new DashboardScreen()));}),
    });


  }

  //Sends the images taken by the user.
  Future _sendImages(DocumentReference doc) async {
    if(_flagOne) {
      StorageReference storageRefOne =
      FirebaseStorage.instance.ref().child(
          "reports/" + doc.documentID + '/1.jpeg');
      StorageUploadTask uploadTaskOne = storageRefOne.putFile(_imageOne);
      StorageTaskSnapshot taskSnapshotOne = await uploadTaskOne.onComplete;
    }
    if(_flagTwo) {
      StorageReference storageRefTwo =
      FirebaseStorage.instance.ref().child(
          "reports/" + doc.documentID + '/2.jpeg');
      StorageUploadTask uploadTaskTwo = storageRefTwo.putFile(_imageTwo);
      StorageTaskSnapshot taskSnapshotTwo = await uploadTaskTwo.onComplete;
    }
    if(_flagThree) {
      StorageReference storageRefThree =
      FirebaseStorage.instance.ref().child(
          "reports/" + doc.documentID + '/3.jpeg');
      StorageUploadTask uploadTaskThree = storageRefThree.putFile(_imageThree);
      StorageTaskSnapshot taskSnapshotThree = await uploadTaskThree.onComplete;
    }
  }

  //Shows the image picker to the user and compresses the resulting image
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
      await CompressImage.compress(imageSrc: _imageOne.path, desiredQuality: 80);
      setState(() {
        _imageOne;
      });
    }
    if(num == 2){
      setState(() {
        print("2 picked");
        _imageTwo = image;
        print(_imageTwo);
        _flagTwo = true;
      });
      await CompressImage.compress(imageSrc: _imageTwo.path, desiredQuality: 80);
      setState(() {
        _imageTwo;
      });
    }
    if(num == 3) {
      setState(() {
        print("3 picked");
        _imageThree = image;
        print(_imageThree);
        _flagThree = true;
      });
      await CompressImage.compress(imageSrc: _imageThree.path, desiredQuality: 80);
      setState(() {
        _imageThree;
      });
    }

  }

  //removes the appropriate image based on which remove button was pressed.
  Future _removeImage(int num) async {
    if(num == 1){
      setState(() {
        _imageOne = null;
        _flagOne = false;
      });
    }
    if(num == 2){
      setState(() {
        _imageTwo = null;
        _flagTwo = false;
      });
    }
    if(num == 3){
      setState(() {
        _imageThree = null;
        _flagThree = false;
      });
    }
  }

  Future<void> getCategories() async {
    _querySnapshot = await _db.collection('report_types').getDocuments();

    for (int i = 0; i < _querySnapshot.documents.length; i++) {
      _reportTypes.add(_querySnapshot.documents.elementAt(i).data['type']);
    }

    setState(() {
      this._loading = false;
    });
  }

  void initialFunctions(BuildContext context){
    getCategories();
    setState(() {

    });
  }

  @override
  void initState(){
    initialFunctions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
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
            _showRemoveImage(),
            _showReportTextField(),
            _showReportButton(),
            this._uploading == true ? _showUploading() : new Container(),
          ],
        ),
      ),
    );
  }

  Widget _showReportTypeList() {
    if(_loading) {
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
    } else {
      return Card(
        child: new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _reportType,
              onChanged: (String value) {
                setState(() {
                  _reportType = value;
                });
              },
              items: _reportTypes.map<DropdownMenuItem<String>>((String value) {
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
  }

  Widget _showImagePicker() {
    return new Row(children: <Widget>[
      new Container(padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0), width: 110, height: 100, child: _imageOne == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(1),) : Image.file(_imageOne, height: 100.0, width: 110.0,)),
      new Container(padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0), width: 110, height: 100, child: _imageTwo == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(2),) : Image.file(_imageTwo, height: 100.0, width: 110.0,)),
      new Container(padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0), width: 110, height: 100, child: _imageThree == null ? RaisedButton(child: Icon(Icons.add_a_photo),onPressed: () => _pickImage(3),) : Image.file(_imageThree, height: 100.0, width: 110.0,))
    ],);
  }

  Widget _showRemoveImage() {
    return new Row(children: <Widget>[
      new Container(padding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),),
      new Container(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0), width: 60, height: 30, child: _imageOne != null ? RaisedButton(color: Color.fromRGBO(200, 0, 0, 1.0), shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)), child: Icon(Icons.close),onPressed: () => _removeImage(1),) : null),
      new Container(padding: EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),),
      new Container(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0), width: 60, height: 30, child: _imageTwo != null ? RaisedButton(color: Color.fromRGBO(200, 0, 0, 1.0), shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)), child: Icon(Icons.close),onPressed: () => _removeImage(2),) : null),
      new Container(padding: EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),),
      new Container(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0), width: 60, height: 30, child: _imageThree != null ? RaisedButton(color: Color.fromRGBO(200, 0, 0, 1.0), shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)), child: Icon(Icons.close),onPressed: () => _removeImage(3),) : null),
    ],);
  }

  Widget _showReportTextField() {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        height: 250,
        child: TextField(
          key: Key('Text'),
          controller: reportTextFieldController,
          autofocus: true,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          maxLines: 8,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Report Details',
              labelStyle: TextStyle(fontSize: 25.0)),
          onChanged: (value) => this._reportDetails = value,
        ));
  }

  Widget _showReportButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: SizedBox(
            height: 40.0,
            child: new RaisedButton(
                elevation: 5.0,
                color: Color.fromRGBO(18, 27, 65, 1.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Text('Report',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: (){
                  if(this._uploading == false){
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
