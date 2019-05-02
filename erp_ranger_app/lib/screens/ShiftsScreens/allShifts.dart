import 'package:flutter/material.dart';

import './dayShifts.dart';

///Sets grid for 7 days
List<Widget> setDays()
{
  final _children = <Widget> [];
  _children.add(_days("S"));
  _children.add(_days("M"));
  _children.add(_days("T"));
  _children.add(_days("W"));
  _children.add(_days("T"));
  _children.add(_days("F"));
  _children.add(_days("S"));
  return _children;
}

///Statically sets the days of the month
List<Widget> loopThing(BuildContext context) {
  final children = <Widget>[];


  for (int i = 0; i < 31; i++) {
    if(i==0)
      {
        children.add(_falseDay());
      }
    else if(i>21 && i< 30){
        children.add(_day(i , true,context));
      }
    else{
      children.add(_day(i , false, context));
      }

  }
  return children;
}


class AllShifts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: new Color(0xFFEEEEEE)),
        child : Column(
          children: <Widget>[
            Text("April", style: TextStyle(fontSize: 30.0)),
            gridOne(),





            Expanded(
              child: gridTwo(context),

            )

          ],
        )
          
         );
  }
}

///Creates grid for days of week
Widget gridOne(){
  return  GridView.count(
    crossAxisCount: 7,
    childAspectRatio: 2,
    mainAxisSpacing: 0.0,
    crossAxisSpacing: 2.0,
    shrinkWrap: true,
    children: setDays(),
  );
}

///Creates grid for all days of the month
Widget gridTwo(BuildContext context){
  return  GridView.count(
    crossAxisCount: 7,
    childAspectRatio: 0.7,
    mainAxisSpacing: 2.0,
    crossAxisSpacing: 2.0,

    children: loopThing(context),
  );
}

///Essentially Just a space so the first day doesn't start on the Sunday
Widget _falseDay(){
  return  Container(
      decoration: BoxDecoration(color: new Color(0x00EEEEEE)),
      child: Center(
        child: Text(
          '',
          style: TextStyle(fontSize: 24.0, color: new Color(0xFFEEEEEE)),
        ),
      ));
  
}

///Individual day set, darker means user has shift on that day
Widget _day(int i, bool b, BuildContext context) {
  if (b){

  return GestureDetector(
        onTap: (){
        _goToDayScreen(context);
        },
        child : Container(
            decoration: BoxDecoration(color: Colors.blue),
        child: Center(
        child: Text(
        '$i',
        style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        )));
  }
  else{
    return GestureDetector(
        onTap: (){
      _goToDayScreen(context);
    },
      child : Container(
        decoration: BoxDecoration(color: new Color(0xFF5DBCD2)),
        child: Center(
          child: Text(
            '$i',
            style: TextStyle(fontSize: 24.0, color: Colors.white),
          ),
        )));
  }

}

///Day of week individual grid items(MTWTF)
Widget _days(String s,)
{
  return  Container(

      decoration: BoxDecoration(color: new Color(0xFF000000)),
      child:  Center(
        child: Text(
          s,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ));
}

///Opens all shifts for a day
void _goToDayScreen(context){
  Navigator.push(context, MaterialPageRoute(builder: (context) => DSScreen()));
}
