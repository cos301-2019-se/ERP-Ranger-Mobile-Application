
import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/screens/createShift.dart';
import 'package:erp_ranger_app/screens/viewShift.dart';

class ShiftsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ShiftsState();

}

///Shift screen. This screen is the tabs screen. Handles changes between user shifts and all shifts
class ShiftsState extends State<ShiftsScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: Text("ERP Ranger Mobile App"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: new CustomDrawer(),
      body: new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Book a Shift'),
              Tab(text: 'My Shifts')
            ]
          ),
          backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
          body: TabBarView(
            children: [
              CreateShift(),
              ViewShift()
            ],
          ),
        )
      )
    );
  }

}