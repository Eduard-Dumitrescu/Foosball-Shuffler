import 'package:ciocio_team_generator/ui/home_page.dart';
import 'package:ciocio_team_generator/ui/players_page.dart';
import 'package:flutter/material.dart';

// will maybe use later
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    // hack to cache pages and not make keyboard rebuild them
    final HomePage _homePage = HomePage();
    const PlayersPage _playersPage = PlayersPage();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => _homePage);
      case '/players':
        return MaterialPageRoute(
          builder: (_) => _playersPage,
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
