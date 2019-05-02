import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<ReportScreen> {
  final TextEditingController _reportTextFieldController = new TextEditingController();
  DateTime now;

  void performReport() async {
    _reportTextFieldController.clear();
    now = new DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("ERP Ranger Mobile App"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: new CustomDrawer(),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
        child: ListView(
          children: <Widget>[
            _showReportDetails(),
            _showReportTextField(),
            _showReportButton()
          ],
        ),
      ),
    );
  }

  Widget _showReportDetails() {
    now = new DateTime.now();
    return RichText (
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.blue
        ),
        children: <TextSpan>[
          /*new TextSpan(text: 'Ranger name:\n'),
          new TextSpan(text: 'Automatically Retrieved\n',style: new TextStyle(fontSize: 15.0,color: Colors.black)),
          new TextSpan(text: 'Ranger ID:\n'),
          new TextSpan(text: 'Automatically Retrieved\n',style: new TextStyle(fontSize: 15.0,color: Colors.black)),*/
          new TextSpan(text: 'Location:\n'),
          new TextSpan(text: 'Automatically Retrieved\n',style: new TextStyle(fontSize: 15.0,color: Colors.black)),
          new TextSpan(text: 'Date:\n'),
          new TextSpan(text: now.day.toString()+'-'+now.month.toString()+'-'+now.year.toString()+'\n',style: new TextStyle(fontSize: 15.0,color: Colors.black)),
          new TextSpan(text: 'Time:\n'),
          new TextSpan(text: now.hour.toString()+':'+now.minute.toString(),style: new TextStyle(fontSize: 15.0,color: Colors.black)),
        ]
      )
    );
  }

  Widget _showReportTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child:TextField(
        controller: _reportTextFieldController,
        autofocus: true,
        autocorrect: true,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Report Details',
          labelStyle: TextStyle(
            fontSize: 25.0
          )
        )
      )
    );
  }

  Widget _showReportButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          color: Colors.red,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          child: Text(
            'Report',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white
            )
          ),
          onPressed: performReport
        )
      )
    );
  }
}
