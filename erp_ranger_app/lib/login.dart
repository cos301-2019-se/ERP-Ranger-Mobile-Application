import 'package:erp_ranger_app/base.dart';
import 'package:erp_ranger_app/dashboard.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new LoginState();

}

class LoginState extends State<LoginScreen> {

  void performLogin() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _showEmailInput(),
            _showPasswordInput(),
            _showLoginButton()
          ],
        ),
      )
    );
  }

  Widget _showEmailInput(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          labelText: 'Email',
          icon: new Icon(
              Icons.mail,
              color: Colors.grey,
          )
        ),
      ),
    );
  }

  Widget _showPasswordInput(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
            labelText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )
        ),
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
            borderRadius: new BorderRadius.circular(30.0)
          ),
          color: Colors.red,
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white
            )
          ),
          onPressed: performLogin,
        ),
      ),
    );
  }

}