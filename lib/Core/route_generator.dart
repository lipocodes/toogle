import 'package:Toogle/Presentation/pages/contact.dart';
import 'package:Toogle/Presentation/pages/delivery.dart';
import 'package:Toogle/Presentation/pages/myHomePage.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/contact':
        return MaterialPageRoute(
          builder: (_) => Contact(),
        );
      case '/delivery':
        if (args is String) {
          //the arguments passed to ShopDelivery is a String
          return MaterialPageRoute(
            builder: (_) => ShopDelivery(
              acctEmail: args,
            ),
          );
        }
        return _errorRoute();
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
