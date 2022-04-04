import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          "Global Leaderboard",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
