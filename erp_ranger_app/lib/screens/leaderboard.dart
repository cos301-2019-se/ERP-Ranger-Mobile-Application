//The leaderboard displays a list of rangers ordered by their points
import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/patrolData.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:compressimage/compressimage.dart';
import 'package:erp_ranger_app/services/auth.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeaderboardState();
}

class LeaderboardState extends State<LeaderboardScreen> {

  Firestore _firestore = Firestore.instance;
  bool _loaded=false;
  ListView _leaderboard;

  //creates the leaderboard screen
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

  //shows the list of rangers
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

  //fetches the data from firebase and creates listtiles for each ranger
  void _fetchLeaderboardEntries() async {
    String user = await Auth().getUserUid();
    List<Widget> entries = new List<Widget>();

    QuerySnapshot querySnapshotPoints = await Firestore.instance.collection('marker_log').where('time', isGreaterThanOrEqualTo: await patrolData.getPatrolStart()).getDocuments();
    List<DocumentSnapshot> documentListPoints = querySnapshotPoints.documents;
    int points=0;
    documentListPoints.forEach((DocumentSnapshot document){
      if(document['user']==user) {
        points += document['reward'];
      }
    });

    QuerySnapshot querySnapshot = await _firestore.collection('users').getDocuments();
    List<DocumentSnapshot> documentList = querySnapshot.documents;
    
    documentList.removeWhere((a)=>a.data['role']=='Admin');
    documentList.removeWhere((a)=>a.data['points']==null);
    documentList.firstWhere((a)=>a.data['uid']==user).data['points']+=points;
    documentList.sort((a,b)=>(b.data['points'].compareTo(a.data['points'])));
    
    bool alternate = true;
    var pos = 1;

    for(DocumentSnapshot document in documentList)/*documentList.forEach((DocumentSnapshot document)*/ {
      //print('users/'+document.data['uid']+'/'+document.data['uid']);
      if(document.data['role']=='Ranger')
      {
        /*var ref = FirebaseStorage.instance.ref().child('users/'+document.data['uid']+'/'+document.data['uid']);
        var url;
        try
        {
          url =  await ref.getDownloadURL();
        }
        catch(e)
        {
            ref = FirebaseStorage.instance.ref().child('users/default/default.png');// + document.data['uid'] + '/' + document.data['uid'] + '.jpg');
            url = await ref.getDownloadURL();
        }
        var image = NetworkImage(url);*/

        var backColor;
        var textColor;
        if(document.data['uid']!=user){
          if(alternate) {
            backColor = Color.fromRGBO(154, 126, 97, 1);
            textColor = Colors.black;
            alternate=false;
          }else {
            backColor = Color.fromRGBO(184, 156, 127, 1);
            textColor = Colors.black;
            alternate=true;
          }
        }
        else{
          backColor = Color.fromRGBO(18, 27, 65, 1.0);
          textColor = Colors.white;
          alternate=(!alternate);
        }
        entries.add(
            Card(
                color: backColor,
                child: ListTile(
                  leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Text(
                                pos.toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    color: textColor
                                )
                            )
                        ),
                        /*Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: GestureDetector(
                              child: CircleAvatar(
                                backgroundImage: image,
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: (){
                                _displayImage(image,document.data['name']);
                              },
                            )
                        ),*/
                      ]
                  ),
                  title: new Text(
                    document.data['name'],
                    style: TextStyle(
                        fontSize: 20,
                        color: textColor
                    ),
                  ),
                  trailing: new Text(
                    document.data['points'].toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color: textColor
                    ),
                  ),
                )
            )
        );
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

  //displays the image of the ranger
  /*void _displayImage(NetworkImage image,String user) async{
    double width = MediaQuery.of(context).size.width;
    showDialog(context: context, child:
      SimpleDialog(
        title: Text(
          user,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black
          )
        ),
        children: <Widget>[
          Image(image: image)//,height: width/1.5,width: width/1.5,)
        ],
      )
    );
  }*/
}