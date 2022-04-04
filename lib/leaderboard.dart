import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard Screen')),
      drawer: const AskcentDrawer(),
      body: const Center(
        child: Text(
          'Global Leaderboards',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
