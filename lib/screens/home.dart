import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  // Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late double longd, latd;
  late StreamSubscription<Position> positionStream;
  // Set<Marker> _markers = {};
  // Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    checkGps();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              print('click master data');
            }, 
            icon: const Icon(Icons.menu),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'e-Attendance', 
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              GestureDetector(
                onTap: () {
                  // print('tap');
                  _onBottomPressed();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.amber[800],
                  radius: 40,
                  child: const Icon(
                    Icons.checklist,
                    size: 30,
                    color: Colors.white
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              const Text(
                'Check in', 
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 35)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    'Check in', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    'Check out', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                ],
              )
            ],
          ),
        ]
      ),
    );
  }

  void _onBottomPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black54,
          height: 700,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'Your Location',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latd, longd),
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      markers: <Marker>{
                        Marker(
                          markerId: MarkerId('MyLoc'),
                          position: LatLng(latd, longd),
                          icon: BitmapDescriptor.defaultMarker
                        ),
                      },
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: MaterialButton(
                    color: Colors.amber[800],
                    onPressed: () {
                      // print('check in done');
                      saveData();
                    },
                    child: const Text(
                      'Check In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      }
    );
  }

  checkGps() async {
      servicestatus = await Geolocator.isLocationServiceEnabled();
      if(servicestatus){
        permission = await Geolocator.checkPermission();
      
        if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
                print('Location permissions are denied');
            }else if(permission == LocationPermission.deniedForever){
                print("'Location permissions are permanently denied");
            }else{
                haspermission = true;
            }
        }else{
            haspermission = true;
        }

        if(haspermission){
            setState(() {
              //refresh the UI
            });

            getLocation();
        }
      }else{
        print("GPS Service is not enabled, turn on GPS location");
      }

      setState(() {
         //refresh the UI
      });
  }

  getLocation() async {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();
      longd = position.longitude;
      latd = position.latitude;

      setState(() {
         //refresh UI
      });

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, //accuracy of the location data
        distanceFilter: 100, //minimum distance (measured in meters) a 
        //device must move horizontally before an update event is generated;
      );

      StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
            locationSettings: locationSettings).listen((Position position) {
            print(position.longitude); //Output: 80.24599079
            print(position.latitude); //Output: 29.6593457

            long = position.longitude.toString();
            lat = position.latitude.toString();

            setState(() {
              //refresh UI on update
            });
      });
  }

  saveData() async {
    var dataLoc = {
      'lat': latd,
      'long': longd,
      'checkin': DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      'checkout': '',
    };
    print(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
    print(jsonEncode(dataLoc));

    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(key, value)

  }


}
