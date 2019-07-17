import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/services/tracker.dart';
import 'package:erp_ranger_app/services/patrolData.dart';
import 'package:erp_ranger_app/screens/feedback.dart';

class PatrolScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PatrolState();
}

class PatrolState extends State<PatrolScreen> {

  static String _buttonText;
  static Auth _tempAuth = new Auth();

  void _switchPatrol() async{
    if(!patrolData.isOnPatrol) {
      setState(() {
        _buttonText="End Shift";
      });
      String user = await _tempAuth.getUserUid();
      String park = await Park.getParkId();
      DocumentReference docRef = await Firestore.instance.collection('patrol')
          .add({
        "park": park,
        "start": new DateTime.now(),
        "user": user
      });
      await patrolData.setPatrolId(docRef.documentID);
      Tracker.startTracking();
      patrolData.isOnPatrol=true;
      setState(() {

      });
    }
    else
    {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new FeedbackScreen()));
      patrolData.isOnPatrol=false;
    }
  }

  void _setButtonText()
  {
    if(patrolData.isOnPatrol)
    {
      _buttonText = "End Patrol";
    }
    else
    {
      _buttonText = "Start Patrol";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Patrol"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: CustomDrawer(),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            int i = index;
            if (i == 0) {
              return new Column(
                children: <Widget>[
                  _showPatrolButton()
                ],
              );
            }
          }
        )
      ),
    );
  }

  Widget _showPatrolButton() {
    _setButtonText();
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
                    _buttonText,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                    )
                ),
                onPressed: _switchPatrol
            )
        )
    );
  }
}
