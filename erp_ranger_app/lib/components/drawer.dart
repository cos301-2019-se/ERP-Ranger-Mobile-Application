
import 'package:erp_ranger_app/login.dart';
//import 'package:erp_ranger_app/screens/assets.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:erp_ranger_app/screens/report.dart';
import 'package:erp_ranger_app/screens/shifts.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:flutter/material.dart';

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
    new DrawerItem("My Patrol Shifts", Icons.person),
    new DrawerItem("All Patrol Shifts", Icons.timer),
    //new DrawerItem("Park Assets", Icons.build),
    new DrawerItem("Submit a Report", Icons.report_problem),
    new DrawerItem("Logout", Icons.exit_to_app)
  ];

  void _getDrawerItemWidget(int pos) {
    Navigator.pop(context);
    switch (pos) {
      case 0: // Home
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        return;
      case 1: // My Patrol Shifts
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftsScreen()));
        return;
      case 2: // All Patrol Shifts
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftsScreen()));
        return;
      case 3: // Submit a Report
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen()));
        return;
      case 4:
        (new Auth()).signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(auth: new Auth())));
        return;
      default:
        return;

      /*case 3: // Park Assets
        Navigator.push(context, MaterialPageRoute(builder: (context) => AssetsScreen(myAssets: false)));
        return;*/
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
            onTap: () => this._getDrawerItemWidget(i),
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