import 'package:Toogle/tools/app_data.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/app_localizations.dart';
import 'creditCards.dart';
import 'paypal.dart';
import 'package:random_string/random_string.dart';

class ShopCart extends StatefulWidget {
  String itemId;
  String itemName;
  String itemPrice;
  int itemQuantity;
  String itemDescription;
  String itemImage;
  String itemColor;
  String itemSize;
  String itemRating;
  String itemWeightKilos;
  String itemWeightGrams;
  String itemQuant;
  String itemRemarks;
  String itemByWeight;

  ShopCart(
      {this.itemId,
      this.itemName,
      this.itemPrice,
      this.itemDescription,
      this.itemImage,
      this.itemColor,
      this.itemSize,
      this.itemRating,
      this.itemWeightKilos,
      this.itemWeightGrams,
      this.itemQuant,
      this.itemRemarks,
      this.itemByWeight});

  @override
  _ShopCartState createState() => _ShopCartState();
}

class _ShopCartState extends State<ShopCart> {
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

  //pull what is in the shopping cart (preference) into a list
  void retrieveCartContents() async {
    //retrieve the existing preference of items in  the cart
    prefs = await SharedPreferences.getInstance();
    cartContents = prefs.getStringList("cartContents");

    this.userId = await getStringDataLocally(key: userID);
    this.shopID = await getStringDataLocally(key: "shopID");
    this.visitedShopID = await getStringDataLocally(key: "visitedShopID");

    FirebaseMethods firebaseMethods = new FirebaseMethods();
    List<String> shopDetails =
        await firebaseMethods.retrieveShopDetails(this.visitedShopID);

    this.creditCards = shopDetails[9];

    await prefs.setString("creditCards", this.creditCards);
    this.paypal = shopDetails[10];
    await prefs.setString("paypal", this.paypal);

    if (cartContents == null) cartContents = [];

    //making sure we are not adding an existing item
    for (int i = 0; i < cartContents.length; i++) {
      if (widget.itemId != null && cartContents[i].contains(widget.itemId))
        itemAlreadyExists = true;
    }

    //adding the new item (if exists) to the list holding the existing items in cart
    if (itemAlreadyExists == false &&
        widget.itemName != null &&
        widget.itemPrice != null &&
        widget.itemImage != null) {
      String newItem = this.userId +
          "^^^" +
          widget.itemId +
          "^^^" +
          widget.itemName +
          "^^^" +
          widget.itemPrice +
          "^^^" +
          widget.itemQuant.toString() +
          "^^^" +
          widget.itemRemarks +
          "^^^" +
          widget.itemImage +
          "^^^" +
          "בהמתנה לטיפול" +
          "^^^" +
          widget.itemWeightKilos +
          "^^^" +
          widget.itemWeightGrams;

      cartContents.add(newItem);

      prefs.setInt("cartCounter", cartContents.length);
      setState(() {});
    }

    setState(() {
      for (int i = 0; i < cartContents.length; i++) {
        String str = cartContents[i];
        var arr = str.split('^^^');

        if (arr.length == 10) {
          itemClientId.add(arr[0]);
          itemId.add(arr[1]);
          itemName.add(arr[2]);
          itemPrice.add(arr[3]);
          itemQuantity.add(arr[4]);
          itemRemarks.add(arr[5]);
          itemImage.add(arr[6]);
          itemStatus.add(arr[7]);
          itemWeightKilos.add(arr[8]);
          itemWeightGrams.add(arr[9]);
        }
      }
    });

    calculateSum();

    //need to store again the preference
    prefs.setStringList('cartContents', cartContents);
  }

  Future<void> removeItem(int index) async {
    setState(() {
      itemClientId.removeAt(index);
      itemId.removeAt(index);
      itemName.removeAt(index);
      itemWeightKilos.removeAt(index);
      itemWeightGrams.removeAt(index);
      itemPrice.removeAt(index);
      itemImage.removeAt(index);
      itemQuantity.removeAt(index);
      itemRemarks.removeAt(index);
      itemStatus.removeAt(index);
      cartContents.removeAt(index);
      prefs.setStringList('cartContents', cartContents);
      prefs.setInt("cartCounter", cartContents.length);
      calculateSum();
    });
  }

  calculateSum() {
    this.totalSum = 0.0;
    for (int i = 0; i < itemQuantity.length; i++) {
      this.totalSum +=
          double.parse(itemQuantity[i]) * double.parse(itemPrice[i]);
    }
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              //title: new Text("Choose Payment Method"),
              content: Container(
                height: 180,
                child: Column(
                  children: [
                    Text("שם מלא"),
                    TextField(
                      textDirection: TextDirection.rtl,
                      onChanged: (value) {},
                      controller: controllerName,
                      // decoration: InputDecoration(hintText: "שם מלא"),
                    ),
                    SizedBox(height: 20),
                    Text("מיקום"),
                    TextField(
                      textDirection: TextDirection.rtl,
                      onChanged: (value) {},
                      controller: controllerLocation,
                      //decoration: InputDecoration(hintText: "מיקום"),
                    ),
                    SizedBox(height: 20),
                    Text("מספר טלפון"),
                    TextField(
                      textDirection: TextDirection.rtl,
                      onChanged: (value) {},
                      controller: controllerPhone,
                      //decoration: InputDecoration(hintText: "מספר טלפון"),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      FlatButton(
                        //color: Colors.orange,
                        child: /*Image.asset('images/paypal.png')*/ Text(
                            "טלפון",
                            style: TextStyle(fontSize: 24)),
                        onPressed: () async {
                          displayProgressDialog(context);
                          FirebaseMethods firebaseMethods =
                              new FirebaseMethods();
                          await firebaseMethods.createClientAccount(
                              controllerName.value.text,
                              controllerLocation.value.text,
                              controllerPhone.value.text);

                          prefs.setString(
                              "fullName", controllerName.value.text);
                          prefs.setString(
                              "location", controllerLocation.value.text);
                          prefs.setString("phone", controllerPhone.value.text);

                          List<String> itemClientId = this.itemClientId;
                          List<String> itemId = this.itemId;
                          List<String> itemName = this.itemName;
                          List<String> itemQuantity = this.itemQuantity;
                          List<String> itemRemarks = this.itemRemarks;
                          List<String> itemPrice = this.itemPrice;
                          List<String> itemStatus = this.itemStatus;
                          List<String> itemWeightKilos = this.itemWeightKilos;
                          List<String> itemWeightGrams = this.itemWeightGrams;

                          String orderID =
                              randomBetween(100000, 200000).toString();
                          await firebaseMethods.addNewGuestOrder(
                            "Phone",
                            orderID,
                            itemClientId,
                            controllerName.value.text,
                            controllerLocation.value.text,
                            controllerPhone.value.text,
                            itemId,
                            itemName,
                            itemQuantity,
                            itemRemarks,
                            itemPrice,
                            itemStatus,
                            itemWeightKilos,
                            itemWeightGrams,
                          );

                          closeProgressDialog(context);
                          showSnackBar("הזמנתך התקבלה", scaffoldKey);
                          prefs = await SharedPreferences.getInstance();
                          prefs.setStringList("cartContents", []);
                          prefs.setInt("cartCounter", 0);

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          setState(() {
                            this.itemName = [];
                          });
                        },
                      ),
                      this.paypal.length > 0
                          ? FlatButton(
                              //color: Colors.orange,
                              child: /*Image.asset('images/paypal.png')*/ Text(
                                  "פייפאל",
                                  style: TextStyle(fontSize: 24)),
                              onPressed: () async {
                                closeProgressDialog(context);
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Paypal(this.paypal)));

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            )
                          : Container(),
                      this.creditCards.length > 0
                          ? FlatButton(
                              child: /*Image.asset('images/creditCard.png')*/ Text(
                                  "כרטיס אשראי",
                                  style: TextStyle(fontSize: 24)),
                              onPressed: () async {
                                if (controllerName.value.text != "" &&
                                    controllerLocation.value.text != "" &&
                                    controllerPhone.value.text != "") {
                                  displayProgressDialog(context);
                                  FirebaseMethods firebaseMethods =
                                      new FirebaseMethods();
                                  await firebaseMethods.createClientAccount(
                                      controllerName.value.text,
                                      controllerLocation.value.text,
                                      controllerPhone.value.text);

                                  prefs.setString(
                                      "fullName", controllerName.value.text);
                                  prefs.setString("location",
                                      controllerLocation.value.text);
                                  prefs.setString(
                                      "phone", controllerPhone.value.text);
                                  closeProgressDialog(context);

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreditCards(this.creditCards)),
                                  );
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              },
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ));
  }

  onPressedContinue() async {
    //let the client decide which payment method to use: by phone, by Paypal, by credit card
    if (this.cartContents.length == 0) return;

    _showMaterialDialog();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveCartContents();
  }

  @override
  Widget build(BuildContext context) {
    /*if (this.paypal == null || this.creditCards == null) {
      return Container();
    }*/

    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: new Text(
            "עגלת קניות",
          ),
          centerTitle: false,
        ),
        body: new Column(
          children: [
            new Expanded(
                child: new ListView.builder(
                    itemCount: itemName.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey[500],
                          width: 8.0,
                        ))),
                        child: new Column(
                          children: [
                            new Row(
                              children: [
                                new SizedBox(width: 10.0),
                                new Image.network(itemImage[index],
                                    width: 100, height: 100),
                                new SizedBox(width: 30.0),
                                Expanded(
                                    child: new Text(
                                  itemName[index].length < 50
                                      ? itemName[index]
                                      : itemName[index].substring(0, 50),
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.grey[800]),
                                )),
                                GestureDetector(
                                  onTap: () {
                                    removeItem(index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: new Text(
                                      'מחיקה',
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          backgroundColor: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (itemWeightKilos[index] != '0' ||
                                itemWeightGrams[index] != '0') ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "משקל:" +
                                        "   " +
                                        itemWeightKilos[index] +
                                        " " +
                                        "ק'ג" +
                                        "  " +
                                        itemWeightGrams[index] +
                                        " " +
                                        "גרם" +
                                        " " +
                                        "     מחיר: " +
                                        this.itemPrice[index] +
                                        " " +
                                        "שקלים",
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Row(children: []),
                            ] else ...[
                              Row(
                                children: [
                                  Text(
                                      "מספר פריטים:" +
                                          " " +
                                          itemQuantity[index],
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      "מחיר: " +
                                          this.itemPrice[index] +
                                          " " +
                                          "שקלים",
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ],
                            SizedBox(height: 10),
                            Text(this.itemRemarks[index]),
                          ],
                        ),
                      );
                    })),
            SizedBox(height: 30.0),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "סכום לתשלום",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800]),
                  ),
                  Text(totalSum.toStringAsFixed(2) + " " + "ש'ח",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[800])),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    onPressed: onPressedContinue,
                    child: Text(
                      /*cartContinueButton*/ "לתשלום",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300),
                    ),
                    color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
