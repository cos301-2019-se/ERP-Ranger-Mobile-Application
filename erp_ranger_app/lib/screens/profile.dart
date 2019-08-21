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
  String user = "Name";
  String email = "Email";
  String park = "CurrentPark";
  String role = "Role";

  static Firestore db = Firestore.instance;
  static CollectionReference userRef = db.collection('users');



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
            _showPark(),
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
        maxLength: 1,
        maxLengthEnforced: true,
        decoration: new InputDecoration(
            labelText: user,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        onTap: () => {},
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
        maxLength: 1,
        maxLengthEnforced: true,
        decoration: new InputDecoration(
            labelText: email,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        onTap: () => {},
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
        maxLength: 1,
        maxLengthEnforced: true,
        decoration: new InputDecoration(
            labelText: role,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        onTap: () => {},
      ),
    );
  }

  Widget _showPark(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        key: Key('Text'),
        maxLines: 1,
        enabled: true,
        maxLength: 1,
        maxLengthEnforced: true,
        decoration: new InputDecoration(
            labelText: park,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        onTap: () => {},
      ),
    );
  }
}