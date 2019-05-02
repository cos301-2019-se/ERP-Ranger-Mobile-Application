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
    return Stack(
        children: <Widget>[
          ListView(
              children : <Widget>[

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

                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0), border: Border.all(color: Colors.white,width: 1.0), color: Colors.blue),

                      height: 40.0,
                      width: 40.0,
                      child: Center(
                        child:  Icon(Icons.arrow_back, color: Colors.white,),
                      ),
                    ),
                  ))


            ],
          )), preferredSize: Size.fromHeight(50.0),)
        ]);
  }

}
