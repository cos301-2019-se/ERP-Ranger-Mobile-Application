
import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';

class AssetScreen extends StatefulWidget {

  AssetScreen();

  @override
  State<StatefulWidget> createState() => AssetState();

}

class AssetState extends State<StatefulWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asset Name Here"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: CustomDrawer(),
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: new Center(
            child: _showAssetInformation()
          )
      ),
    );
  }

  Widget _showAssetInformation() {
    return new Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            new Text(
              "Asset Name",
              style: TextStyle(
                fontSize: 22.0
              ),
            ),
            new Text(
              "Asset ID",
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            new Text(
              "Available",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey
              ),
            ),
            new Text(
              "Asset information",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey
              ),
            ),
            SizedBox(
              height: 200.0,
            ),
            _showCheckoutButton()
          ],
        ),
      ),
    );
  }

  Widget _showCheckoutButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 55.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)
          ),
          color: Colors.blue,
          child: Text(
              'Checkout This Asset',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
              )
          ),
        ),
      ),
    );
  }

}

