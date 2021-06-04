import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Data/repositories_impl.dart';
import 'package:Toogle/Presentation/state_management/shopHistory_provider.dart/shopHistory_state.dart';
import 'package:Toogle/Presentation/state_management/user_provider/user_state.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Toogle/Domain/entities/orderHistory_details.dart';

class ShopHistoryProvider extends ChangeNotifier {
  FirebaseMethods appMethod = new FirebaseMethods();
  List<String> shopsOrders;
  String shopID = "";
  String localOrderID = "";
  String dateOrder = "";
  String statusOrder = "";
  List<List<String>> shopDetails = [];
  List<List<String>> orderDetails = [];
  List<String> listOrderDetails = [];
  List<String> list = [];
  List<String> orderID = [];
  List<String> selectedStatus = [];
  List<String> paymentMethods = [];
  List<String> dateOrders = [];
  ScrollController scrollController = new ScrollController();
  SharedPreferences prefs;
  ShopHistoryState _state; //an object of one of the possible states
  bool retrieveOrderHistoryYet;

  ShopHistoryState get state =>
      _state; //a class can access _state only by a getter

  void changeState(ShopHistoryState newFactState) {
    _state = newFactState;
    notifyListeners(); //make all the Widgets which listen to this Provider know about the new state.
  }

  Future retrieveShopsOrders() async {
    prefs = await SharedPreferences.getInstance();
    String clientPhone = prefs.getString("clientPhone");
    Either<ServerException, List<String>> failOrFact =
        await RepositoryImpl().retrieveShopsOrders(clientPhone);

    failOrFact.fold(
      (exception) {
        // if an exception was handled, just return error message
        _state = OrderDetailsError();
        notifyListeners();
      },
      (orderList) {
        print("aaaaaaaaaaaaaaaa= " + orderList.toString());
        /*OrderHistoryDetails orderHistoryDetails =
            OrderHistoryDetails.fromJson(orderList);
        // if a Fact object was returned, make a new state based on it
        _state = OrderDetailsRetrieved(orderList: orderList);*/
        notifyListeners();
      },
    );

    int len = this.shopsOrders == null ? 0 : this.shopsOrders.length;

    /*this.shopDetails = [];
    this.orderDetails = [];

    //going over the orderID^^^shopID list and creating list of the shopID & orderID
    for (int i = 0; i < len; i++) {
      List tempList = shopsOrders[i].split("^^^");

      this.shopID = tempList[0];
      this.shopID = this.shopID.replaceAll(' ', '');
      String localOrderID = tempList[1];
      this.orderID.add(localOrderID);

      this.dateOrders.add(tempList[2]);
      this.selectedStatus.add(tempList[3]);

      this.paymentMethods.add(tempList[4]);

      this.list = await appMethod.retrieveShopDetails(this.shopID);

      this.shopDetails.add(this.list);
      List<String> response =
          await appMethod.retreiveOrderDetails(this.shopID, localOrderID);
     
      this.orderDetails.add(response);
    }

    return this.orderDetails;*/
  }

  getOrderDetails(int index, int i, int neededDatum) {
    String str = this.orderDetails[index][i].toString();

    List<String> list = str.split("^^^");

    return list[neededDatum];
  }

  removeOrder(int index) async {
    /*displayProgressDialog(context);
    await appMethod.removeOrder(index).then((value) {
      closeProgressDialog(context);
      retrieveOrders();
    });*/
  }
}
