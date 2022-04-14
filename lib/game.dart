import 'package:flutter/material.dart';
import 'dart:async';
import 'package:askcent/drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MapSample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => GameScreenState();
}

class GameScreenState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _currentMarkers = [];
  late Marker _markerGuess;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late Future<Position> myPos;
  String myLocation = "";
  @override
  void initState() {
    super.initState();
    _currentMarkers.add(_markerGuess = Marker(
        markerId: const MarkerId("Marker 1"),
        draggable: false,
        onTap: () {
          print("Tapped me");
        },
        infoWindow: InfoWindow(title: 'The title of the marker'),
        position: const LatLng(37.42796133580664, -122.085749655962)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Play Askcent!',
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const AskcentDrawer(),
      body: GoogleMap(
          mapType: MapType.hybrid,
          markers: Set.from(_currentMarkers),
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (latLng) {
            setState(() {
              print('${latLng.latitude}, ${latLng.longitude}');
              _addMarker(latLng);
            });
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentPos,
        label: const Text('To Current Location!'),
        icon: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  Future<void> _goToCurrentPos() async {
    Position p = await _determinePosition();
    CameraPosition _userPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(p.latitude, p.longitude),
        tilt: 30,
        zoom: 19);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_userPosition));
  }

  void _addMarker(LatLng position) {
    print("HELLO!!!");
    setState(() {
      _markerGuess = Marker(
          markerId: const MarkerId("Marker 1"),
          draggable: false,
          visible: true,
          onTap: () {
            print("Tapped me");
          },
          infoWindow: InfoWindow(title: 'The title of the marker'),
          position: position);
    });
  }
}
