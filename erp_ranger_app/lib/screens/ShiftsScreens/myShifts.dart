import 'package:flutter/material.dart';

import 'indivShift.dart';


class MyShifts extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: new Color(0xFFEEEEEE)),
      child: Center(
          child: ListView(
            children: <Widget>[
            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCard(context, "Monday - 22/04/2019")),
            ),

            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCard(context, "Tuesday - 23/04/2019")),
            ),

            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCardO(context, "Wednesday - 24/04/2019")),
            ),

            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCard(context, "Thursday - 25/04/2019")),
            ),
            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCard(context, "Friday - 26/04/2019")),
            ),
            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCard(context, "Saturday - 27/04/2019")),
            ),
            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCard(context, "Sunday - 28/04/2019")),
            ),
            Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
            Card(elevation : 10.0,child: _sizedCard(context, "Monday - 29/04/2019")),
            ),
            ],
          )
      ),
    );
  }
}

Widget _sizedCard (BuildContext context, String s){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: <Widget>[
        _headingDay(context, s),
        _shiftTimes(context)
      ],
    ),


  );
}

Widget _sizedCardO (BuildContext context, String s){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: <Widget>[
        _headingDay(context, s),
        _shiftTimesO(context)
      ],
    ),


  );
}

Widget _shiftTimesO(BuildContext context){
  return Column(
    children: <Widget>[
      _shiftTime(context, "7:30-9:30"),

    ],
  );
}

Widget _headingDay(BuildContext context, String s){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 50.0,
    child: Container(
      decoration: BoxDecoration(color: Colors.blue),
      child: Center(child:Text(s, textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, color: Colors.white),),)

    ),
  );
}



Widget _shiftTimes(BuildContext context){
  return Column(
    children: <Widget>[
      _shiftTime(context, "7:30-9:30"),
      _shiftTime(context, "14:30-18:20")
    ],
  );
}
Widget _shiftTime(BuildContext context, String s){
  return SizedBox(

    width: MediaQuery.of(context).size.width,
    height: 40.0,
      child: GestureDetector(
      onTap: (){

        goToIndivShifts(context);
      },
    child: Container(

      decoration: BoxDecoration(color: Colors.white),
      child: Center(child: Text(s,textAlign: TextAlign.center),)
    )

    
  ));
}

void goToIndivShifts(context){
  Navigator.push(context, MaterialPageRoute(builder: (context) => indivSScreen()));
}