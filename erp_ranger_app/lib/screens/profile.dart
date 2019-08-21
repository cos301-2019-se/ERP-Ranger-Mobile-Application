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

  static Firestore db = Firestore.instance;
  static CollectionReference userRef = db.collection('users');

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

  @override
  void initState() {
    loadInfo();
    super.initState();
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
            _showName(),
            _showEmail(),
            _showRole(),
            _showPoints(),
            this.loading == true ? _showLoading() : new Container(),
          ],
        ),
      ),
    );
  }

  Widget _showName(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
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
        onTap: () => {
          FocusScope.of(context).requestFocus(new FocusNode())
        },
      ),
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
          FocusScope.of(context).requestFocus(new FocusNode())
        },
      ),
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