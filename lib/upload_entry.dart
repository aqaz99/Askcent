import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:askcent/firebase_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Add random user to database
import "dart:math";

// Play sound
import 'package:audioplayers/audioplayers.dart';

// Firestore
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // What we are requesting access to for the app
  scopes: <String>[
    'email',
    'profile',
  ],
);

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
  GoogleSignInAccount? _currentUser;
  // Firebase
  bool _initialized = false;
  Future<void> initializeDefault() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseConfig.platformOptions);
    _initialized = true;
  }

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
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
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
              writeAskcent(_currentUser?.displayName);
            },
            child: const Text('Submit Askcent!'),
          ),
        ],
      ),
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
        label: const Text('Press to record your audio'),
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
    // readAskcent();
    setState(() {
      _currentMarkers.add(Marker(
          markerId: const MarkerId("User Askcent Location"),
          draggable: true,
          visible: true,
          onTap: () {
            // print("Tapped me");
          },
          infoWindow: const InfoWindow(title: 'Your Askcent Location'),
          position: position));
    });
  }

  Future<bool> writeAskcent(String? userName) async {
    if (current_marker_latlong == null) {
      return false;
    } else {
      // print(current_marker_latlong);
      if (!_initialized) {
        await initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference ref = firestore.collection('user_data').doc(userName);
      if (userName != null) {
        ref
            .set({
              'user_name': userName,
              'latitude': current_marker_latlong?.latitude,
              'longitude': current_marker_latlong?.longitude,
              'score': 0,
            }, SetOptions(merge: true))
            .then((value) => print("Askcent added $userName"))
            .catchError((error) => print("Failed to update askcent: $error"));
        return true;
      } else {
        print("Couldn't add Askcent for user, no username found");
        return false;
      }
    }
  }

  Future<bool> readAskcent() async {
    // print(current_marker_latlong);
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var collection = FirebaseFirestore.instance.collection('user_data');
    var all_user_info = await getCollection(collection);

    // generates a new Random object
    final _random = new Random();

    // generate a random index based on the list length
    // and use it to retrieve the element
    var element = all_user_info![_random.nextInt(all_user_info.length)];

    return true;
  }

  Future<List<dynamic>?> getCollection(CollectionReference collection) async {
    try {
      QuerySnapshot snapshot = await collection.get();
      List<dynamic> result = snapshot.docs.map((doc) => doc.data()).toList();
      return result;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
