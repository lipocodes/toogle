import 'package:flutter/material.dart';
import 'package:Toogle/Core/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:random_string/random_string.dart';

class Paypal extends StatefulWidget {
  String paypalPayment = "";

  Paypal(this.paypalPayment);

  @override
  _PaypalState createState() => _PaypalState();
}

class _PaypalState extends State<Paypal> {
  SharedPreferences prefs;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String paypal = "";
  List<String> cartContents;
  List<String> itemNames = [];
  List<String> amounts = [];
  List<String> quantities = [];
  List<String> remarks = [];
  int timeNow = 0;
  List<String> itemClientId = [];
  List<String> itemId = [];
  List<String> itemName = [];
  List<String> itemQuantity = [];
  List<String> itemRemarks = [];
  List<String> itemPrice = [];
  List<String> itemStatus = [];
  List<String> itemWeightKilos = [];
  List<String> itemWeightGrams = [];

  //Widget section ////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
  Widget customAppBar() {
    return AppBar(
      title: new Text(
        "פייפאל",
      ),
      centerTitle: false,
    );
  }

  Widget customBody(String params) {
    return WebView(
      initialUrl: "https://shopping-il.com/paypalPayment.php?" + params,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        //_controller.complete(webViewController);
        var url = await webViewController.currentUrl();
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) async {
        if (url.contains("checkout/done")) {
          timeNow = new DateTime.now().microsecondsSinceEpoch;
          for (int i = 0; i < this.cartContents.length; i++) {
            List<String> list = this.cartContents[i].split("^^^");

            this.itemClientId.add(list[0]);
            this.itemId.add(list[1]);
            this.itemName.add(list[2]);
            this.itemPrice.add(list[3]);
            this.itemQuantity.add(list[4]);
            this.itemRemarks.add(list[5]);
            //this.itemStatus.add(list[6]);
            this.itemWeightKilos.add(list[8]);
            this.itemWeightGrams.add(list[9]);
          }

          String fullName = prefs.getString("fullName");
          String location = prefs.getString("location");
          String phone = prefs.getString("phone");
          FirebaseMethods firebaseMethods = new FirebaseMethods();

          String orderID = randomBetween(100000, 200000).toString();
          await firebaseMethods.addNewGuestOrder(
            "Paypal",
            orderID,
            itemClientId,
            fullName,
            location,
            phone,
            itemId,
            itemName,
            itemQuantity,
            itemRemarks,
            itemPrice,
            itemStatus,
            itemWeightKilos,
            itemWeightGrams,
          );

          prefs.setStringList('cartContents', []);
          prefs.setInt("cartCounter", 0);
        }
      },
    );
  }

  //Method section ///////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this.itemNames.length == 0) {
      retrieveCartContent();
      return Container();
    } else {
      String param1 = "sellerAccount=" + this.paypal;

      String param2 = "&item_names=" +
          this
              .itemNames
              .toString()
              .substring(1)
              .substring(0, this.itemNames.toString().length - 2);
      String param3 = "&amounts=" +
          this
              .amounts
              .toString()
              .substring(1)
              .substring(0, this.amounts.toString().length - 2);
      String param4 = "&quantities=" +
          this
              .quantities
              .toString()
              .substring(1)
              .substring(0, this.quantities.toString().length - 2);

      String param5 = "&remarks=" +
          this
              .remarks
              .toString()
              .substring(1)
              .substring(0, this.remarks.toString().length - 2);

      String params = param1 + param2 + param3 + param4 + param5;

      return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(appBar: customAppBar(), body: customBody(params)));
    }
  }

  retrieveCartContent() async {
    prefs = await SharedPreferences.getInstance();
    this.paypal = prefs.getString("paypal");
    this.cartContents = prefs.getStringList("cartContents");

    for (int i = 0; i < this.cartContents.length; i++) {
      List<String> temp = this.cartContents[i].split("^^^");
      this.itemNames.add(temp[2]);
      this.amounts.add(temp[3]);
      this.quantities.add(temp[4]);
      this.remarks.add(temp[5]);
    }
    setState(() {});
  }
}
