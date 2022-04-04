import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';

class UploadEntryScreen extends StatelessWidget {
  const UploadEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Askcent')),
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
