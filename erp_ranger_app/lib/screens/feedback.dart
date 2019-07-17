import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  FeedbackState()
  {
    _getPatrolStart().then((onValue)=>setState((){
      _start=onValue;
    }));
  }

  Future<DateTime> _getPatrolStart() async {
    var document = await Firestore.instance.collection('patrol').document('R0Ns1iCiJ8bfVlPjXVeP').get();//will get patrolID from app user data
    _start = document['start'].toDate();
    return _start;
  }

  void _performFeedback() async {
    _now = new DateTime.now();
    await Firestore.instance.collection('feedback').add({
      "patrol": "R0Ns1iCiJ8bfVlPjXVeP",//will get patrolID from user data
      "feedback": _feedbackDetails
    });
    await Firestore.instance.collection('patrol').document('R0Ns1iCiJ8bfVlPjXVeP').updateData({'end': _now});//will get patrolID from app user data
    _feedbackTextFieldController.clear();
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
                _showFeedbackButton()
              ],
            );
          }
        })
      ),
    );
  }

  Widget _showScore() {
    _now = new DateTime.now();
    _getPatrolStart();
    return RichText (
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.blue
        ),
        children: <TextSpan>[
          new TextSpan(text: 'You scored ' + _points.toString() + ' between ' + _start.hour.toString() + ':' + _start.minute.toString() + ' and ' + _now.hour.toString() + ':' + _now.minute.toString())
        ]
      )
    );
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
}
