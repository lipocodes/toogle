import 'package:Toogle/Presentation/pages/cart.dart';
import 'package:Toogle/Presentation/pages/contact.dart';
import 'package:Toogle/Presentation/pages/create_edit_shop.dart';
import 'package:Toogle/Presentation/pages/delivery.dart';
import 'package:Toogle/Presentation/pages/history.dart';
import 'package:Toogle/Presentation/pages/item_details.dart';
import 'package:Toogle/Presentation/pages/myHomePage.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments as Map;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/contact':
        return MaterialPageRoute(
          builder: (_) => Contact(),
        );
      case '/delivery':
        if (args["acctEmail"] is String) {
          //the arguments passed to ShopDelivery is a String
          return MaterialPageRoute(
            builder: (_) => ShopDelivery(
              acctEmail: args["acctEmail"],
            ),
          );
        }
        return _errorRoute();
      case '/createEditShop':
        if (args["acctEmail"] is String && args["acctUserID"] is String) {
          return MaterialPageRoute(
            builder: (_) => CreateEditShop(
              acctEmail: args["acctEmail"],
              acctUserID: args["acctUserID"],
            ),
          );
        }
        return _errorRoute();
      case '/shopHistory':
        return MaterialPageRoute(
          builder: (_) => ShopHistory(),
        );
      case '/itemDetail':
        if (args["itemId"] is String &&
            args["itemImage"] is String &&
            args['itemName'] is String &&
            args['itemPrice'] is String &&
            args['itemRating'] is String &&
            args['itemImages'] is List<dynamic> &&
            args['itemDescription'] is String &&
            args['itemSize'] is String &&
            args['itemColor'] is String &&
            args['itemWeightKilos'] is String &&
            args['itemWeightGrams'] is String) {
          return MaterialPageRoute(
            builder: (_) => ItemDetail(
                itemId: args['itemId'],
                itemImage: args['itemImage'],
                itemName: args['itemName'],
                itemPrice: args['itemPrice'],
                itemRating: args['itemRating'],
                itemImages: args['itemImages'],
                itemDescription: args['itemDescription'],
                itemSize: args['itemSize'],
                itemColor: args['itemColor'],
                itemWeightKilos: args['itemWeightKilos'],
                itemWeightGrams: args['itemWeightGrams']),
          );
        }
        return _errorRoute();
      case '/cart':
        if (args["itemId"] is String &&
            args['itemName'] is String &&
            args['itemByWeightPrice'] is String &&
            args['itemDescription'] is String &&
            args['itemDescription'] is String &&
            args['itemImage'] is String &&
            args['itemColor'] is String &&
            args['itemSize'] is String &&
            args['itemWeightKilos'] &&
            args['itemWeightGrams'] is String &&
            args['itemQuant'] is String &&
            args['itemRemarks'] is String &&
            args['itemRating']) {
          return MaterialPageRoute(
            builder: (_) => ShopCart(
              itemId: args['itemId'],
              itemName: args['itemName'],
              itemPrice: args['itemByWeightPrice'],
              itemDescription: args['itemDescription'],
              itemImage: args['itemImage'],
              itemColor: args['itemColor'],
              itemSize: args['itemSize'],
              itemWeightKilos: args['itemWeightKilos'],
              itemWeightGrams: args['itemWeightGrams'],
              itemQuant: args['itemQuant'],
              itemRemarks: args['itemRemarks'],
              itemRating: args['itemRating'],
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
