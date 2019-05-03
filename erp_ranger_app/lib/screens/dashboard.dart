import 'package:erp_ranger_app/components/drawer.dart';
import 'package:erp_ranger_app/screens/assets.dart';
import 'package:erp_ranger_app/screens/report.dart';
import 'package:erp_ranger_app/screens/shifts.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/login.dart';

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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            // TODO rename
            makeDashboardItem("Shifts", Icons.book),
            makeDashboardItem("Reports", Icons.alarm),
            makeDashboardItem("Log Feedback", Icons.alarm),
            makeDashboardItem("View Assets", Icons.alarm),
            makeDashboardItem("Alphabet", Icons.alarm),
            makeDashboardItem("Alphabet", Icons.alarm)
          ],
        ),
      ),
    );
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
              if (title == "Shifts") {
                //Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new ShiftsScreen()));
              } else if (title == "Reports"){
                //Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new ReportScreen()));
              } else {
                //Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new AssetsScreen(myAssets: false)));
              }
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