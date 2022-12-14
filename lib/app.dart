import 'dart:async';

import 'package:flutter/material.dart';
import 'package:attendance/routes/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  // App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  startTime() async {
    final prefs = await SharedPreferences.getInstance();
    // final value = prefs.getString('userId');
    // var _duration = new Duration(seconds: 5);
    return Timer(Duration(seconds: 3), () {
      Navigate().gotoHome(context);
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const <Widget>[
              //         Padding(
              //           padding: EdgeInsets.only(top: 10.0),
              //         ),
              //         // CircleAvatar(
              //         //   backgroundColor: Colors.white,
              //         //   radius: 75.0,
              //         //   child: new Image.asset(
              //         //     'assets/images.jpg',
              //         //     scale: 2.1,
              //         //   ),
              //         // ),
              //         Padding(
              //           padding: EdgeInsets.only(top: 10.0),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    // Text(
                    //   "Pelaporan Bencana",
                    //   softWrap: true,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 18.0,
                    //       color: Colors.white),
                    // ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
