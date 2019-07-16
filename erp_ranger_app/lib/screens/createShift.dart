import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';

class CreateShift extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ShiftState();
}

class ShiftState extends State<CreateShift> {
  static const int MAX_SHIFT_LENGTH = 8;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedStartDateTime;
  DateTime selectedEndDateTime;
  bool startFlag = false;
  bool endFlag = false;
  bool dateFlag = false;
  bool midnightFlag = false;

  static Firestore db = Firestore.instance;
  static CollectionReference shiftRef = db.collection('shifts');
  DocumentReference parkRef = shiftRef.document('c0PvLdUAgLX9wtkoA4Ca');

  Auth tempAuth = new Auth();

  Future<String> user;
  String park;

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateFlag = true;
      setState(() {
        selectedDate = picked;
      });
    } else {
      dateFlag = false;
      setState(() {});
    }
  }

  void _selectStartDate(BuildContext context) {
    dateFlag = true;
    _selectedDate(context);
  }

  Future<Null> _selectedTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        if (startFlag && !endFlag && selectedTime != null) {
          _setStart();
        } else if (!startFlag && endFlag && selectedTime != null) {
          _setEnd();
        } else if (selectedStartDateTime == null && startFlag && endFlag) {
          _setStart();
        } else if (selectedEndDateTime == null && startFlag && endFlag) {
          _setEnd();
        } else {}
        if (_validateTime()) {
        } else {
          print("error: please reselect times");
          _updatePickers(context);
          startFlag = false;
          endFlag = false;
          selectedStartDateTime = null;
          selectedEndDateTime = null;
        }
      });
    } else {
      if (startFlag && !endFlag) {
        startFlag = false;
      } else if (endFlag && !startFlag) {
        endFlag = false;
      } else {
        startFlag = false;
        endFlag = false;
      }
      setState(() {});
    }
  }

  void _updatePickers(BuildContext context) {
    setState(() {});
  }

  void _resetPickers(BuildContext context){
    selectedStartDateTime = null;
    selectedEndDateTime = null;
    dateFlag = false;
    startFlag = false;
    endFlag = false;
    midnightFlag = false;
    _updatePickers(context);
  }

  bool _validateTime() {
    if (dateFlag) {
      if (selectedDate.year == DateTime.now().year &&
          selectedDate.month == DateTime.now().month &&
          selectedDate.day == DateTime.now().day) {
        if (selectedStartDateTime.hour < DateTime.now().hour) {
          return false;
        } else if (selectedStartDateTime.hour == DateTime.now().hour &&
            selectedStartDateTime.minute < DateTime.now().minute - 5) {
          return false;
        } else if (selectedEndDateTime.hour < selectedStartDateTime.hour &&
            (((24 - selectedStartDateTime.hour) + selectedEndDateTime.hour) <=
                MAX_SHIFT_LENGTH)) {
          midnightFlag = true;
          return true;
        } else if (selectedEndDateTime.hour == selectedStartDateTime.hour &&
            selectedEndDateTime.minute < selectedStartDateTime.minute) {
          return false;
        } else if (selectedEndDateTime.hour < DateTime.now().hour) {
          return false;
        } else if (selectedEndDateTime.hour == DateTime.now().hour &&
            selectedEndDateTime.minute < DateTime.now().minute - 5) {
          return false;
        } else {
          return true;
        }
      } else {
        if (selectedStartDateTime.hour > selectedEndDateTime.hour &&
            (((24 - selectedStartDateTime.hour) + selectedEndDateTime.hour) <=
                MAX_SHIFT_LENGTH)) {
          midnightFlag = true;
          return true;
        } else if (selectedStartDateTime.hour == selectedEndDateTime.hour &&
            selectedStartDateTime.minute < selectedEndDateTime.minute) {
          return false;
        } else {
          return true;
        }
      }
    } else {
      return false;
    }
  }

  void _selectStartDateTime(BuildContext context) {
    startFlag = true;
    _selectedTime(context);
  }

  void _setStart() {
    selectedStartDateTime = new DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
  }

  void _selectEndDateTime(BuildContext context) {
    endFlag = true;
    _selectedTime(context);
  }

  void _setEnd() {
    selectedEndDateTime = new DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
  }

  Future<void> compileData() async {
    user = tempAuth.getUserUid();
    park = await Park.getParkId();
    Timestamp end;
    if (midnightFlag) {
      selectedEndDateTime = new DateTime(
          selectedEndDateTime.year,
          selectedEndDateTime.month,
          selectedEndDateTime.day + 1,
          selectedEndDateTime.hour,
          selectedEndDateTime.minute,
          selectedEndDateTime.second);
      end = new Timestamp.fromDate(selectedEndDateTime);
    } else {
      end = new Timestamp.fromDate(selectedEndDateTime);
    }
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

  String displayDateTime(DateTime t) {
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Book a shift"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _showDatePicker(),
            _showStartTimePicker(),
            _showEndTimePicker(),
            _showSendData(),
            _showRepickTimes(),
          ],
        ),
      ),
    );
  }

  Widget _showDatePicker() {
    if (!dateFlag) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: true,
          maxLength: 1,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.calendar_today,
                color: Colors.grey,
              )),
          onTap: () => _selectStartDate(context),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: false,
          maxLength: 1,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
              labelText: selectedDate.day.toString() +
                  "/" +
                  selectedDate.month.toString() +
                  "/" +
                  selectedDate.year.toString(),
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.calendar_today,
                color: Colors.grey,
              )),
          onTap: () => _selectStartDate(context),
        ),
      );
    }
  }

  Widget _showStartTimePicker() {
    if (dateFlag && !startFlag) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: true,
          maxLength: 1,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
              labelText: 'StartTime',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.watch,
                color: Colors.grey,
              )),
          onTap: () => _selectStartDateTime(context),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: false,
          maxLength: 1,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
              labelText: displayDateTime(selectedStartDateTime),
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.watch,
                color: Colors.grey,
              )),
          onTap: () => _selectStartDateTime(context),
        ),
      );
    }
  }

  Widget _showEndTimePicker() {
    if (startFlag && !endFlag) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: true,
          maxLength: 1,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
              labelText: 'EndTime',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.watch,
                color: Colors.grey,
              )),
          onTap: () => _selectEndDateTime(context),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: false,
          maxLength: 1,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
              labelText: displayDateTime(selectedEndDateTime),
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.watch,
                color: Colors.grey,
              )),
          onTap: () => _selectEndDateTime(context),
        ),
      );
    }
  }

  Widget _showSendData() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Color.fromRGBO(18, 27, 65, 1.0),
            child: Text('Book Shift',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () => compileData()),
      ),
    );
  }

  Widget _showRepickTimes() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Color.fromRGBO(200, 0, 0, 1.0),
            child: Text('Cancel',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () => _resetPickers(context)),
      ),
    );
  }
}
