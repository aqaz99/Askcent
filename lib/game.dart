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
  // GameScreenState() {
  //   initializeDefault();
  // }

  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _currentMarkers = [];
  late Marker _markerGuess;
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
          'Play Askcent!',
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
              print("Hello from gradient");

              final _random = new Random();

              var random_user =
                  list_of_users[_random.nextInt(list_of_users.length)];
              writeAskcent(random_user);
            },
            child: const Text('Submit Guess!'),
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
        label: const Text('Play Voice Clip'),
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
    print("User is making guess..");
    setState(() {
      _currentMarkers.add(Marker(
          markerId: const MarkerId("My Guess"),
          draggable: true,
          visible: true,
          onTap: () {
            print("Tapped me");
          },
          infoWindow:
              const InfoWindow(title: 'Your current guess', snippet: "Ahoy"),
          position: position));
    });
  }

  Future<bool> writeAskcent(String user_name) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference ref = firestore.collection('user_data').doc(user_name);

    ref
        .set({
          'user_name': user_name,
          'latitude': 0,
          'longitude': 1,
        }, SetOptions(merge: true))
        .then((value) => print("Askcent added $user_name"))
        .catchError((error) => print("Failed to update askcent: $error"));
    // firestore
    //     .collection('user_data')
    //     .doc('askcents')
    //     .collection('test')
    //     .add({
    //       'user_name': user_name,
    //       'latitude': 0,
    //       'longitude': 1,
    //     })
    //     .then((value) => print("Askcent added"))
    //     .catchError((error) => print("Failed to update askcent: $error"));
    return true;
  }
}
