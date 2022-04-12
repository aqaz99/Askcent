import 'package:askcent/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Askcent',
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: const Color.fromARGB(255, 19, 149, 178)),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        drawer: const AskcentDrawer(),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Primary & Secondary Title Text
              Row(
                children: <Widget>[
                  // The long text inside this column overflows. Remove the row and column above this comment and the text wraps.
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6.0),
                            ),
                          ],
                        ),
                        const Text(
                          "Askcent",
                          style: TextStyle(
                              // backgroundColor: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                            ),
                          ],
                        ),
                        const Text(
                          "Test your skills at recognizing accents!",
                          style: TextStyle(
                              // backgroundColor: Colors.white,
                              fontSize: 32,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(100.0),
                  ),
                ],
              ),
              // Play row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.record_voice_over,
                    color: Colors.greenAccent,
                    size: 34.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  // Button example used as a template from here:
                  // https://stackoverflow.com/questions/54828454/how-to-set-rounded-border-to-a-materialbutton-on-flutter
                  Material(
                    //Wrap with Material
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    elevation: 18.0,
                    color: Color.fromARGB(255, 18, 165, 38),
                    clipBehavior: Clip.antiAliasWithSaveLayer, // Add This
                    child: MaterialButton(
                      minWidth: 240.0,
                      height: 50,
                      color: Color.fromARGB(255, 21, 185, 43),
                      child: const Text('Play Askcent!',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                      onPressed: () {},
                    ),
                  ),
                  const Icon(
                    Icons.location_searching_sharp,
                    color: Colors.greenAccent,
                    size: 34.0,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
