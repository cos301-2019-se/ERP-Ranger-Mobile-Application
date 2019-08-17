import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/patrolData.dart';
import 'package:erp_ranger_app/services/tracker.dart';
import 'package:erp_ranger_app/screens/patrol.dart';
import 'package:erp_ranger_app/services/auth.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FeedbackState();
}

class FeedbackState extends State<FeedbackScreen> {

  final TextEditingController _feedbackTextFieldController = new TextEditingController();
  DateTime _now;
  DateTime _start;
  int _points=0;//will get from app user data
  String _feedbackDetails;
  bool _loaded=false;
  bool _sent=false;

  FeedbackState()
  {
    _getPatrolStart().then((onValue)=>setState((){
      _start=onValue;
    }));
  }

  String _displayDateTime(DateTime t) {
    if (t != null) {
      if (t.minute == 0) {
        return t.hour.toString() + ":00";
      } else if (t.minute < 10) {
        return t.hour.toString() + ":0" + t.minute.toString();
      } else {
        return t.hour.toString() + ":" + t.minute.toString();
      }
    } else {
      return "";
    }
  }

  Future<DateTime> _getPatrolStart() async {
    String patrol = await patrolData.getPatrolId();
    var document = await Firestore.instance.collection('patrol').document(patrol).get();
    _start = document['start'].toDate();
    await _getPatrolPoints();
    setState(() {
      _loaded=true;
    });
    return _start;
  }

  Future<void> _getPatrolPoints() async {
    String user = await Auth().getUserUid();
    QuerySnapshot querySnapshot = await Firestore.instance.collection('marker_log').where('time', isGreaterThanOrEqualTo: _start).getDocuments();
    List<DocumentSnapshot> documentList = querySnapshot.documents;
    int count=0;
    documentList.forEach((DocumentSnapshot document){
      if(document['user']==user) {
        count += document['reward'];
      }
    });
    _points=count;
  }

  void _performFeedback() async {
    String patrol = await patrolData.getPatrolId();
    _now = new DateTime.now();
    await Firestore.instance.collection('feedback').add({
      "patrol": patrol,
      "feedback": _feedbackDetails
    });
    await Firestore.instance.collection('patrol').document(patrol).updateData({'end': _now});
    _feedbackTextFieldController.clear();
    await patrolData.setPatrolId('');
    patrolData.setIsOnPatrol(false);
    Tracker.stopTracking();
    setState(() {
      _sent=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
        title: Text("ERP Ranger Mobile App"),
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
                this._sent == false ? _showScore() : new Container(),
                this._sent == false ? _showFeedbackTextField() : new Container(),
                this._sent == false ? _showFeedbackButton() : new Container(),
                this._sent == true ? _showSentFeedback() : new Container(),
              ],
            );
          }
        })
      ),
    );
  }

  Widget _showScore() {
    _now = new DateTime.now();
    if(!_loaded)
    {
      _getPatrolStart();
    }
    if(_loaded) {
      return RichText(
          text: new TextSpan(
              style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.black
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: 'You scored ' + _points.toString() + ' between ' +
                        _displayDateTime(_start) + ' and ' + _displayDateTime(_now))
              ]
          )
      );
    }
    else {
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

  Widget _showFeedbackTextField() {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child:TextField(
          controller: _feedbackTextFieldController,
          autofocus: true,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Feedback Details',
              labelStyle: TextStyle(
                  fontSize: 25.0
              )
          ),
          onChanged: (value) => this._feedbackDetails = value,
        )
    );
  }

  Widget _showFeedbackButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: SizedBox(
            height: 40.0,
            child: new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                color: Color.fromRGBO(18, 27, 65, 1.0),
                child: Text(
                    'Send Feedback',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                    )
                ),
                onPressed: _performFeedback
            )
        )
    );
  }

  Widget _showSentFeedback() {
    Widget sentFeedback = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "Sent Feedback",
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.black
          ),
        ),
      ),
    );
    return sentFeedback;
  }
}
