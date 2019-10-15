//The dashboard screen provides links to the other screens and starts and ends patrols
import 'package:erp_ranger_app/components/drawer.dart';
import 'package:erp_ranger_app/screens/assets.dart';
import 'package:erp_ranger_app/screens/endShift.dart';
import 'package:erp_ranger_app/screens/report.dart';
import 'package:erp_ranger_app/screens/shifts.dart';
import 'package:erp_ranger_app/screens/feedback.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/login.dart';
import 'package:erp_ranger_app/screens/markers.dart';
import 'package:erp_ranger_app/screens/patrol.dart';
import 'package:erp_ranger_app/screens/shifts.dart';
import 'package:erp_ranger_app/screens/leaderboard.dart';
import 'package:erp_ranger_app/screens/ranger.dart';
import 'dart:async';
import 'package:erp_ranger_app/services/patrolData.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();

}

class _DashboardScreenState extends State<DashboardScreen> {

  String _timeString = '00:00:00';
  String _patrolButtonText;
  bool _loadedPatrol=false;
  Timer _timer;
  String _dropdownValue;
  Park _parks = new Park();

  @override
  void initState() {
    checkPark();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  Future<void> checkPark() async{
    _dropdownValue = await Park.getParkId();

    if(_dropdownValue==null){
      await showDialog(context: context, child:
      SimpleDialog(
          title: new Text("Please select a park."),
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
                child: _showParksDropdown()
            ),
            new Padding(
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
                child: SizedBox(
                    height: 40.0,
                    child: new Text(
                        'You can change this in the profile section.',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black
                        )
                    )
                )
            ),
          ],
        ));
    }
  }

  Widget _showParksDropdown() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new Container(
          padding: EdgeInsets.fromLTRB(12.0, 3.0, 12.0, 3.0),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.0,
                      style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))
              )
          ),
          child: new StreamBuilder(
              stream: this._parks.read().snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text("Loading...");
                  default:
                    return new DropdownButtonHideUnderline(
                        child: new DropdownButton<String>(
                          hint: new Text("Select a park"),
                          isExpanded: true,
                          value: _dropdownValue,
                          items: snapshot.data.documents.map((document) =>
                          new DropdownMenuItem<String>(
                            child: new Text(document['name']),
                            value: document.documentID,
                          )
                          ).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              _dropdownValue = newValue;
                              Park.setParkId(newValue);
                              Navigator.pop(context);
                            });
                          },
                        )
                    );
                }
              }
          )
      ),
    );
  }

  //calculates the time since a patrol began
  void _getTime() async{
    DateTime startTime = await patrolData.getPatrolStart();
    String formattedDateTime;
    if(startTime!=null) {
      int passedTime = DateTime.now().millisecondsSinceEpoch - (startTime).millisecondsSinceEpoch;
      formattedDateTime = _formatDateTime(passedTime);
    }
    else {
      formattedDateTime = '00:00:00';
    }
    _setButtonText();
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  //formats time in hh:mm:ss from millisecondsSinceEpoch
  String _formatDateTime(int duration) {
    int seconds = ((duration / 1000) % 60).floor(),
        minutes = ((duration / (1000 * 60)) % 60).floor(),
        hours = ((duration / (1000 * 60 * 60)) % 24).floor();

    String hoursStr = (hours < 10) ? "0" + hours.toString() : hours.toString();
    String minutesStr = (minutes < 10) ? "0" + minutes.toString() : minutes.toString();
    String secondsStr = (seconds < 10) ? "0" + seconds.toString() : seconds.toString();

    return hoursStr + ":" + minutesStr + ":" + secondsStr;
  }

  //starts the patrol or ends the patrol. If ending it opens the feedback screen
  void _activatePatrolButton() async {
    if(!(await patrolData.getIsOnPatrol())) {
      await patrolData.switchPatrol();
      _setButtonText();
    }
    else {
      _openScreen('Log Feedback');
      _loadedPatrol=false;
    }
  }

  //changes the patrol button text when the patrol changes
  void _setButtonText()  async{
    bool isOnPatrol = await patrolData.getIsOnPatrol();
    if(isOnPatrol)
    {
      _patrolButtonText = "End Patrol";
    }
    else
    {
      _patrolButtonText = "Start Patrol";
    }
    setState(() {
      _loadedPatrol=true;
    });
  }

  //creates the dashboard screen
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height/4;
    double width = MediaQuery.of(context).size.width;
    if(_loadedPatrol==false) {
      _setButtonText();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("ERP Ranger Mobile App"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget>[
          Expanded(
            child:Container(
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('assets/images/stopwatch.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Padding (
                    padding: EdgeInsets.fromLTRB(0.0, constraints.maxHeight/5, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>  [
                        Text(_timeString,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 48.0,
                            color: Colors.white,
                          )
                        ),
                        this._loadedPatrol == true ? SizedBox(
                          height: 40.0,
                          child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)
                            ),
                            color: Colors.white,
                            child: Text(
                              _patrolButtonText,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color.fromRGBO(18, 27, 65, 1.0)
                              )
                            ),
                            onPressed: _activatePatrolButton,
                          )
                        ):
                          new Padding(
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
                          ),
                      ]
                    )
                  );
                },
              )
            )
          ),
          Container(
            constraints: BoxConstraints.expand(height: height),//MediaQuery.of(context).size.height/4),
            alignment: Alignment.center,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.map,color: Colors.white),
                          iconSize: 48.0,
                          onPressed: () {
                            _openScreen("Markers");
                          }),
                      Text('Map',style:TextStyle(fontSize: 20.0,color: Colors.white))
                    ],
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Color.fromRGBO(18, 27, 65, 1.0),
                  constraints: BoxConstraints.expand(width: height/1.5,height: height/1.5),
                  //padding: const EdgeInsets.all(height),
                ),
                RawMaterialButton(
                  onPressed: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.message,color: Colors.white),
                          iconSize: 48.0,
                          onPressed: () {
                            _openScreen("Reports");
                          }),
                      Text('Reports',style:TextStyle(fontSize: 20.0,color: Colors.white))
                    ],
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Color.fromRGBO(18, 27, 65, 1.0),
                  constraints: BoxConstraints.expand(width: height/1.5,height: height/1.5),
                  //padding: const EdgeInsets.all(height),
                ),
              ]
            ),
          ),
        ]
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(18, 27, 65, 1.0), //blue
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.date_range),
                        iconSize: 48.0,
                        color: Colors.white,
                        onPressed: () {
                          _openScreen("Shifts");
                        }),
                      Text('Shifts',style:TextStyle(fontSize: 15.0,color: Colors.white))
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.stars),
                          iconSize: 48.0,
                          color: Colors.white,
                          onPressed: () {
                            _openScreen("Leaderboard");
                          }),
                      Text('Leaderboard',style:TextStyle(fontSize: 15.0,color: Colors.white))
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.directions_walk),
                        iconSize: 48.0,
                        color: Colors.white,
                        onPressed: () {
                          _openScreen("Rangers");
                        }),
                      Text('Rangers',style:TextStyle(fontSize: 15.0,color: Colors.white))
                    ],
                  ),
                ]
              ),
          ],
        )
      ),
    );
  }

  //goes to a screen depending on what button pressed
  void _openScreen(String title) {
    if (title == "Markers") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new MarkersScreen()));
    } else if (title == "Reports"){
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ReportScreen()));
    } else if (title == "Shifts") {
      Navigator.push(context, new MaterialPageRoute(
      builder: (context) => new ShiftsScreen()));
    } else if (title == "Leaderboard") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new LeaderboardScreen()));
    } else if (title == "Rangers") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new RangersScreen()));
    } else if (title == "Log Feedback") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new FeedbackScreen()));
    }/* else if (title == "Patrol") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new PatrolScreen()));
      } else if (title == "View Assets") {
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new AssetsScreen(myAssets: false)));
      } */
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
