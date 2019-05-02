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
    // TODO: implement build
    return MaterialApp(
      home: DefaultTabController(
          length: 2,

          child: Scaffold(
            appBar: TabBar(
                  tabs: [
                    Tab(text: 'My Shifts'),
                    Tab(text: 'All Shifts')
                  ]
              ),

            backgroundColor: Colors.blue,
            body: TabBarView(
                children: [
                  MyShifts(),
                  AllShifts()
            ],
            ),

          ))

    );
  }

}