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
import 'dart:async';
import 'package:erp_ranger_app/services/patrolData.dart';


class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();

}

class _DashboardScreenState extends State<DashboardScreen> {

  String _timeString = '00:00:00';
  String _patrolButtonText;
  bool _loadedPatrol=false;
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

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
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(int duration) {
    int seconds = ((duration / 1000) % 60).floor(),
        minutes = ((duration / (1000 * 60)) % 60).floor(),
        hours = ((duration / (1000 * 60 * 60)) % 24).floor();

    String hoursStr = (hours < 10) ? "0" + hours.toString() : hours.toString();
    String minutesStr = (minutes < 10) ? "0" + minutes.toString() : minutes.toString();
    String secondsStr = (seconds < 10) ? "0" + seconds.toString() : seconds.toString();

    return hoursStr + ":" + minutesStr + ":" + secondsStr;
  }

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

          //type 1
          /*this._loadedPatrol == true ? Card(
              color: Color.fromRGBO(154, 126, 97, 1),
              child: new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)
                ),
                color: Color.fromRGBO(154, 126, 97, 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.visibility,color: Colors.black),
                      iconSize: 48.0,
                    ),
                    Text(
                      _patrolButtonText,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black
                      )
                    ),
                  ],
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

          Card(
            color: Color.fromRGBO(154, 126, 97, 1),
            child: ListTile(
              leading: new Icon(Icons.map,color: Colors.black, size: 48,),
              title: new Text(
                'Map',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
              trailing: new Icon(Icons.arrow_forward_ios,color: Colors.black),
              onTap: () {
                _openScreen("Markers");
              },
            ),
          ),
          Card(
            color: Color.fromRGBO(154, 126, 97, 1),
            child: ListTile(
              leading: new Icon(Icons.message,color: Colors.black, size: 48,),
              title: new Text(
                'Report',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
              trailing: new Icon(Icons.arrow_forward_ios,color: Colors.black),
              onTap: () {
                _openScreen("Reports");
              },
            ),
          ),
          Card(
            color: Color.fromRGBO(154, 126, 97, 1),
            child: ListTile(
              leading: new Icon(Icons.directions_walk,color: Colors.black, size: 48,),
              title: new Text(
                'Rangers',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
              trailing: new Icon(Icons.arrow_forward_ios,color: Colors.black),
              onTap: () {
                _openScreen("Rangers");
              },
            ),
          ),
          Card(
            color: Color.fromRGBO(154, 126, 97, 1),
            child: ListTile(
              leading: new Icon(Icons.date_range,color: Colors.black, size: 48,),
              title: new Text(
                'Shifts',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
              trailing: new Icon(Icons.arrow_forward_ios,color: Colors.black),
              onTap: () {
                _openScreen("Shifts");
              },
            ),
          ),
          Card(
            color: Color.fromRGBO(154, 126, 97, 1),
            child: ListTile(
              leading: new Icon(Icons.stars,color: Colors.black, size: 48,),
              title: new Text(
                'Leaderboard',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
              trailing: new Icon(Icons.arrow_forward_ios,color: Colors.black),
              onTap: () {
                _openScreen("Leaderboard");
              },
            ),
          ),*/

          Expanded(
            child:Container(
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('assets/images/2.png'),
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
                            _openScreen("Report");
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
                /*child:Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: Image.asset(
                      'assets/images/stopwatch.png',
                      fit: BoxFit.cover,
                    )
                ),*/
                /*child: GridView.count(
                      crossAxisCount: 2,
                      //padding: EdgeInsets.all(3.0),
                      children: <Widget>[*/
                 //constraints: new BoxConstraints.expand(height: 200.0),
                // TODO rename
                //makeDashboardItem("Shifts", Icons.assignment_ind),
                //makeDashboardItem("Reports", Icons.warning),
                //makeDashboardItem("Log Feedback", Icons.assignment),
                //makeDashboardItem("View Assets", Icons.business_center),
                //makeDashboardItem("Markers", Icons.map),
                //makeDashboardItem("Patrol", Icons.visibility),
                //makeDashboardItem("Leaderboard", Icons.stars)
              //]
      ),
          //),


      bottomNavigationBar: BottomAppBar(
        //color: Color.fromRGBO(154, 126, 97, 1), //brown
        color: Color.fromRGBO(18, 27, 65, 1.0), //blue
        /*child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.assignment_ind),
                onPressed: () {
                  _openScreen("Shifts");
                }),
            IconButton(
                icon: Icon(Icons.warning),
                onPressed: () {
                  _openScreen("Report");
                }),
            IconButton(
                icon: Icon(Icons.assignment),
                onPressed: () {
                  _openScreen("Log Feedback");
                }),
            IconButton(
                icon: Icon(Icons.map),
                onPressed: () {
                  _openScreen("Markers");
                }),
            IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () {
                  _openScreen("Patrol");
                }),
            IconButton(
                icon: Icon(Icons.stars),
                onPressed: () {
                  _openScreen("Leaderboard");
                }),
          ],
        ),*/
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
                  /*IconButton(
                      icon: Icon(Icons.business_center),
                      onPressed: () {
                        _openScreen("View Assets");
                      })*/
                ]
              ),
              /*new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {
                        _openScreen("Markers");
                      }),
                  IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        _openScreen("Patrol");
                      }),
                  IconButton(
                      icon: Icon(Icons.stars),
                      onPressed: () {
                        _openScreen("Leaderboard");
                      }),*/
                  SizedBox(
                      height: 40.0,
                      child: new RaisedButton(
                          elevation: 5.0,
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)
                          ),
                          child: Icon(
                              Icons.map
                          ),
                          onPressed: (){_openScreen("Markers");}
                      )
                  ),
                  SizedBox(
                      height: 40.0,
                      child: new RaisedButton(
                          elevation: 5.0,
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)
                          ),
                          child: Icon(
                          Icons.visibility
                      ),
                          onPressed: (){_openScreen("Patrol");}
                      )
                  ),
                  SizedBox(
                      height: 40.0,
                      child: new RaisedButton(
                          elevation: 5.0,
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)
                          ),
                          child: Icon(
                              Icons.stars
                          ),
                          onPressed: (){_openScreen("Leaderboard");}
                          ),
                      )
                  ]
                  )*/
                ],
              )
      ),
      /*BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_ind,
              size: 40.0,
              color: Colors.black,
            ),
            title: Text("Shifts")
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.warning,
              size: 40.0,
              color: Colors.black,
            ),
            title: Text("Reports"),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment_ind,
                size: 40.0,
                color: Colors.black,
              ),
              title: Text("Shifts")
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.warning,
              size: 40.0,
              color: Colors.black,
            ),
            title: Text("Reports"),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment_ind,
                size: 40.0,
                color: Colors.black,
              ),
              title: Text("Shifts")
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.warning,
              size: 40.0,
              color: Colors.black,
            ),
            title: Text("Reports"),
          )
        ],
        onTap: _onItemTapped,
      ),*/
    );
  }

  /*void _onItemTapped(int index) {
    if (index == 0) {
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ShiftsScreen()));
    } else if (index == 1){
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ReportScreen()));
      /*} else if (title == "View Assets") {
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new AssetsScreen(myAssets: false)));*/
    } else if (index == 2) {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new FeedbackScreen()));
    } else if (index == 3) {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new MarkersScreen()));
    } else if (index == 4) {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new PatrolScreen()));
    } else if (index == 5) {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new LeaderboardScreen()));
    }
  }*/

  void _openScreen(String title) {
    if (title == "Shifts") {
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ShiftsScreen()));
    } else if (title == "Reports"){
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ReportScreen()));
    /*} else if (title == "View Assets") {
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new AssetsScreen(myAssets: false)));*/
    } else if (title == "Log Feedback") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new FeedbackScreen()));
    } else if (title == "Markers") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new MarkersScreen()));
    } else if (title == "Patrol") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new PatrolScreen()));
    } else if (title == "Leaderboard") {
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new LeaderboardScreen()));
    }
  }

  /*Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: new InkWell(
            // Bind individual screens to buttons TODO add various screen links
            onTap: () {
              _openScreen(title);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                      icon,
                      size: 40.0,
                      color: Colors.black,
                    )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                      new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }*/

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}