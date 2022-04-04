import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';

class UploadEntryScreen extends StatelessWidget {
  const UploadEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          "Upload Askcent",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const AskcentDrawer(),
      body: const Center(
        child: Text(
          'Upload An Askcent Entry',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
