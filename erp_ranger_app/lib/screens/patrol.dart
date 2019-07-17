import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/services/tracker.dart';

class PatrolScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PatrolState();
}

class PatrolState extends State<PatrolScreen> {

  bool isTracking=false;

  static Auth tempAuth = new Auth();

  void _startPatrol() async{
    String user = await tempAuth.getUserUid();
    String park = await Park.getParkId();
    await Firestore.instance.collection('patrol').add({
      "park": park,
      "start": new DateTime.now(),
      "user": user
    });
    Tracker.startTracking();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Start Patrol"),
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
                  _showStartPatrolButton()
                ],
              );
            }
          }
        )
      ),
    );
  }

  Widget _showStartPatrolButton() {
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
                    'Start Patrol',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                    )
                ),
                onPressed: _startPatrol
            )
        )
    );
  }
}
