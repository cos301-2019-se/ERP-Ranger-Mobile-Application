import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class ViewShift extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ViewShiftState();
}

class ViewShiftState extends State<ViewShift> {
  static Firestore db = Firestore.instance;
  static CollectionReference shiftRef = db.collection('shifts');
  Auth shiftAuth = new Auth();
  String user;
  QuerySnapshot querySnapshot;
  List<DocumentSnapshot> shiftList = new List<DocumentSnapshot>();
  int globalIndex = 0;
  CalendarController _calendarController;
  final TextEditingController _textEditingController = new TextEditingController();

  void initialFunctions(BuildContext context){
    getDocs();
    setState(() {

    });
  }

  void resetState(){
    setState(() {

    });
  }

  Future<void> getDocs() async{
    user = await shiftAuth.getUserUid();
    querySnapshot = await db.collection('shifts').orderBy('start', descending: true).where('user', isEqualTo: user).getDocuments();
    Timestamp temp;
    DateTime start;

    for(int i = 0; i < querySnapshot.documents.length; i++){
      temp = querySnapshot.documents.elementAt(i).data['start'];
      start = temp.toDate();
      if(start.year >= DateTime.now().year && start.month >= DateTime.now().month && start.day >= DateTime.now().day){
        shiftList.add(querySnapshot.documents.elementAt(i));
        print(shiftList.length);
      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          _showBanner(),
          new Expanded(
            child: new ListView.builder(
              itemCount: shiftList.length,
              itemBuilder: (BuildContext context, int index) {
                return displayShift(shiftList.elementAt(globalIndex).data['start'], shiftList.elementAt(globalIndex).data['end']);
              }
            ),
          ),
        ]),
      );
  }

  @override
  void initState(){
    initialFunctions(context);
    super.initState();
  }

  Widget displayShift(Timestamp start, Timestamp end) {
    print(shiftList.length);
    if(globalIndex < shiftList.length) {
      globalIndex++;
    }
    if(start.toDate().hour < DateTime.now().hour || (start.toDate().hour == DateTime.now().hour && start.toDate().minute < DateTime.now().minute)){
      return new Card(
          elevation: 1.0,
          margin: new EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(200, 0, 0, 1.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 40.0),
                Center(
                  child: Text(
                      ('Start: ' + start.toDate().toString() + '\n' + 'End: ' +
                          end.toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    } else if(globalIndex%2 == 0) {
      return new Card(
          elevation: 1.0,
          margin: new EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(154, 126, 97, 1.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 40.0),
                Center(
                  child: Text(
                      ('Start: ' + start.toDate().toString() + '\n' + 'End: ' +
                          end.toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    } else {
      return new Card(
          elevation: 1.0,
          margin: new EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(184, 156, 127, 1.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 40.0),
                Center(
                  child: Text(
                      ('Start: ' + start.toDate().toString() + '\n' + 'End: ' +
                          end.toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    }
  }

  Widget _showBanner(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          color: Color.fromRGBO(18, 27, 65, 1.0),
            child: SizedBox(
              width: 200,
              height: 20,
              child: new Center(
                child: new Text('Shifts Today:', style: TextStyle(color: Colors.white),
            ),
          ),
         ),
        ),
      ],
    );
  }

}