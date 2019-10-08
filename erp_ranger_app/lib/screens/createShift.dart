import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';

class CreateShift extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ShiftState();
}

class ShiftState extends State<CreateShift> {
  static const int MAX_SHIFT_LENGTH = 8;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime _selectedStartDateTime;
  DateTime _selectedEndDateTime;
  bool _startFlag = false;
  bool _endFlag = false;
  bool _dateFlag = false;
  bool _midnightFlag = false;
  bool _sendingReport = false;
  Duration _delayTime = new Duration(seconds: 2);

  static Firestore db = Firestore.instance;
  static CollectionReference shiftRef = db.collection('shifts');

  Auth tempAuth = new Auth();

  String user;
  String park;

  //shows the date selector to the user.
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(2101));
    if (picked != null) {
      _dateFlag = true;
      setState(() {
        selectedDate = picked;
      });
    } else {
      _dateFlag = false;
      setState(() {});
    }
  }

  //indicates that a date has been selected.
  void _selectStartDate(BuildContext context) {
    _dateFlag = true;
    _selectedDate(context);
  }

  //shows the time picker and sets the relevant variable to the time selected.
  Future<Null> _selectedTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        if (_startFlag && !_endFlag && selectedTime != null) {
          _setStart();
        } else if (!_startFlag && _endFlag && selectedTime != null) {
          _setEnd();
        } else if (_selectedStartDateTime == null && _startFlag && _endFlag) {
          _setStart();
        } else if (_selectedEndDateTime == null && _startFlag && _endFlag) {
          _setEnd();
        } else {}
        if (_validateTime()) {
        } else {
          print("error: please reselect times");
          _updatePickers(context);
          _startFlag = false;
          _endFlag = false;
          _selectedStartDateTime = null;
          _selectedEndDateTime = null;
        }
      });
    } else {
      if (_startFlag && !_endFlag) {
        _startFlag = false;
      } else if (_endFlag && !_startFlag) {
        _endFlag = false;
      } else {
        _startFlag = false;
        _endFlag = false;
      }
      setState(() {});
    }
  }

  //reloads the build context to show a change in the state of the screen.
  void _updatePickers(BuildContext context) {
    setState(() {});
  }

  //resets all values to restart the time selection process/cancel a selection
  void _resetPickers(BuildContext context){
    _selectedStartDateTime = null;
    _selectedEndDateTime = null;
    _dateFlag = false;
    _startFlag = false;
    _endFlag = false;
    _midnightFlag = false;
    _updatePickers(context);
  }

  //Checks the validity of the time based on what has already been selected
  bool _validateTime() {
    if (_dateFlag) {
      if (selectedDate.year == DateTime.now().year &&
          selectedDate.month == DateTime.now().month &&
          selectedDate.day == DateTime.now().day) {
        if (_startFlag && _selectedStartDateTime.hour < DateTime
            .now()
            .hour) {
          Scaffold.of(this.context).showSnackBar(new SnackBar(
              content: new Text('Selected start time has passed.')));
          return false;
        } else if (_startFlag && _selectedStartDateTime.hour == DateTime
            .now()
            .hour &&
            _selectedStartDateTime.minute < DateTime
                .now()
                .minute - 5) {
          Scaffold.of(this.context).showSnackBar(new SnackBar(
              content: new Text('Selected start time has passed.')));
          return false;
        } else
        if (_endFlag && _selectedEndDateTime.hour < _selectedStartDateTime.hour &&
            (((24 - _selectedStartDateTime.hour) + _selectedEndDateTime.hour) <=
                MAX_SHIFT_LENGTH)) {
          _midnightFlag = true;
          return true;
        } else if(_endFlag && _selectedEndDateTime.hour < _selectedStartDateTime.hour &&
            (((24 - _selectedStartDateTime.hour) + _selectedEndDateTime.hour) >=
                MAX_SHIFT_LENGTH)){
          Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Maximum shift length of 8 hours.')));
          return false;
        } else if (_endFlag && _selectedEndDateTime.hour == _selectedStartDateTime.hour &&
            _selectedEndDateTime.minute < _selectedStartDateTime.minute) {
          Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Selected end time after selected start time.')));
          return false;
        } else if (_endFlag && _selectedEndDateTime.hour < DateTime.now().hour) {
          Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Selected end time has passed.')));
          return false;
        } else if (_endFlag && _selectedEndDateTime.hour == DateTime.now().hour &&
            _selectedEndDateTime.minute < DateTime.now().minute - 5) {
          Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Selected end time has passed.')));
          return false;
        } else {
          return true;
        }
      } else {
        if (_endFlag &&  _selectedStartDateTime.hour > _selectedEndDateTime.hour &&
            (((24 - _selectedStartDateTime.hour) + _selectedEndDateTime.hour) <=
                MAX_SHIFT_LENGTH)) {
          _midnightFlag = true;
          return true;
        } else if(_endFlag && _selectedEndDateTime.hour < _selectedStartDateTime.hour &&
            (((24 - _selectedStartDateTime.hour) + _selectedEndDateTime.hour) >=
                MAX_SHIFT_LENGTH)){
          Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Maximum shift length of 8 hours.')));
          return false;
        }else if (_endFlag && _selectedStartDateTime.hour == _selectedEndDateTime.hour &&
            _selectedStartDateTime.minute < _selectedEndDateTime.minute) {
          Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Selected time has passed')));
          return false;
        } else {
          return true;
        }
      }
    } else {
      Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('No chosen Date')));
      return false;
    }
  }

  //sets the start time flag to indicate that a start time has been selected
  void _selectStartDateTime(BuildContext context) {
    _startFlag = true;
    _selectedTime(context);
  }

  //sets the start time to the selected value
  void _setStart() {
    _selectedStartDateTime = new DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
  }

  //sets the end time flag to indicate that the end time has been selected.
  void _selectEndDateTime(BuildContext context) {
    _endFlag = true;
    _selectedTime(context);
  }

  //sets the end time to the selected time.
  void _setEnd() {
    _selectedEndDateTime = new DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
  }

  //compiles and converts the data gathered to send it to the database.
  Future<void> compileData() async {
    user = await tempAuth.getUserUid();
    park = await Park.getParkId();
    Timestamp end;
    if (_midnightFlag) {
      _selectedEndDateTime = new DateTime(
          _selectedEndDateTime.year,
          _selectedEndDateTime.month,
          _selectedEndDateTime.day + 1,
          _selectedEndDateTime.hour,
          _selectedEndDateTime.minute,
          _selectedEndDateTime.second);
      end = new Timestamp.fromDate(_selectedEndDateTime);
    } else {
      end = new Timestamp.fromDate(_selectedEndDateTime);
    }
    Timestamp start = new Timestamp.fromDate(_selectedStartDateTime);

    setState(() {
      this._sendingReport = true;
    });

    var result = await Firestore.instance.collection('shifts').add({
          "end": end,
          "park": park,
          "start": start,
          "user": user,
        }).then((result) => {
              Scaffold.of(this.context).showSnackBar(new SnackBar(content: new Text('Success'))),
              Timer(this._delayTime, () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));}),
            })
        .catchError((err) => print(err));
  }

  //formatting function to counteract the loss of leading 0's when converted from a string.
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
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _showDatePicker(),
            _showStartTimePicker(),
            _showEndTimePicker(),
            this._sendingReport == true ? _showSending() : new Container(),
            _showSendData(),
            _showRepickTimes(),
          ],
        ),
      ),
    );
  }

  Widget _showDatePicker() {
    if (!_dateFlag) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          autofocus: false,
          enabled: true,
          decoration: new InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.calendar_today,
                color: Colors.grey,
              )),
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectStartDate(context);
          },
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
    if (_dateFlag && !_startFlag) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          autofocus: false,
          maxLines: 1,
          enabled: true,
          decoration: new InputDecoration(
              labelText: 'StartTime',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.watch,
                color: Colors.grey,
              )),
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectStartDateTime(context);
          },
        ),
      );
    } else if(!_startFlag){
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: false,
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
          enabled: false,
          decoration: new InputDecoration(
              labelText: displayDateTime(_selectedStartDateTime),
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
    if (_startFlag && !_endFlag) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          autofocus: false,
          maxLines: 1,
          enabled: true,
          decoration: new InputDecoration(
              labelText: 'EndTime',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.watch,
                color: Colors.grey,
              )),
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectEndDateTime(context);
          },
        ),
      );
    } else if(!_endFlag){
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          key: Key('Text'),
          maxLines: 1,
          enabled: false,
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
          decoration: new InputDecoration(
              labelText: displayDateTime(_selectedEndDateTime),
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
                borderRadius: new BorderRadius.circular(5.0)),
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
                borderRadius: new BorderRadius.circular(5.0)),
            color: Color.fromRGBO(200, 0, 0, 1.0),
            child: Text('Cancel',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () => _resetPickers(context)),
      ),
    );
  }

  Widget _showSending() {
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
