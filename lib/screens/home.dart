import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  // Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 5.0;
  double lat = 0, long = 0;
  double indoLat = -6.200000, indoLong = 106.816666;
  String location = '';

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.229728, 106.6894312),
    zoom: 14.4746,
  );

  getLoc() async {
    // Get Location
    Position position = await Geolocation.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      location = addresses.first.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  static const CameraPosition _kLake = CameraPosition(
      target: LatLng(-6.229728, 106.6894312), bearing: 192, tilt: 59, zoom: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
        zoomGesturesEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Attendence'),
        icon: const Icon(Icons.edit_calendar_outlined),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
