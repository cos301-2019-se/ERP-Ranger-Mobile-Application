
import 'package:erp_ranger_app/components/drawer.dart';
import 'package:erp_ranger_app/screens/asset.dart';
import 'package:flutter/material.dart';

class AssetsScreen extends StatefulWidget {

  AssetsScreen({this.myAssets});

  bool myAssets;

  @override
  State<StatefulWidget> createState() => AssetsState(myAssets: this.myAssets);

}

class AssetsState extends State<StatefulWidget> {

  AssetsState({this.myAssets});

  bool myAssets;

  final assets = [
    "Flashlight 1",
    "Flashlight 2",
    "Flashlight 3",
    "Storage Unit 1 Keys",
    "Rifle 1",
    "Rifle 2",
    "Rifle 3",
    "Drone 1",
  ];

  void _openAssetScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AssetScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: this.myAssets ? Text("My Assets") : Text("Park Assets"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(18, 27, 65, 1.0),
      ),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: new Center(
          child: ListView.builder(itemBuilder: (context, position) {
            return new GestureDetector(
              child: new Card(
                child: new Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    this.assets[position],
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                ),
              ),
              onTap: () => _openAssetScreen(),
            );
          },
          itemCount: this.assets.length,
          ),
        )
      ),
    );
  }

}

