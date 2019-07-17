
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/services/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({this.auth});

  Auth auth;

  @override
  State<StatefulWidget> createState() => new LoginState();

}

class LoginState extends State<LoginScreen> {

  String _email;
  String _password;
  bool _attempting = false;
  bool _error = false;
  bool _valid = true;
  String dropdownValue;
  Park _parks;
  String _park = null;

  LoginState() {
    this._checkLogin();
    this._parks = new Park();
  }

  void _checkLogin() async {
    Auth tempAuth = new Auth(); // Temporary solution because widget.auth.checkUserLogin() doesn't work.
    bool isLoggedIn = await tempAuth.checkUserLogin();
    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  void _performLogin() async {
    this._validate();
    if(this._valid) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {
        this._attempting = true;
        this._error = false;
      });
      try {
        String uid = await widget.auth.signIn(_email, _password);
        Park.setParkId(this._park);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      } on PlatformException catch (e) {
        setState(() {
          this._attempting = false;
          this._error = true;
        });
      }
    }
  }

  void _validate() {
    setState(() {
      this._valid = Validator.email(_email);
      if (!this._valid) {
        return;
      }
      this._valid = Validator.password(_password);
      if (!this._valid) {
        return;
      }
      this._valid = ((this._park != null) && (this._park.length == 20));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: new Center(
          child: ListView(
            children: <Widget>[
              _showImage(),
              this._error == true ? _showLoginError() : new Container(),
              this._valid == false ? _showValidationError() : new Container(),
              _showEmailInput(),
              _showPasswordInput(),
              _showParksDropdown(),
              _showLoginButton(),
              this._attempting == true ? _showAttempting() : new Container(),
            ],
          ),
        ),
      )
    );
  }

  Widget _showImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Image.asset(
        'assets/images/erplogo_trans.png',
        width: 200,
        height: 200,
        fit: BoxFit.fitHeight,
      )
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextField(
        key: Key('email_input'),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.mail,
              color: Colors.grey,
          )
        ),
        onChanged: (value) => this._email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextField(
        key: Key('password_input'),
        maxLines: 1,
        obscureText: true,
        decoration: new InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )
        ),
        onChanged: (value) => this._password = value,
      ),
    );
  }

  Widget _showLoginButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)
          ),
          color: Colors.blue,
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white
            )
          ),
          onPressed: this._attempting == false? _performLogin : null,
        ),
      ),
    );
  }

  Widget _showParksDropdown() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new Container(
        padding: EdgeInsets.fromLTRB(12.0, 3.0, 12.0, 3.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.0,
              style: BorderStyle.solid
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0))
          )
        ),
        child: new StreamBuilder(
          stream: this._parks.read().snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text("Loading...");
              default:
                return new DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    hint: new Text("Select a Park"),
                    isExpanded: true,
                    value: dropdownValue,
                    items: snapshot.data.documents.map((document) =>
                    new DropdownMenuItem<String>(
                      child: new Text(document['name']),
                      value: document.documentID,
                    )
                    ).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        this._park = newValue;
                      });
                    },
                  )
                );
            }
          }
        )
      ),
    );
  }
  
  Widget _showAttempting() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        width: 50.0,
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
          height: 50.0,
          width: 50.0,
        ),
      )
    );
  }

  Widget _showLoginError() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "Please check your username or password.",
          style: TextStyle(
            color: Colors.red
          ),
        ),
      ),
    );
  }

  Widget _showValidationError() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "Please enter a valid email and password.",
          style: TextStyle(
              color: Colors.red
          ),
        ),
      ),
    );
  }

}