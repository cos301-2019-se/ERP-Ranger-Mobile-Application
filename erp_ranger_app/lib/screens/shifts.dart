
import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';

import './ShiftsScreens/allShifts.dart';
import './ShiftsScreens/myShifts.dart';


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
              Tab(text: 'My Shifts'),
              Tab(text: 'All Shifts')
            ]
          ),
          backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
          body: TabBarView(
            children: [
              MyShifts(),
              AllShifts()
            ],
          ),
        )
      )
    );
  }

}