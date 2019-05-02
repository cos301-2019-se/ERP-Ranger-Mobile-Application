import 'package:erp_ranger_app/login.dart';
import 'package:erp_ranger_app/services/auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(RangerApp());

class RangerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP Ranger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(auth: new Auth())
    );
  }
}