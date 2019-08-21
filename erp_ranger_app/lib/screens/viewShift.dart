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
  List<DocumentSnapshot> shiftListToday = new List<DocumentSnapshot>();
  List<DocumentSnapshot> shiftListFuture = new List<DocumentSnapshot>();
  int shiftsToday = -1;
  int shiftsFuture = -1;
  bool fetching = true;

  void initialFunctions(BuildContext context){
    getDocs();
    setState(() {

    });
  }

  void resetState(){
    setState(() {

    });
  }

  Future<void> getDocs() async {
    user = await shiftAuth.getUserUid();
    querySnapshot = await db.collection('shifts').where('user', isEqualTo: user).getDocuments();
    List<DocumentSnapshot> temp = new List<DocumentSnapshot>();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      if(querySnapshot.documents.elementAt(i).data['start'].toDate().year == DateTime.now().year && querySnapshot.documents.elementAt(i).data['start'].toDate().month == DateTime.now().month && querySnapshot.documents.elementAt(i).data['start'].toDate().day == DateTime.now().day) {
        temp.add(querySnapshot.documents.elementAt(i));
      }
    }

    temp.sort((a, b) => a.data['start'].compareTo(b.data['start']));

    for(int i = 0; i < temp.length; i++){
      shiftListToday.add(temp.elementAt(i));
    }

    temp.clear();

    for(int i = 0; i < querySnapshot.documents.length; i++){
      if(querySnapshot.documents.elementAt(i).data['start'].toDate().year == DateTime.now().year && (querySnapshot.documents.elementAt(i).data['start'].toDate().month > DateTime.now().month || (querySnapshot.documents.elementAt(i).data['start'].toDate().month == DateTime.now().month && querySnapshot.documents.elementAt(i).data['start'].toDate().day > DateTime.now().day))){
        temp.add(querySnapshot.documents.elementAt(i));
      }
    }

    temp.sort((a, b) => a.data['start'].compareTo(b.data['start']));

    for (int i = 0; i < temp.length; i++){
      shiftListFuture.add(temp.elementAt(i));
    }

    setState(() {
      this.fetching = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          _showTodayBanner(),
          this.fetching == true ? _showFetching() : new Container(),
          new Expanded(
            child: new ListView.builder(
              itemCount: shiftListToday.length,
              itemBuilder: (BuildContext context, int index) {
                return displayShiftToday();
              }
            ),
          ),
          _showFutureBanner(),
        this.fetching == true ? _showFetching() : new Container(),
          new Expanded(
            child: new ListView.builder(
                itemCount: shiftListFuture.length,
                itemBuilder: (BuildContext context, int index) {
                  return displayShiftFuture();
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

  Widget displayShiftToday() {
    shiftsToday++;
    if(shiftListToday.elementAt(shiftsToday).data['start'].compareTo(Timestamp.fromDate(DateTime.now())) < 0){
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
                  child: new Text(
                      ('Start: ' + shiftListToday.elementAt(shiftsToday).data['start'].toDate().toString() + '\n' + 'End: ' +
                          shiftListToday.elementAt(shiftsToday).data['end'].toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    } else if(shiftsToday%2 == 0 && shiftListToday.elementAt(shiftsToday).data['start'].compareTo(Timestamp.fromDate(DateTime.now())) >= 0) {
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
                  child: new Text(
                      ('Start: ' + shiftListToday.elementAt(shiftsToday).data['start'].toDate().toString() + '\n' + 'End: ' +
                          shiftListToday.elementAt(shiftsToday).data['end'].toDate().toString())
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
                  child: new Text(
                      ('Start: ' + shiftListToday.elementAt(shiftsToday).data['start'].toDate().toString() + '\n' + 'End: ' +
                          shiftListToday.elementAt(shiftsToday).data['end'].toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    }
  }

  Widget displayShiftFuture(){
    shiftsFuture++;
    print('shift list today length: ' + shiftListToday.length.toString());
    print('shifts today: ' + shiftsToday.toString());
    if(shiftsFuture%2 == 0 && shiftListFuture.elementAt(shiftsFuture).data['start'].compareTo(Timestamp.fromDate(DateTime.now())) >= 0) {
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
                  child: new Text(
                      ('Start: ' + shiftListFuture.elementAt(shiftsFuture).data['start'].toDate().toString() + '\n' + 'End: ' +
                          shiftListFuture.elementAt(shiftsFuture).data['end'].toDate().toString())
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
                  child: new Text(
                      ('Start: ' + shiftListFuture.elementAt(shiftsFuture).data['start'].toDate().toString() + '\n' + 'End: ' +
                          shiftListFuture.elementAt(shiftsFuture).data['end'].toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    }
  }

  Widget _showTodayBanner(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            color: Color.fromRGBO(18, 27, 65, 1.0),
            child: Text('Shifts Today:',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _showFutureBanner(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
          color: Color.fromRGBO(18, 27, 65, 1.0),
          child: Text('Future shifts:',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _showFetching() {
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