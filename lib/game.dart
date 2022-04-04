import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Askcent Game')),
      drawer: const AskcentDrawer(),
      body: const Center(
        child: Text(
          'Game screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
