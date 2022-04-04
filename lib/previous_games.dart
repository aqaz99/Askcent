import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';

class PreviousGamesScreen extends StatelessWidget {
  const PreviousGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Previous Games')),
      drawer: const AskcentDrawer(),
      body: const Center(
        child: Text(
          'Previous Game screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
