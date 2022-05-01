import 'package:flutter/material.dart';
import 'package:askcent/drawer.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);
  static List<String> list_of_users = [
    "Tom",
    "Bob",
    "Jess",
    "Earl",
    "Pat",
    "Cat",
    "Marge",
    "Harry",
    "Patrick",
    "Jane",
    "Teresa"
  ];
  static List<String> list_of_items = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11"
  ];
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
        body: ListView.builder(
            itemCount: list_of_items.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(6.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.greenAccent,
                      size: 34.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Text(list_of_users[index]),
                    const Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.greenAccent,
                      size: 34.0,
                    ),
                    Text(list_of_items[index]),
                  ],
                ),
              );
            }));
  }
}
