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
import 'package:erp_ranger_app/screens/ranger.dart';
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
    new DrawerItem("Map", Icons.map),
    new DrawerItem("Reports", Icons.message),
    new DrawerItem("Shifts", Icons.date_range),
    new DrawerItem("Leaderboard", Icons.stars),
    new DrawerItem("Rangers", Icons.directions_walk),
    new DrawerItem("Logout", Icons.exit_to_app),
    //new DrawerItem("Log Feedback", Icons.assignment),
    //new DrawerItem("Park Assets", Icons.build),
    //new DrawerItem("Patrol", Icons.visibility),
  ];

  void _getDrawerItemWidget(String title) {
    if (title == "Home")  {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new DashboardScreen()));
    } else if (title == "Map") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new MarkersScreen()));
    } else if (title == "Reports"){
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ReportScreen()));
    } else if (title == "Shifts") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ShiftsScreen()));
    } else if (title == "Leaderboard") {
      Navigator.pop(context);
      (new Auth()).signOut();
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new LeaderboardScreen()));
    }  else if (title == "Rangers") {
      Navigator.pop(context);
      (new Auth()).signOut();
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new RangersScreen()));
    } else if (title == "Logout") {
      Navigator.pop(context);
      (new Auth()).signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => LoginScreen(auth: new Auth())));
    }
    /* else if (title == "Log Feedback") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new FeedbackScreen()));*/
    /*} else if (title == "Park Assets") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => AssetsScreen(myAssets: false)));*/
    /*} else if (title == "Patrol") {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new PatrolScreen()));
      }*/
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
            leading: new Icon(d.icon,size: 40,color: Color.fromRGBO(18, 27, 65, 1.0),),
            title: new Text(d.title,style: TextStyle(fontSize: 20,color: Color.fromRGBO(18, 27, 65, 1.0)),),
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
      double width = MediaQuery.of(context).size.width;
      return Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: Container(
            alignment: Alignment.center,
            height: 150,//50.0,
            width: 100,//50.0,
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
              height: 50,//+35,//50.0,
              width: 50,//+35,//50.0,
            ),
          )
      );
    }
  }

  void _getDetails() async {
    double width = MediaQuery.of(context).size.width;
    Widget details = new Column(
                      children: <Widget>[
                        GestureDetector(
                          child: new CircleAvatar(
                            backgroundImage: await userData.getUserImage(),//NetworkImage(url),
                            backgroundColor: Colors.transparent,
                            radius: 40,
                          ),
                          onTap: (){
                            _displayImage();
                          },
                        ),
                        new Text(await userData.getUserName(),style: TextStyle(fontSize: 20,color: Color.fromRGBO(18, 27, 65, 1.0)),),
                        new Text(await userData.getUserEmail(),style: TextStyle(color: Color.fromRGBO(18, 27, 65, 1.0)),),
                      ],
                    );
    setState(() {
      _userDetails=details;
      _loaded=true;
    });
  }

  void _displayImage() async{
    double width = MediaQuery.of(context).size.width;
    showDialog(context: context, child:
    SimpleDialog(
      title: Text(
          await userData.getUserName(),
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.black
          )
      ),
      children: <Widget>[
        Image(image: await userData.getUserImage())//,height: width/1.5,width: width/1.5,)
      ],
    )
    );
  }

}