import 'package:ciocio_team_generator/ui/contact_page.dart';
import 'package:ciocio_team_generator/ui/home_page.dart';
import 'package:ciocio_team_generator/ui/players_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  if (Device.get().isTablet) {
    runApp(new MyApp());
  } else {
    //force portrait only mode
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(new MyApp());
    });
  }
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
        splashColor: Colors.deepOrangeAccent,
        //primarySwatch: Colors.deepPurple,

        // Define the default font family.
        fontFamily: GoogleFonts.fredokaOne().fontFamily,

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          subhead: TextStyle(color: Colors.yellowAccent),
          button: TextStyle(color: Colors.yellowAccent),
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.italic,
              color: Colors.yellowAccent),
          body1: GoogleFonts.fredokaOne(
            textStyle: TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
          ),
        ),
      ),
      initialRoute: '/',
      //onGenerateRoute: RouteGenerator.generateRoute,
      routes: {
        '/': (context) => KeyboardDragDownDismiss(
              child: HomePage(
                title: 'Team Generator',
              ),
            ),
        '/players': (context) => KeyboardDragDownDismiss(child: PlayersPage()),
        '/contact': (context) => ContactPage(),
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
