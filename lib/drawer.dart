// import 'package:assignment4/map_page.dart';
import 'package:askcent/settings.dart';
import 'package:flutter/material.dart';
import 'package:askcent/upload_entry.dart';
import 'package:askcent/previous_games.dart';
import 'package:askcent/game.dart';
import 'package:askcent/leaderboard.dart';
import 'package:askcent/main.dart';

// Navigator.pop(context); // Close drawer
class AskcentDrawer extends StatelessWidget {
  const AskcentDrawer({Key? key}) : super(key: key);

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
            onTap: () {
              var route = ModalRoute.of(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const GameScreen()));
            },
          ),
          ListTile(
            title: const Text('Previous Games'),
            onTap: () {
              var route = ModalRoute.of(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PreviousGamesScreen()));
            },
          ),
          ListTile(
            title: const Text('Upload An Entry'),
            onTap: () {
              var route = ModalRoute.of(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UploadEntryScreen()));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Leaderboards'),
            onTap: () {
              var route = ModalRoute.of(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen()));
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              var route = ModalRoute.of(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
