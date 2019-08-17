import 'package:erp_ranger_app/screens/report.dart';
import 'package:erp_ranger_app/screens/feedback.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/login.dart';
import 'package:erp_ranger_app/screens/markers.dart';
import 'package:erp_ranger_app/screens/patrol.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
//import 'package:erp_ranger_app/screens/assets.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/userData.dart';
import 'package:erp_ranger_app/screens/leaderboard.dart';
import 'package:erp_ranger_app/screens/shifts.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class CustomDrawer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CustomDrawerState();

}

class CustomDrawerState extends State<CustomDrawer> {

  bool _loaded=false;
  Widget _userDetails;

  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Shifts", Icons.assignment_ind),
    new DrawerItem("Reports", Icons.warning),
    new DrawerItem("Log Feedback", Icons.assignment),
    //new DrawerItem("Park Assets", Icons.build),
    new DrawerItem("Markers", Icons.map),
    new DrawerItem("Patrol", Icons.visibility),
    new DrawerItem("Leaderboard", Icons.stars),
    new DrawerItem("Logout", Icons.exit_to_app),
  ];

  void _getDrawerItemWidget(String title) {
    if (title == "Home")  {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new DashboardScreen()));
    }
    else if (title == "Shifts") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ShiftsScreen()));
    } else if (title == "Reports"){
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ReportScreen()));
    } else if (title == "Log Feedback") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new FeedbackScreen()));
    /*} else if (title == "Park Assets") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => AssetsScreen(myAssets: false)));*/
    } else if (title == "Markers") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new MarkersScreen()));
    } else if (title == "Patrol") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new PatrolScreen()));
    } else if (title == "Leaderboard") {
      Navigator.pop(context);
      (new Auth()).signOut();
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new LeaderboardScreen()));
    } else if (title == "Logout") {
      Navigator.pop(context);
      (new Auth()).signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => LoginScreen(auth: new Auth())));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];

    drawerOptions.add(
        new DrawerHeader(
          child: _showDetails(),
        )
    );

    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            //selected: i == _selectedDrawerIndex,
            onTap: () => this._getDrawerItemWidget(d.title),
          )
      );
    }

    return new Drawer(
      child: new ListView(
        children: drawerOptions,
      ),
    );
  }

  Widget _showDetails() {
    if(!_loaded)
    {
      _getDetails();
    }
    if(_loaded) {
      return _userDetails;
    }
    else {
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

  void _getDetails() async {
    Widget details = new Column(
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundImage: await userData.getUserImage(),//NetworkImage(url),
                          backgroundColor: Colors.transparent,
                        ),
                        new Text(await userData.getUserName()),
                        new Text(await userData.getUserEmail())
                      ],
                    );
    setState(() {
      _userDetails=details;
      _loaded=true;
    });
  }

}