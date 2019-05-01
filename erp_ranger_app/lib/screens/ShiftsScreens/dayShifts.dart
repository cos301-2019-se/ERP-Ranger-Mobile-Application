import 'package:flutter/material.dart';

import './indivShift.dart';

class DSScreen extends StatefulWidget {
@override
  State<StatefulWidget> createState()  => new DSState();



}

class DSState extends State<DSScreen>{
  void goBack() async{
    Navigator.pop(context);

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
        children: <Widget>[
        ListView(
        children : <Widget>[

          Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
          Card(child: _sizedCardDS(context, "Day - DD/MM/YYYY")),
          ),
          Container(margin: new EdgeInsets.symmetric(vertical:5.0),child:
          Card(child: _sizedCardDS(context, "Day - DD/MM/YYYY")),
          ),

        ]),
        PreferredSize(child: Container(
            decoration : BoxDecoration(color: Colors.transparent) ,height: 50,child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            GestureDetector(
              onTap: goBack,
              child: ClipOval(
                child: Container(

                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0), border: Border.all(color: Colors.blue,width: 1.0), color: Colors.white),

                height: 40.0,
                width: 40.0,
                child: Center(
                  child:  Icon(Icons.arrow_back, color: Colors.blue,),
                ),
              ),
            ))


          ],
        )), preferredSize: Size.fromHeight(50.0),)
        ]);
  }

}

Widget _sizedCardDS (BuildContext context, String s){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: <Widget>[
        _headingDayDS(context, s),
        _shiftTimesDS(context)
      ],
    ),


  );
}


Widget _headingDayDS(BuildContext context, String s){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 50.0,
    child: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Center(child:Text(s, textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, color: Colors.white),),)

    ),
  );
}



Widget _shiftTimesDS(BuildContext context){
  return Column(
    children: <Widget>[
      _shiftTimeDS(context, "7:30-9:30"),
      _shiftTimeDS(context, "9:30-11:30"),
      _shiftTimeDS(context, "11:30-13:30"),
      _shiftTimeDS(context, "13:30-20:30"),
      _shiftTimeDS(context, "15:30-17:30"),
      _shiftTimeDS(context, "17:30-19:30"),
      _shiftTimeDS(context, "19:30-21:30"),
    ],
  );
}
Widget _shiftTimeDS(BuildContext context, String s){
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