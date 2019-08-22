import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';

class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfileScreen> {
  Auth profileAuth = new Auth();
  String id;
  String user = "Name";
  String email = "Email";
  String points = "CurrentPoints";
  String role = "Role";
  QuerySnapshot storage;
  bool loading = true;
  bool passwordChange = false;
  bool nameChange = false;
  FocusNode changeFocusNode = new FocusNode();
  TextEditingController changeController = new TextEditingController();

  static Firestore db = Firestore.instance;
  static CollectionReference userRef = db.collection('users');
  final TextEditingController textController = new TextEditingController();

  Future<void> loadInfo() async{
    id = await profileAuth.getUserUid();
    storage = await db.collection('users').where('uid', isEqualTo: id).getDocuments();

    user = storage.documents.elementAt(0).data['name'];
    email = storage.documents.elementAt(0).data['email'];
    points = storage.documents.elementAt(0).data['points'];
    role = storage.documents.elementAt(0).data['role'];

    setState(() {
      loading = false;
    });
  }

  void changePassword(){
    if(!this.passwordChange) {
      this.passwordChange = true;
    } else {
      this.passwordChange = false;
    }
    setState(() {

    });
  }

  Future<void> sendPasswordEmail() async{
    profileAuth.getAuth().sendPasswordResetEmail(email: this.email);
    this.passwordChange = false;
    setState(() {

    });
  }

  Future<void> changeName() async {
    if(!nameChange){
      this.nameChange = true;
      setState(() {

      });
      FocusScope.of(context).requestFocus(changeFocusNode);
    } else {
      this.nameChange = false;
      setState(() {

      });
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  Future<void> uploadName() async {
    this.nameChange = false;
    print("TextController value: " + changeController.text);
    var result = await db.collection('users').document(id).updateData({'name': changeController.text});
    changeController.clear();
    loadInfo();

    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    changeFocusNode.dispose();
    super.dispose();
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
            this.loading == true ? _showLoading() : new Container(),
            _showName(),
            _showChangeName(),
            this.nameChange == true? _showConfirmNewName() : new Container(),
            _showEmail(),
            //_showChangeEmail(),
            _showRole(),
            _showPoints(),
            _showChangePassword(),
            this.passwordChange == true? _showConfirmNewPassword() : new Container(),
          ],
        ),
      ),
    );
  }

  Widget _showName(){
    if(!nameChange) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          controller: changeController,
          focusNode: changeFocusNode,
          key: Key('Text'),
          maxLines: 1,
          enabled: true,
          decoration: new InputDecoration(
              labelText: user,
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.accessibility,
                color: Colors.grey,
              )),
          onTap: () =>
          {
            FocusScope.of(context).requestFocus(new FocusNode())
          },
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          focusNode: changeFocusNode,
          controller: changeController,
          key: Key('Text'),
          maxLines: 1,
          enabled: true,
          decoration: new InputDecoration(
              labelText: 'Enter new name:',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.accessibility,
                color: Colors.grey,
              )),
        ),
      );
    }
  }

  Widget _showChangeName(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
          color: Color.fromRGBO(18, 27, 65, 1.0),
          child: Text('Change name',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () => {changeName()},
        ),
      ),
    );
  }

  Widget _showConfirmNewName(){
    return Row(
      children: <Widget>[
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(18, 27, 65, 1.0), child: Text("Confirm", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {uploadName(),}),),),
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(200, 0, 0, 1.0), child: Text("Cancel", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {changeName()}),),)
      ],
    );
  }

  Widget _showEmail(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        key: Key('Text'),
        maxLines: 1,
        enabled: true,
        decoration: new InputDecoration(
            labelText: email,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        onTap: () => {
          FocusScope.of(context).requestFocus(new FocusNode())
        },
      ),
    );
  }

/*
  Widget _showChangeEmail(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
          color: Color.fromRGBO(18, 27, 65, 1.0),
          child: Text('Change email',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () => {},
        ),
      ),
    );
  }
*/

  Widget _showRole(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        key: Key('Text'),
        maxLines: 1,
        enabled: true,
        decoration: new InputDecoration(
            labelText: role,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.terrain,
              color: Colors.grey,
            )),
        onTap: () => {
         FocusScope.of(context).requestFocus(new FocusNode())
        },
      ),
    );
  }

  Widget _showPoints(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        key: Key('Text'),
        maxLines: 1,
        enabled: true,
        decoration: new InputDecoration(
            labelText: points,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.monetization_on,
              color: Colors.grey,
            )),
        onTap: () => {
          FocusScope.of(context).requestFocus(new FocusNode()),
        }
      ),
    );
  }

  Widget _showChangePassword(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
          color: Color.fromRGBO(18, 27, 65, 1.0),
          child: Text('Change password',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () => {
            changePassword(),
          },
        ),
      ),
    );
  }

  Widget _showConfirmNewPassword(){
    return Row(
      children: <Widget>[
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(18, 27, 65, 1.0), child: Text("Confirm", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {sendPasswordEmail(),}),),),
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(200, 0, 0, 1.0), child: Text("Cancel", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {changePassword()}),),)
      ],
    );
  }

  Widget _showLoading() {
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