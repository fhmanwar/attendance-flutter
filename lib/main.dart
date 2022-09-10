import 'package:attendance/app.dart';
import 'package:attendance/routes/navigate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(primaryColor: Colors.blue),
    initialRoute: '/',
    home: new App(),
    routes: route,
  ));
}
