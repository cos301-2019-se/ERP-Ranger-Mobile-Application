import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateShift extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new ShiftState();
}

class ShiftState extends State<CreateShift> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedStartDateTime;
  DateTime selectedEndDateTime;
  bool startFlag = false;
  bool endFlag = false;

  static Firestore db = Firestore.instance;
  static CollectionReference shiftRef = db.collection('shifts');
  DocumentReference parkRef = shiftRef.document('c0PvLdUAgLX9wtkoA4Ca');

  String user = "gQvk9DfM0KSrdSONKfXtnLJ6e0P2";
  String park = "iwGnWNuDC3m1hRzNNBT5";

  Future<Null> _selectedDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectedTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime);
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void _selectStartDateTime(BuildContext context) {
    _selectedDate(context);
    _selectedTime(context);
    startFlag = true;
    setStart();
  }

  void setStart(){
    selectedStartDateTime = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
  }

  void _selectEndDateTime(BuildContext context) {
    setStart();
    _selectedDate(context);
    _selectedTime(context);
    endFlag = true;
    setEnd();
  }

  void setEnd(){
    selectedEndDateTime = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
  }

  Future<void> compileData() async{
    Timestamp end = new Timestamp.fromDate(selectedEndDateTime);
    Timestamp start = new Timestamp.fromDate(selectedStartDateTime);
    Firestore.instance
        .collection('shifts')
        .add({
      "end": end,
      "park": park,
      "start": start,
      "user": user,
    })
        .then((result) => {
      Navigator.pop(context),
    })
        .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _showStartDateTimeInput(),
            _showStartDisplay(),
            _showEndDateTimeInput(),
            _showEndDisplay(),
            _showSendData(),
          ],
        ),
      ),
    );
  }

  Widget _showStartDateTimeInput(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)
            ),
            color:  Colors.red,
            child:  Text(
              'Choose start Time',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white
              )
            ),
            onPressed: () => _selectStartDateTime(context)
        ),
      ),
    );
  }

  Widget _showStartDisplay(){
    if(selectedStartDateTime != null && startFlag && !endFlag) {
      print("start: " + selectedStartDateTime.toString());
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Shift start date: " + selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" +selectedDate.year.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            ),
            Text(
              "Shift start time: " + selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            )
          ],
        ),
      );
    }
    else if(selectedStartDateTime != null && startFlag && endFlag) {
      print("start: " + selectedStartDateTime.toString());
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Shift start date: " + selectedStartDateTime.day.toString() + "/" + selectedStartDateTime.month.toString() + "/" +selectedStartDateTime.year.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            ),
            Text(
              "Shift start time: " + selectedStartDateTime.hour.toString() + ":" + selectedStartDateTime.minute.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            )
          ],
        ),
      );
    }
    else{
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Shift date: ",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
              ),
            ),
            Text(
              "Shift time: ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _showEndDateTimeInput(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)
            ),
            color:  Colors.red,
            child:  Text(
                'Choose end Time',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                )
            ),
            onPressed: () => _selectEndDateTime(context)
        ),
      ),
    );
  }

  Widget _showEndDisplay(){
    if(selectedEndDateTime != null && endFlag) {
      setEnd();
      print("end: " + selectedEndDateTime.toString());
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Shift end date: " + selectedEndDateTime.day.toString() + "/" + selectedEndDateTime.month.toString() + "/" +selectedEndDateTime.year.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            ),
            Text(
              "Shift end time: " + selectedEndDateTime.hour.toString() + ":" + selectedEndDateTime.minute.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            )
          ],
        ),
      );
    }
    else{
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Shift end date: ",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
              ),
            ),
            Text(
              "Shift end time: ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _showSendData(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)
            ),
            color:  Colors.red,
            child:  Text(
                'Send Data',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                )
            ),
            onPressed: () => compileData()
        ),
      ),
    );
  }
}
