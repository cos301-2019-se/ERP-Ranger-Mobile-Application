//The rangers screen displays a list of rangers currently in the park
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

class RangersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RangersState();
}

class RangersState extends State<RangersScreen> {

  Firestore _firestore = Firestore.instance;
  bool _loaded=false;
  ListView _rangers;

  //Creates ranger screen
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current rangers in park:',
              style: TextStyle(
                fontSize: 30.0,
                color: Color.fromRGBO(18, 27, 65, 1.0),
              ),
            ),
            Expanded(child:_showRangers())
          ],
        )
      ),
    );
  }

  //shows the list of rangers or a loading circle
  Widget _showRangers() {
    if(!_loaded)
    {
      _fetchRangersEntries();
    }
    if(_loaded) {
      return _rangers;
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

  //Fetches the rangers from firebase and creates list tiles for them
  void _fetchRangersEntries() async {
    String user = await Auth().getUserUid();
    List<Widget> entries = new List<Widget>();
    QuerySnapshot userQuerySnapshot = await _firestore.collection('users').getDocuments();
    List<DocumentSnapshot> userDocumentList = userQuerySnapshot.documents;

    QuerySnapshot patrolQuerySnapshot = await Firestore.instance.collection('patrol').where('park', isEqualTo: await Park.getParkId()).getDocuments();
    List<DocumentSnapshot> patrolDocumentList = patrolQuerySnapshot.documents;
    patrolDocumentList.removeWhere((a)=>a.data['end']!=null);

    print('user:'+userDocumentList.length.toString());
    print('patrol:'+patrolDocumentList.length.toString());

    bool alternate = true;
    patrolDocumentList.forEach((document)=>{
      print(document.data['end'])
    });

    for(DocumentSnapshot userDocument in userDocumentList) {
      if(patrolDocumentList.firstWhere((patrol)=>patrol.data['user']==userDocument.data['uid'], orElse: () => null)!=null)
      {
        var ref = FirebaseStorage.instance.ref().child('users/'+userDocument.data['uid']+'/'+userDocument.data['uid']);
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
        var image = NetworkImage(url);

        var backColor;
        var textColor;
        if(userDocument.data['uid']!=user){
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
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: GestureDetector(
                            child: CircleAvatar(
                              backgroundImage: image,
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: (){
                              _displayImage(image,userDocument.data['name']);
                            },
                          )
                      ),
                    ]
                ),
                title: new Text(
                  userDocument.data['name'],
                  style: TextStyle(
                      fontSize: 20,
                      color: textColor
                  ),
                ),
                trailing: new Text(
                  userDocument.data['points'].toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: textColor
                  ),
                ),
              )
          )
        );
      }
    };
    setState(() {
    _rangers = ListView(
        children: entries
    );
      _loaded=true;
    });
  }

  //Displays the profile image of the rangers
  void _displayImage(NetworkImage image,String user) async{
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
  }
}