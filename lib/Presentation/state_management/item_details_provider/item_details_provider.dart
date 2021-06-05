import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/pages/cart.dart';
import 'package:Toogle/Presentation/state_management/contact_provider/contact_state.dart';
import 'package:Toogle/Presentation/state_management/item_details_provider/item_details_state.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailProvider extends ChangeNotifier {
  ItemDetailState _state;
  ItemDetailState get state => _state;

  String itemId;
  String itemName;
  String itemPrice;
  String itemImage;
  String itemRating;
  List<dynamic> itemImages;
  String itemDescription;
  String itemSize;
  String itemColor;
  String itemWeightKilos;
  String itemWeightGrams;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  int cartContentsSize = 0;
  bool isLoggedIn = false;
  String selectedWeightGrams = "-1";
  String selectedWeightKilos = "-1";
  List<DropdownMenuItem<String>> dropDownWeightGrams;
  List<DropdownMenuItem<String>> dropDownWeightKilos;
  String itemQuantity = "1";
  String itemByWeightPrice = "";
  String itemByQuantityPrice = "";
  List<String> categoryWeightGrams = [
    "0",
    "100",
    "200",
    "300",
    "400",
    "500",
    "600",
    "700",
    "800",
    "900"
  ];
  List<String> categoryWeightKilos = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  TextEditingController controllerRemarks = new TextEditingController();
  Size screenSize;

  void changeState(ItemDetailState itemDetailState) {
    _state = itemDetailState;
    notifyListeners();
  }

  ///Methods////////////////////////////////////////////////////////////////
  incrementQuantity() {
    int num = int.parse(this.itemQuantity);
    if (num < 10) num++;
    itemQuantity = num.toString();
    this.itemByQuantityPrice =
        (double.parse(this.itemQuantity) * double.parse(this.itemPrice))
            .toStringAsFixed(2);
    changeState(IncrementQuantity());
  }

  decrementQuantity() {
    int num = int.parse(itemQuantity);
    if (num > 1) num--;
    this.itemQuantity = num.toString();
    this.itemByQuantityPrice =
        (double.parse(this.itemQuantity) * double.parse(this.itemPrice))
            .toStringAsFixed(2);
    changeState(DecrementQuantity());
  }

  void changedDropDownWeightKilos(String argumentSelectedCategory) {
    if (argumentSelectedCategory == "0" && selectedWeightGrams == "0") {
      //showSnackBar("לא ייתכן משקל של 0 ק'ג ו 0 גרם", scaffoldKey);
      changeState(IllegalWeight());
    } else {
      selectedWeightKilos = argumentSelectedCategory;
      double weightInKilos = double.parse(selectedWeightKilos) +
          double.parse(selectedWeightGrams) / 1000;
      double itemPrice = double.parse(this.itemPrice);
      double price = weightInKilos * itemPrice;
      this.itemByWeightPrice = price.toStringAsFixed(2);
      changeState(ChangedDropDownWeightKilos());
    }
  }

  void changedDropDownWeightGrams(String argumentSelectedCategory) {
    if (argumentSelectedCategory == "0" && selectedWeightGrams == "0") {
      //showSnackBar("לא ייתכן משקל של 0 ק'ג ו 0 גרם", scaffoldKey);
      changeState(IllegalWeight());
    } else {
      selectedWeightGrams = argumentSelectedCategory;
      double weightInKilos = double.parse(selectedWeightKilos) +
          double.parse(selectedWeightGrams) / 1000;
      double itemPrice = double.parse(this.itemPrice);
      double price = weightInKilos * itemPrice;
      this.itemByWeightPrice = price.toStringAsFixed(2);
      changeState(ChangedDropDownWeightGrams());
    }
  }

  retrievePrefs() async {
    this.itemByQuantityPrice = this.itemPrice;
    prefs = await SharedPreferences.getInstance();
    this.cartContentsSize = prefs.getInt("cartCounter");
    this.isLoggedIn = await getBoolDataLocally(key: loggedIn);

    this.dropDownWeightKilos = buildAndGetDropDownItems(categoryWeightKilos);
    this.selectedWeightKilos = this.itemWeightKilos == "null"
        ? categoryWeightKilos[0]
        : this.itemWeightKilos;

    this.dropDownWeightGrams = buildAndGetDropDownItems(categoryWeightGrams);
    this.selectedWeightGrams = this.itemWeightGrams == "null"
        ? categoryWeightGrams[0]
        : this.itemWeightGrams;

    changeState(RetrievePrefs());
  }

//////End methods
}
