import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const AskcentDrawer(),
      body: const Center(
        child: Text(
          'Settings Screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
