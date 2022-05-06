import 'package:flutter/material.dart';
import 'dart:async';
import 'package:askcent/drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:askcent/firebase_config.dart';

// Add random user to database
import "dart:math";

// Play sound
import 'package:audioplayers/audioplayers.dart';

// Firestore
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadEntryScreen extends StatelessWidget {
  const UploadEntryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Askcent Screen',
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
  State<MapSample> createState() => UploadScreenState();
}

class UploadScreenState extends State<MapSample> {
  // Firebase
  bool _initialized = false;
  Future<void> initializeDefault() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseConfig.platformOptions);
    _initialized = true;
  }

  static List<String> list_of_users = [
    "Tom",
    "Bob",
    "Jess",
    "Earl",
    "Pat",
    "Cat",
    "Marge",
    "Harry",
    "Patrick",
    "Jane",
    "Teresa"
  ];

  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _currentMarkers = [];
  LatLng? current_marker_latlong;

  final player = new AudioCache(fixedPlayer: AudioPlayer());

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late Future<Position> myPos;
  String myLocation = "";
  @override
  void initState() {
    // FlutterSound flutterSound = new FlutterSound();
    super.initState();
    initializeDefault();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Askcent!',
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            // Submit guess button
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              print("User uploaded askcent");

              final _random = new Random();

              var randomUser =
                  list_of_users[_random.nextInt(list_of_users.length)];
              writeAskcent(randomUser);
            },
            child: const Text('Submit Askcent!'),
          ),
        ],
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
        onPressed: _playVoice,
        label: const Text('Change me please'),
        icon: const Icon(Icons.volume_up_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  Future<void> _playVoice() async {
    player.fixedPlayer!.stop();
    player.play('sounds/tts_output.wav');
  }

  void _addMarker(LatLng position) {
    current_marker_latlong = position;
    print("User is making guess..");
    setState(() {
      _currentMarkers.add(Marker(
          markerId: const MarkerId("My Guess"),
          draggable: true,
          visible: true,
          onTap: () {
            print("Tapped me");
          },
          infoWindow: const InfoWindow(title: 'Your ASkcent Location'),
          position: position));
    });
  }

  Future<bool> writeAskcent(String userName) async {
    userName = "Pat";
    if (current_marker_latlong == null) {
      return false;
    } else {
      // print(current_marker_latlong);
      if (!_initialized) {
        await initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference ref = firestore.collection('user_data').doc(userName);

      ref
          .set({
            'user_name': userName,
            'latitude': current_marker_latlong?.latitude,
            'longitude': current_marker_latlong?.longitude,
          }, SetOptions(merge: true))
          .then((value) => print("Askcent added $userName"))
          .catchError((error) => print("Failed to update askcent: $error"));
      return true;
    }
  }
}
