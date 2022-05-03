import 'package:askcent/drawer.dart';
import 'package:flutter/material.dart';
import 'package:askcent/game.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // What we are requesting access to for the app
  scopes: <String>[
    'email',
    'profile',
  ],
);

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
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  // Taken from Dixon's exampls Mar 28 video
  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

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
                              color: Colors.white),
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
                              color: Colors.white),
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
                      onPressed: () {
                        var route = ModalRoute.of(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const GameScreen()));
                      },
                    ),
                  ),
                  const Icon(
                    Icons.location_searching_sharp,
                    color: Colors.greenAccent,
                    size: 34.0,
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/images/globe_pin.png"),
                    width: 300,
                    fit: BoxFit.fitWidth,
                  )
                ],
              ),
              Row(
                children: [_buildBody()],
              )
            ],
          ),
        ));
  }
}
