import 'package:erp_ranger_app/components/drawer.dart';
import 'package:erp_ranger_app/screens/assets.dart';
import 'package:erp_ranger_app/screens/endShift.dart';
import 'package:erp_ranger_app/screens/report.dart';
import 'package:erp_ranger_app/screens/createShift.dart';
import 'package:erp_ranger_app/screens/feedback.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/login.dart';
import 'package:erp_ranger_app/screens/markers.dart';
import 'package:erp_ranger_app/screens/patrol.dart';
import 'package:erp_ranger_app/screens/shifts.dart';
import 'package:erp_ranger_app/screens/leaderboard.dart';

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();

}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ERP Ranger Mobile App"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: CustomDrawer(),
      body: //Column(
        //children: <Widget>[
          Container(
            //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            child: GridView.count(
              crossAxisCount: 2,
              //padding: EdgeInsets.all(3.0),
              children: <Widget>[
                // TODO rename
                makeDashboardItem("Shifts", Icons.assignment_ind),
                makeDashboardItem("Reports", Icons.warning),
                makeDashboardItem("Log Feedback", Icons.assignment),
                //makeDashboardItem("View Assets", Icons.business_center),
                makeDashboardItem("Markers", Icons.map),
                makeDashboardItem("Patrol", Icons.visibility),
                makeDashboardItem("Leaderboard", Icons.stars)
              ]
            ),
          ),
        //]
      //),
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown,
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
                ]
              ),
              new Row(
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
                  )
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

  void _onItemTapped(int index) {
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
  }

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

  Card makeDashboardItem(String title, IconData icon) {
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
  }
}