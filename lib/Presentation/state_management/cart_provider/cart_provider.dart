import 'package:Toogle/Presentation/state_management/cart_provider/cart_state.dart';
import 'package:Toogle/Presentation/state_management/contact_provider/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<String> itemClientId = [];
  List<String> itemId = [];
  List<String> itemName = [];
  List<String> itemPrice = [];
  List<String> itemImage = [];
  List<String> itemWeightKilos = [];
  List<String> itemWeightGrams = [];
  List<String> itemQuantity = [];
  List<String> itemRemarks = [];
  List<String> itemStatus = [];
  SharedPreferences prefs;
  List<String> cartContents;
  bool itemAlreadyExists = false;
  double totalSum = 0.0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  var userId;
  bool isLoggedIn = false;
  String shopID = "";
  String visitedShopID = "";
  String creditCards = "";
  String paypal = "";
  final controllerName = TextEditingController();
  final controllerLocation = TextEditingController();
  final controllerPhone = TextEditingController();

  CartState _state;
  CartState get state => _state;

  void changeState(CartState cartState) {
    _state = cartState;
    notifyListeners();
  }
}
