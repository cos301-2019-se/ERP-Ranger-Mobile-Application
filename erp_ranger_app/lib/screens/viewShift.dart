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
  static Firestore _db = Firestore.instance;
  static CollectionReference _shiftRef = _db.collection('shifts');
  Auth _shiftAuth = new Auth();
  String _user;
  QuerySnapshot _querySnapshot;
  List<DocumentSnapshot> _shiftListToday = new List<DocumentSnapshot>();
  List<DocumentSnapshot> _shiftListFuture = new List<DocumentSnapshot>();
  int _shiftsToday = -1;
  int _shiftsFuture = -1;
  bool _fetching = true;

  //Calls the initial functions that get the appropriate shifts.
  void initialFunctions(BuildContext context){
    getDocs();
    setState(() {

    });
  }

  //reloads the context of the screen in case of any variable changes
  void resetState(){
    setState(() {

    });
  }

  //gets the relevant shifts from the database
  Future<void> getDocs() async {
    _user = await _shiftAuth.getUserUid();
    _querySnapshot = await _db.collection('shifts').where('user', isEqualTo: _user).getDocuments();
    List<DocumentSnapshot> temp = new List<DocumentSnapshot>();

    for (int i = 0; i < _querySnapshot.documents.length; i++) {
      if(_querySnapshot.documents.elementAt(i).data['start'].toDate().year == DateTime.now().year && _querySnapshot.documents.elementAt(i).data['start'].toDate().month == DateTime.now().month && _querySnapshot.documents.elementAt(i).data['start'].toDate().day == DateTime.now().day) {
        temp.add(_querySnapshot.documents.elementAt(i));
      }
    }

    temp.sort((a, b) => a.data['start'].compareTo(b.data['start']));

    for(int i = 0; i < temp.length; i++){
      _shiftListToday.add(temp.elementAt(i));
    }

    temp.clear();

    for(int i = 0; i < _querySnapshot.documents.length; i++){
      if(_querySnapshot.documents.elementAt(i).data['start'].toDate().year == DateTime.now().year && (_querySnapshot.documents.elementAt(i).data['start'].toDate().month > DateTime.now().month || (_querySnapshot.documents.elementAt(i).data['start'].toDate().month == DateTime.now().month && _querySnapshot.documents.elementAt(i).data['start'].toDate().day > DateTime.now().day))){
        temp.add(_querySnapshot.documents.elementAt(i));
      }
    }

    temp.sort((a, b) => a.data['start'].compareTo(b.data['start']));

    for (int i = 0; i < temp.length; i++){
      _shiftListFuture.add(temp.elementAt(i));
    }

    setState(() {
      this._fetching = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          _showTodayBanner(),
          this._fetching == true ? _showFetching() : new Container(),
          new Expanded(
            child: new ListView.builder(
              itemCount: _shiftListToday.length,
              itemBuilder: (BuildContext context, int index) {
                return displayShiftToday();
              }
            ),
          ),
          _showFutureBanner(),
        this._fetching == true ? _showFetching() : new Container(),
          new Expanded(
            child: new ListView.builder(
                itemCount: _shiftListFuture.length,
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
    _shiftsToday++;
    if(_shiftListToday.elementAt(_shiftsToday).data['start'].compareTo(Timestamp.fromDate(DateTime.now())) < 0){
      if(_shiftsToday == _shiftListToday.length){
        _shiftsToday = 0;
      }
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
                      ('Start: ' + _shiftListToday.elementAt(_shiftsToday).data['start'].toDate().toString() + '\n' + 'End: ' +
                          _shiftListToday.elementAt(_shiftsToday).data['end'].toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    } else if(_shiftsToday%2 == 0 && _shiftListToday.elementAt(_shiftsToday).data['start'].compareTo(Timestamp.fromDate(DateTime.now())) >= 0) {
      if(_shiftsToday == _shiftListToday.length){
        _shiftsToday = 0;
      }
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
                      ('Start: ' + _shiftListToday.elementAt(_shiftsToday).data['start'].toDate().toString() + '\n' + 'End: ' +
                          _shiftListToday.elementAt(_shiftsToday).data['end'].toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    } else {
      if(_shiftsToday == _shiftListToday.length){
        _shiftsToday = 0;
      }
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
                      ('Start: ' + _shiftListToday.elementAt(_shiftsToday).data['start'].toDate().toString() + '\n' + 'End: ' +
                          _shiftListToday.elementAt(_shiftsToday).data['end'].toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    }
  }

  Widget displayShiftFuture(){
    _shiftsFuture++;
    if(_shiftsFuture%2 == 0 && _shiftListFuture.elementAt(_shiftsFuture).data['start'].compareTo(Timestamp.fromDate(DateTime.now())) >= 0) {
      if(_shiftsFuture == _shiftListFuture.length){
        _shiftsFuture = 0;
      }
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
                      ('Start: ' + _shiftListFuture.elementAt(_shiftsFuture).data['start'].toDate().toString() + '\n' + 'End: ' +
                          _shiftListFuture.elementAt(_shiftsFuture).data['end'].toDate().toString())
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ));
    } else {
      if(_shiftsFuture == _shiftListFuture.length){
        _shiftsFuture = 0;
      }
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
                      ('Start: ' + _shiftListFuture.elementAt(_shiftsFuture).data['start'].toDate().toString() + '\n' + 'End: ' +
                          _shiftListFuture.elementAt(_shiftsFuture).data['end'].toDate().toString())
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