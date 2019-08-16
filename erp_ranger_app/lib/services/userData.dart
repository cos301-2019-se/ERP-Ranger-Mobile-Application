import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class userData {

  static final userData _instance = new userData._internal();

  factory userData() {
    return _instance;
  }

  userData._internal();

  static String _name;
  static String _email;
  static NetworkImage _image;

  static void reset()
  {
    _name=null;
    _email=null;
    _image=null;
  }

  static Future<String> getUserName() async {
    if(_name!=null) {
      return _name;
    }
    else {
      Auth _tempAuth = new Auth();
      String user = await _tempAuth.getUserUid();
      var document = await Firestore.instance.collection('users').document(user).get();
      _name = document['name'];
      return _name;
    }
  }

  static Future<String> getUserEmail() async {
    if(_email!=null) {
      return _email;
    }
    else {
      Auth _tempAuth = new Auth();
      String user = await _tempAuth.getUserUid();
      var document = await Firestore.instance.collection('users').document(user).get();
      _email = document['email'];
      return _email;
    }
  }

  static Future<NetworkImage> getUserImage() async {
    if(_image!=null) {
      return _image;
    }
    else {
      Auth _tempAuth = new Auth();
      String user = await _tempAuth.getUserUid();
      var ref = FirebaseStorage.instance.ref().child('users/'+user+'/'+user+'.jpg');
      var url = await ref.getDownloadURL();
      _image = NetworkImage(url);
      return _image;
    }
  }
}