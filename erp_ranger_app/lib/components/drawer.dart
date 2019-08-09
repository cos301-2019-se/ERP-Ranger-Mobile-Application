import 'package:erp_ranger_app/screens/report.dart';
import 'package:erp_ranger_app/screens/createShift.dart';
import 'package:erp_ranger_app/screens/feedback.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/login.dart';
import 'package:erp_ranger_app/screens/markers.dart';
import 'package:erp_ranger_app/screens/patrol.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:erp_ranger_app/services/auth.dart';

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

  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Shifts", Icons.assignment_ind),
    new DrawerItem("Reports", Icons.warning),
    new DrawerItem("Log Feedback", Icons.assignment),
    new DrawerItem("Markers", Icons.map),
    new DrawerItem("Patrol", Icons.visibility),
    new DrawerItem("Logout", Icons.exit_to_app)
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
          builder: (context) => new CreateShift()));
    } else if (title == "Reports"){
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ReportScreen()));
    } else if (title == "Log Feedback") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new FeedbackScreen()));
    } else if (title == "Markers") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new MarkersScreen()));
    } else if (title == "Patrol") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new PatrolScreen()));
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
      child: new Column(
        children: <Widget>[
          new DrawerHeader(
            child: new Column(
              children: <Widget>[
                new Text("User's Name Here"),
                new Text("Additional Information Here")
              ],
            ),
          ),
          new Column(
            children: drawerOptions,
          )
        ],
      ),
    );
  }

}