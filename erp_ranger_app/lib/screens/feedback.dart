import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/patrolData.dart';
import 'package:erp_ranger_app/services/tracker.dart';
import 'package:erp_ranger_app/screens/patrol.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FeedbackState();
}

class FeedbackState extends State<FeedbackScreen> {

  final TextEditingController _feedbackTextFieldController = new TextEditingController();
  DateTime _now;
  DateTime _start;
  int _points=10;//will get from app user data
  String _feedbackDetails;
  bool _loaded=false;
  bool _sent=false;

  FeedbackState()
  {
    _getPatrolStart().then((onValue)=>setState((){
      _start=onValue;
    }));
  }

  Future<DateTime> _getPatrolStart() async {
    String patrol = await patrolData.getPatrolId();
    var document = await Firestore.instance.collection('patrol').document(patrol).get();
    _start = document['start'].toDate();
    setState(() {
      _loaded=true;
    });
    return _start;
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
    _sent=true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
        title: Text("Feedback"),
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
                _showScore(),
                _showFeedbackTextField(),
                _showFeedbackButton(),
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
                  color: Colors.blue
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: 'You scored ' + _points.toString() + ' between ' +
                        _start.hour.toString() + ':' +
                        _start.minute.toString() + ' and ' +
                        _now.hour.toString() + ':' + _now.minute.toString())
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
                color: Colors.blue,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                ),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "Sent Feedback",
          style: TextStyle(
              color: Colors.blue
          ),
        ),
      ),
    );
  }
}
