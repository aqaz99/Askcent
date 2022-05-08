import 'package:flutter/material.dart';
import 'dart:async';
import 'package:askcent/drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:askcent/firebase_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Play sound
import 'package:audioplayers/audioplayers.dart';

// Firestore
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Get random user
import "dart:math";

GoogleSignIn _googleSignIn = GoogleSignIn(
  // What we are requesting access to for the app
  scopes: <String>[
    'email',
    'profile',
  ],
);

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);
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
  State<MapSample> createState() => GameScreenState();
}

class GameScreenState extends State<MapSample> {
  // Google user stuff
  GoogleSignInAccount? _currentUser;

  // Firebase
  bool _initialized = false;
  late Map<String, dynamic> _randomAskcent;

  Future<void> initializeDefault() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseConfig.platformOptions);
    _initialized = true;
    _randomAskcent = await getRandomAskcent();
  }

  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _currentMarkers = [];
  late Marker _markerGuess;

  // Poly line info and init
  Set<Polyline> _polylines = <Polyline>{};

  final player = new AudioCache(fixedPlayer: AudioPlayer());

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late Future<Position> myPos;
  String myLocation = "";

  @override
  void initState() {
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
              // Supply
              _drawGuessMarkerAndLine(_currentMarkers[0].position);
              double straightLineDistance = calculateDistance(
                  _currentMarkers[0].position.latitude,
                  _currentMarkers[0].position.longitude,
                  _randomAskcent['latitude'],
                  _randomAskcent['longitude']);
              addScoreToUser(_currentUser?.displayName, straightLineDistance);
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Nice Guess!"),
                        content: Text(
                            "Wow! Your guess was ${straightLineDistance.toStringAsFixed(2)} miles from the actual location!"),
                      ));
            },
            child: const Text('Submit Guess!'),
          ),
        ],
      ),
      drawer: const AskcentDrawer(),
      body: GoogleMap(
          polylines: _polylines,
          mapType: MapType.hybrid,
          markers: Set.from(_currentMarkers),
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (latLng) {
            setState(() {
              print('${latLng.latitude}, ${latLng.longitude}');
              _addMarker(latLng, "Guess");
            });
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _playVoice,
        label: Text('Play Users Askcent'),
        icon: const Icon(Icons.volume_up_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  Future<void> _playVoice() async {
    player.fixedPlayer!.stop();
    player.play('sounds/tts_output.wav');
  }

  void _addMarker(LatLng position, String markerId) {
    print("User is making guess.. ");
    double descriptorHue = 35;

    // If its a guess, change marker hue to red, then clear markers list
    if (markerId == "Guess") {
      descriptorHue = 0;
      _currentMarkers.clear();
    }
    setState(() {
      if (_currentMarkers.length > 1) {
        _currentMarkers.removeAt(1);
      }

      _currentMarkers.add(Marker(
          markerId: MarkerId(markerId),
          icon: BitmapDescriptor.defaultMarkerWithHue(descriptorHue),
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

  void _drawGuessMarkerAndLine(LatLng guessPosition) async {
    List<LatLng> latlng = [];
    setState(() {
      // Add marker
      _addMarker(
          LatLng(_randomAskcent['latitude'], _randomAskcent['longitude']),
          _randomAskcent['user_name']);

      // Add markers to poly line list
      LatLng _guessMarker = LatLng(_currentMarkers[0].position.latitude,
          _currentMarkers[0].position.longitude);

      LatLng _answerMarker =
          LatLng(_randomAskcent['latitude'], _randomAskcent['longitude']);

      latlng.add(_guessMarker);
      latlng.add(_answerMarker);

      Polyline _newLine = Polyline(
        width: 5,
        polylineId: PolylineId("Askcent_line"),
        visible: true,
        //latlng is List<LatLng>
        points: latlng,
        color: Colors.red,
      );
      _polylines.clear();
      _polylines.add(_newLine);
    });
    // Get random askcent
    _randomAskcent = await getRandomAskcent();
  }

  Future<Map<String, dynamic>> getRandomAskcent() async {
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
    Map<String, dynamic> element =
        all_user_info![_random.nextInt(all_user_info.length)];
    return element;
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

  // Used from https://www.fluttercampus.com/guide/248/calculate-distance-between-location-google-map-flutter/
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void addScoreToUser(String? userName, double distance) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Simple score,
    double score = 10000 - distance;
    DocumentReference ref = firestore.collection('user_data').doc(userName);
    print("ref is:");
    print(ref);
    print("User is:");
    print(userName);
    ref
        .update({
          'score': FieldValue.increment(score.abs().round()),
        })
        .then((value) => print("Askcent added $userName"))
        .catchError((error) => print("Failed to update askcent: $error"));
  }
}
