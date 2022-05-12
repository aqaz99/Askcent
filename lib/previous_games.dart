import 'package:askcent/main.dart';
import 'package:flutter/material.dart';

// Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// Google
import 'package:google_sign_in/google_sign_in.dart';

class PreviousGamesScreen extends StatelessWidget {
  PreviousGamesScreen({Key? key}) : super(key: key);
  final GoogleSignInAccount? _currentUser = MyApp.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text(
            "Previous Games",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: FutureBuilder(
            future: getCollection(_currentUser?.displayName),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.greenAccent,
                                  size: 34.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                                Text(snapshot.data[index]
                                    .toString()
                                    .split("||")[0]),
                                const Icon(
                                  Icons.emoji_events_rounded,
                                  color: Colors.greenAccent,
                                  size: 34.0,
                                ),
                                Text(snapshot.data[index]
                                    .toString()
                                    .split("||")[1]),
                              ],
                            ),
                          );
                        }));
              }
            }));
  }

  Future<List<dynamic>?> getCollection(String? userName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var collection = firestore.collection('previous_games');

    try {
      var snapshot = await collection.doc(userName).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        print(data);
        print("Length: ");
        print(data.length);
        List<String> results = [];
        for (var i = 0; i < data.length; i++) {
          results.add("${data.keys.elementAt(i)}||${data.values.elementAt(i)}");
        }
        //     data.entries.map((value) => value.value).toList();
        // List<dynamic> result = [];
        // data.forEach((k, v) => result.add(v));
        return (results);
      }
    } catch (error) {
      print(error);
      return null;
    }
  }
}
