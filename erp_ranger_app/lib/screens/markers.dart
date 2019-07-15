import 'package:erp_ranger_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:erp_ranger_app/components/map.dart';

class MarkersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MarkersState();
}

class MarkersState extends State<MarkersScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new CustomDrawer(),
      body: new MapComponent(),
    );
  }
}
