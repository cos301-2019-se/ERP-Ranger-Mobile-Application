import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:erp_ranger_app/services/park.dart';
import 'package:erp_ranger_app/screens/dashboard.dart';
import 'package:erp_ranger_app/services/userData.dart';

class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfileScreen> {
  Auth _profileAuth = new Auth();
  String _id;
  String _user = "Name";
  String _email = "Email";
  int _points = 0;
  String _role = "Role";
  bool _loading = true;
  bool _passwordChange = false;
  bool _nameChange = false;
  FocusNode _changeFocusNode = new FocusNode();
  TextEditingController _changeController = new TextEditingController();
  Widget _userImage;
  String _dropdownValue;
  Park _parks = new Park();

  static Firestore _db = Firestore.instance;
  final TextEditingController _textController = new TextEditingController();

  //loads all relevant information on the user from the database
  Future<void> loadInfo() async{
    _user = await userData.getUserName();
    _email = await userData.getUserEmail();
    _points = await userData.getUserPoints();
    _role = await userData.getUserRole();
    _dropdownValue = await Park.getParkId();

    double width = MediaQuery.of(context).size.width;
    Widget details = new Column(
      children: <Widget>[
        GestureDetector(
          child: new CircleAvatar(
            backgroundImage: await userData.getUserImage(),//NetworkImage(url),
            backgroundColor: Colors.transparent,
            radius: 40,
          ),
          onTap: (){
            _displayImage();
          },
        ),
      ],
    );
    setState(() {
      _userImage=details;
    });

    setState(() {
      _loading = false;
    });

  }

  //opens a preview of the image.
  void _displayImage() async{
    double width = MediaQuery.of(context).size.width;
    showDialog(context: context, child:
    SimpleDialog(
      title: Text(
          await userData.getUserName(),
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.black
          )
      ),
      children: <Widget>[
        Image(image: await userData.getUserImage()), //,height: width/1.5,width: width/1.5,)
        Padding(padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),child: SizedBox(height: 40.0,child: new RaisedButton(elevation: 5.0,shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),color: Color.fromRGBO(18, 27, 65, 1.0),child: Text('Change image',style: TextStyle(fontSize: 20.0, color: Colors.white)),onPressed: () => {changeName()},),),),
        ],
      )
    );
  }

  //Toggles the password change flag to allow for multiple changes to the users password
  void changePassword(){
    if(!this._passwordChange) {
      this._passwordChange = true;
    } else {
      this._passwordChange = false;
    }
    setState(() {

    });
  }

  //Sends a password change email to the users given email
  Future<void> sendPasswordEmail() async{
    _profileAuth.getAuth().sendPasswordResetEmail(email: this._email);
    this._passwordChange = false;
    setState(() {

    });
  }

  //Toggles the name flag to allow for multiple changes to the users name.
  Future<void> changeName() async {
    if(!_nameChange){
      this._nameChange = true;
      setState(() {

      });
      FocusScope.of(context).requestFocus(_changeFocusNode);
    } else {
      this._nameChange = false;
      setState(() {

      });
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  //Sends the users new name to the database.
  Future<void> uploadName() async {
    this._nameChange = false;
    print("TextController value: " + _changeController.text);
    var result = await _db.collection('users').document(_id).updateData({'name': _changeController.text});
    _changeController.clear();
    loadInfo();

    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _changeController.dispose();
    _changeFocusNode.dispose();
    super.dispose();
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
            this._loading == true ? _showLoading() : new Container(),
            _showProfilePicture(),
            _showName(),
            _showChangeName(),
            this._nameChange == true? _showConfirmNewName() : new Container(),
            _showEmail(),
            //_showChangeEmail(),
            _showRole(),
            _showPoints(),
            _showChangePassword(),
            this._passwordChange == true? _showConfirmNewPassword() : new Container(),
            _showParksDropdown()
          ],
        ),
      ),
    );
  }

  Widget _showProfilePicture(){
    if(!_loading){
      return _userImage;
    } else{
      return Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      );
    }
  }

  Widget _showName(){
    if(!_nameChange) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          controller: _changeController,
          focusNode: _changeFocusNode,
          key: Key('Text'),
          maxLines: 1,
          enabled: true,
          decoration: new InputDecoration(
              labelText: _user,
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.accessibility,
                color: Colors.grey,
              )),
          onTap: () =>
          {
            FocusScope.of(context).requestFocus(new FocusNode())
          },
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new TextField(
          focusNode: _changeFocusNode,
          controller: _changeController,
          key: Key('Text'),
          maxLines: 1,
          enabled: true,
          decoration: new InputDecoration(
              labelText: 'Enter new name:',
              border: OutlineInputBorder(),
              prefixIcon: new Icon(
                Icons.accessibility,
                color: Colors.grey,
              )),
        ),
      );
    }
  }

  Widget _showChangeName(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
          color: Color.fromRGBO(18, 27, 65, 1.0),
          child: Text('Change name',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () => {changeName()},
        ),
      ),
    );
  }

  Widget _showConfirmNewName(){
    return Row(
      children: <Widget>[
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(18, 27, 65, 1.0), child: Text("Confirm", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {uploadName(),}),),),
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(200, 0, 0, 1.0), child: Text("Cancel", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {changeName()}),),)
      ],
    );
  }

  Widget _showEmail(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        key: Key('Text'),
        maxLines: 1,
        enabled: true,
        decoration: new InputDecoration(
            labelText: _email,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        onTap: () => {
          FocusScope.of(context).requestFocus(new FocusNode())
        },
      ),
    );
  }

/*
  Widget _showChangeEmail(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
          color: Color.fromRGBO(18, 27, 65, 1.0),
          child: Text('Change email',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () => {},
        ),
      ),
    );
  }
*/

  Widget _showRole(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        key: Key('Text'),
        maxLines: 1,
        enabled: true,
        decoration: new InputDecoration(
            labelText: _role,
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.terrain,
              color: Colors.grey,
            )),
        onTap: () => {
         FocusScope.of(context).requestFocus(new FocusNode())
        },
      ),
    );
  }

  Widget _showPoints(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        key: Key('Text'),
        maxLines: 1,
        enabled: true,
        decoration: new InputDecoration(
            labelText: _points.toString(),
            border: OutlineInputBorder(),
            prefixIcon: new Icon(
              Icons.monetization_on,
              color: Colors.grey,
            )),
        onTap: () => {
          FocusScope.of(context).requestFocus(new FocusNode()),
        }
      ),
    );
  }

  Widget _showChangePassword(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
          color: Color.fromRGBO(18, 27, 65, 1.0),
          child: Text('Change password',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () => {
            changePassword(),
          },
        ),
      ),
    );
  }

  Widget _showConfirmNewPassword(){
    return Row(
      children: <Widget>[
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(18, 27, 65, 1.0), child: Text("Confirm", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {sendPasswordEmail(),}),),),
        new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), child: SizedBox( height: 40, child: new RaisedButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), color: new Color.fromRGBO(200, 0, 0, 1.0), child: Text("Cancel", style: TextStyle(fontSize: 20.0, color: Colors.white),), onPressed: () => {changePassword()}),),)
      ],
    );
  }

  Widget _showParksDropdown() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
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
                          hint: new Text("Select a park"),
                          isExpanded: true,
                          value: _dropdownValue,
                          items: snapshot.data.documents.map((document) =>
                          new DropdownMenuItem<String>(
                            child: new Text(document['name']),
                            value: document.documentID,
                          )
                          ).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              _dropdownValue = newValue;
                              Park.setParkId(newValue);
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

  Widget _showLoading() {
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
}