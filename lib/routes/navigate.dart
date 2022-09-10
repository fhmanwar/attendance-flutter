import 'package:attendance/screens/home.dart';
import 'package:flutter/material.dart';

var route = <String, WidgetBuilder>{
  "/home": (context) => new Home(),
};

class Navigate {
  void gotoHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}