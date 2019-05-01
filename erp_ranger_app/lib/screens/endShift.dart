import 'package:flutter/material.dart';

class EndOfShiftScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new EndOfShift();
}

class EndOfShift extends State<EndOfShiftScreen> {
  //List<ReturnAssetForm> dynamicForm = [];
  bool assetBoxValue = false;
  bool assetFlag = false;
  bool feedbackBoxValue = false;
  bool feedbackFlag = false;
  int length = 7;

/*
  void showReturnAssetForm() async {
    if(checkBoxValue && !assetFlag) {
      dynamicForm.add(new ReturnAssetForm());
      setState(() {});
    }
    else if(!checkBoxValue && assetFlag){
      dynamicForm.clear();
      setState(() {});
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('End of Shift'),
      ),
      body: new Container(
          padding: EdgeInsets.all(16.0),
          child: new ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                int i = index;
                if (i == 0) {
                  return new Column(
                    children: <Widget>[
                      _showAssetCheckBoxText(),
                      _showReturnAssetCheckBox(),
                      ReturnAssetForm().build(context),
                      _showFeedbackCheckBoxText(),
                      _showFeedbackCheckBox(),
                      _showFeedbackForm(),
                      _showEndShiftButton(),
//            new Flexible(
//                child: ListView.builder(
//                    itemCount: dynamicForm.length,
//                    itemBuilder: (_, index) => dynamicForm[index])),
                    ],
                  );
                }
              })

      ),
    );
  }

  Widget _showAssetCheckBoxText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new Container(
        color: Colors.blue,
        child: new SizedBox(
          width: 250.0,
          height: 25.0,
          child: new Text(
            'Asset to return?',
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _showReturnAssetCheckBox() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Checkbox(
          value: assetBoxValue,
          onChanged: (bool newValue) {
            setState(() {
              assetBoxValue = newValue;
              if (assetBoxValue && !assetFlag) {
//                showReturnAssetForm();
              }
              assetFlag = true;
            });
          }),
    );
  }

  Widget _showFeedbackCheckBoxText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new Container(
        color: Colors.blue,
        child: new SizedBox(
          width: 250.0,
          height: 25.0,
          child: new Text(
            'Feedback to report?',
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _showFeedbackCheckBox() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Checkbox(
          value: feedbackBoxValue,
          onChanged: (bool newValue) {
            setState(() {
              feedbackBoxValue = newValue;
              if (feedbackBoxValue && !assetFlag) {
//                showReturnAssetForm();
              }
              feedbackFlag = true;
            });
          }),
    );
  }

  Widget _showFeedbackForm() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          textAlign: TextAlign.left,
          maxLines: null,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
              labelText: 'Feedback'
          ),
        )
    );
  }

  Widget _showEndShiftButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: SizedBox(
        height: 40,
        child: new RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)
          ),
          color: Colors.blue,
          child: Text(
            'Return Asset', style: TextStyle(
              fontSize: 20.0,
              color: Colors.white
          ),
          ),
          onPressed: null,
        ),
      ),
    );
  }
}

class ReturnAssetForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(10.0, 0.0),
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new Column(children: <Widget>[
        new TextFormField(
          textAlign: TextAlign.justify,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            labelText: 'Asset ID',
          ),
        ),
      ],
      ),
    );
  }
}
