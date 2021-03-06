import 'package:flutter/material.dart';
import 'package:askcent/upload_entry.dart';
import 'package:askcent/previous_games.dart';
import 'package:askcent/game.dart';
import 'package:askcent/leaderboard.dart';

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
              color: Colors.green,
            ),
            child: Text('Screens'),
          ),
          ListTile(
            title: const Text('Play Askcent'),
            onTap: () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GameScreen()));
            },
          ),
          ListTile(
            title: const Text('Previous Games'),
            onTap: () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PreviousGamesScreen()));
            },
          ),
          ListTile(
            title: const Text('Upload An Entry'),
            onTap: () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UploadEntryScreen()));
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            title: const Text('Leaderboards'),
            onTap: () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen()));
            },
          )
        ],
      ),
    );
  }
}
