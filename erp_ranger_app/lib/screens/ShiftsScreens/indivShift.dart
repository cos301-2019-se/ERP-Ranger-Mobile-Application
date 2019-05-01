import 'package:flutter/material.dart';

class indivSScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState()  => new indivSState();



}

class indivSState extends State<indivSScreen>{
  void goBack() async{
    Navigator.pop(context);

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: ListView(
            children : <Widget>[
              Container(
                  child: RaisedButton(onPressed: goBack,
                    child: Text("Back"),)
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                      elevation: 5,
                      child : Column(
                          children : <Widget>[
                            Text("Group:", style: TextStyle(fontSize: 25,color: Colors.black,),),
                            Text("Name Surname:", style: TextStyle(fontSize: 25,color: Colors.black)),
                            Text("Name Surname:", style: TextStyle(fontSize: 25,color: Colors.black)),
                            Text("Name Surname:", style: TextStyle(fontSize: 25,color: Colors.black)),


                          ]
                      ))),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180.0,
                  child: Card(
                      elevation: 5,
                      child : Column(
                          children : <Widget>[
                            Text("Path:", style: TextStyle(fontSize: 25,color: Colors.black,),),
                            Center(child : Text("Path Description goes here:", style: TextStyle(fontSize: 25,color: Colors.black))),



                          ]
                      ))),
              SizedBox(
                  width: MediaQuery.of(context).size.width,

                  child: Card(
                      elevation: 5,
                      child : Column(
                          children : <Widget>[
                            Text("Time:", style: TextStyle(fontSize: 25,color: Colors.black,),),
                            Text("XX:XX - YY:YY", style: TextStyle(fontSize: 25,color: Colors.black)),



                          ]))),

            ]));
  }

}
