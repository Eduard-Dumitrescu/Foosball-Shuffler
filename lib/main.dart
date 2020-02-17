import 'package:ciocio_team_generator/home_page.dart';
import 'package:ciocio_team_generator/players_page.dart';
import 'package:ciocio_team_generator/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  //force portrait only mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        //brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.purple,
        unselectedWidgetColor: Colors.yellowAccent,
        toggleableActiveColor: Colors.yellowAccent,
        dividerColor: Colors.amber,
        //primarySwatch: Colors.deepPurple,

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      routes: {
        '/': (context) => KeyboardDragDownDismiss(
              child: HomePage(
                title: 'Team Generator',
              ),
            ),
        '/players': (context) => KeyboardDragDownDismiss(child: PlayersPage()),
      },
    );
  }
}

class KeyboardDragDownDismiss extends StatelessWidget {
  final Widget child;

  KeyboardDragDownDismiss({this.child});

  @override
  Widget build(BuildContext context) {
    return this.child == null
        ? Container()
        : GestureDetector(
            onPanUpdate: (details) {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (details.delta.dy > 0) {
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }
            },
            child: this.child);
  }
}
