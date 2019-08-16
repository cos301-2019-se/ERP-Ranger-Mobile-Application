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
import 'package:compressimage/compressimage.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeaderboardState();
}

class LeaderboardState extends State<LeaderboardScreen> {

  Firestore _firestore = Firestore.instance;
  bool _loaded=false;
  ListView _leaderboard;

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
        child: _showLeaderboard()
      ),
    );
  }

  Widget _showLeaderboard() {
    if(!_loaded)
    {
      _fetchLeaderboardEntries();
    }
    if(_loaded) {
      return _leaderboard;
    }
    else {
      return ListView(
        children: <Widget>[
          Padding(
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
          )
        ]
      );
    }
  }

  void _fetchLeaderboardEntries() async {
    List<Widget> entries = new List<Widget>();
    QuerySnapshot querySnapshot = await _firestore.collection('users').getDocuments();
    List<DocumentSnapshot> documentList = querySnapshot.documents;
    
    documentList.removeWhere((a)=>a.data['role']=='Admin');
    documentList.removeWhere((a)=>a.data['points']==null);
    documentList.sort((a,b)=>(b.data['points'].compareTo(a.data['points'])));
    
    bool alternate = true;
    var pos = 1;

    for(DocumentSnapshot document in documentList)/*documentList.forEach((DocumentSnapshot document)*/ {
      if(document.data['role']=='Ranger')
      {
        var ref = FirebaseStorage.instance.ref().child('users/'+document.data['uid']+'/'+document.data['uid']+'.jpg');
        var url = await ref.getDownloadURL();
        if(alternate) {
          entries.add(
              Card(
                  color: Color.fromRGBO(154, 126, 97, 1),
                  child: ListTile(
                    leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                  pos.toString(),
                                  style: TextStyle(
                                      fontSize: 30
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(url),
                                backgroundColor: Colors.transparent,
                              )
                          ),
                        ]
                    ),
                    title: new Text(
                      document.data['name'],
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    trailing: new Text(
                      document.data['points'].toString(),
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  )
              )
          );
          alternate=false;
        } else {
          entries.add(
              Card(
                  color: Color.fromRGBO(184, 156, 127, 1),
                  child: ListTile(
                    leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                  pos.toString(),
                                  style: TextStyle(
                                      fontSize: 30
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(url),
                                backgroundColor: Colors.transparent,
                              )
                          ),
                        ]
                    ),
                    title: new Text(
                      document.data['name'],
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    trailing: new Text(
                      document.data['points'].toString(),
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  )
              )
          );
          alternate=true;
        }
        pos++;
      }
    };
    setState(() {
    _leaderboard = ListView(
        children: entries
    );
      _loaded=true;
    });
  }
}