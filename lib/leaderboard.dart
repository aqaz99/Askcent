import 'package:flutter/material.dart';

// Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

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
        body: FutureBuilder(
            future: getCollection(),
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
                                Text(snapshot.data[index]['user_name']),
                                const Icon(
                                  Icons.emoji_events_rounded,
                                  color: Colors.greenAccent,
                                  size: 34.0,
                                ),
                                Text(snapshot.data[index]['score'].toString()),
                              ],
                            ),
                          );
                        }));
              }
            }));
  }

  Future<List<dynamic>?> getCollection() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var collection = FirebaseFirestore.instance.collection('user_data');

    try {
      QuerySnapshot snapshot = await collection.get();
      List<dynamic> result = snapshot.docs.map((doc) => doc.data()).toList();
      return result;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
