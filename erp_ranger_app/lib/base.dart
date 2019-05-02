import 'package:erp_ranger_app/screens/home.dart';
import 'package:erp_ranger_app/screens/shifts.dart';
import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class BaseScreen extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Shifts", Icons.timer),
    //new DrawerItem("Screen Items", Icons.mail),
  ];

  /*@override
  State<StatefulWidget> createState() {
    return new BaseScreenState();
  }*/

  @override
  State<StatefulWidget> createState() => BaseScreenState();

}

class BaseScreenState extends State<BaseScreen> {
  int _selectedDrawerIndex = 0;


  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomeScreen();
      case 1:
        //return new Screen();...
        return new ShiftsScreen();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("Ranger Name Here"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}