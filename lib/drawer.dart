// import 'package:assignment4/map_page.dart';
import 'package:flutter/material.dart';
// import 'package:assignment4/location.dart';
// import 'package:assignment4/add_topics.dart';
// import 'package:assignment4/add_speakers.dart';
import 'package:askcent/main.dart';

// Navigator.pop(context); // Close drawer
class askcentDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 186, 50, 228),
            ),
            child: Text('Screens'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              var route = ModalRoute.of(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const MyApp()));
            },
          ),
          ListTile(
            title: const Text('Play Askcent'),
            // onTap: () {
            //   var route = ModalRoute.of(context);
            //   Navigator.of(context)
            //       .push(MaterialPageRoute(builder: (context) => AddSpeakers()));
            // },
          ),
          ListTile(
            title: const Text('Previous Games'),
            // onTap: () {
            //   var route = ModalRoute.of(context);
            //   Navigator.of(context)
            //       .push(MaterialPageRoute(builder: (context) => AddTopics()));
            // },
          ),
          ListTile(
            title: const Text('Upload An Entry'),
            // onTap: () {
            //   var route = ModalRoute.of(context);
            //   Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) => LocationPage()));
            // },
          ),
          Divider(),
          ListTile(
            title: const Text('Settings'),
            // onTap: () {
            //   var route = ModalRoute.of(context);
            //   Navigator.of(context)
            //       .push(MaterialPageRoute(builder: (context) => MapPage()));
            // },
          ),
          ListTile(
            title: const Text('Send Feeback'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
