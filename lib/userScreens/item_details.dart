import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Toogle/tools/app_tools.dart';
import 'cart.dart';
import 'package:Toogle/app_localizations.dart';
import 'images_in_large.dart';
import 'package:Toogle/tools/app_data.dart';
import 'package:Toogle/userScreens/loginlogout.dart';

class ItemDetail extends StatefulWidget {
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

  ItemDetail(
      {this.itemId,
      this.itemImage,
      this.itemName,
      this.itemPrice,
      this.itemRating,
      this.itemImages,
      this.itemDescription,
      this.itemSize,
      this.itemColor,
      this.itemWeightKilos,
      this.itemWeightGrams});

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
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

  incrementQuantity() {
    setState(() {
      int num = int.parse(this.itemQuantity);
      if (num < 10) num++;
      itemQuantity = num.toString();
      this.itemByQuantityPrice =
          (double.parse(this.itemQuantity) * double.parse(widget.itemPrice))
              .toStringAsFixed(2);
    });
  }

  decrementQuantity() {
    setState(() {
      int num = int.parse(itemQuantity);
      if (num > 1) num--;
      this.itemQuantity = num.toString();
      this.itemByQuantityPrice =
          (double.parse(this.itemQuantity) * double.parse(widget.itemPrice))
              .toStringAsFixed(2);
    });
  }

  void changedDropDownWeightKilos(String argumentSelectedCategory) {
    if (argumentSelectedCategory == "0" && selectedWeightGrams == "0") {
      showSnackBar("לא ייתכן משקל של 0 ק'ג ו 0 גרם", scaffoldKey);
    } else {
      setState(() {
        selectedWeightKilos = argumentSelectedCategory;
        double weightInKilos = double.parse(selectedWeightKilos) +
            double.parse(selectedWeightGrams) / 1000;
        double itemPrice = double.parse(widget.itemPrice);
        double price = weightInKilos * itemPrice;
        this.itemByWeightPrice = price.toStringAsFixed(2);
      });
    }
  }

  void changedDropDownWeightGrams(String argumentSelectedCategory) {
    if (argumentSelectedCategory == "0" && selectedWeightGrams == "0") {
      showSnackBar("לא ייתכן משקל של 0 ק'ג ו 0 גרם", scaffoldKey);
    } else {
      setState(() {
        selectedWeightGrams = argumentSelectedCategory;
        double weightInKilos = double.parse(selectedWeightKilos) +
            double.parse(selectedWeightGrams) / 1000;
        double itemPrice = double.parse(widget.itemPrice);
        double price = weightInKilos * itemPrice;
        this.itemByWeightPrice = price.toStringAsFixed(2);
      });
    }
  }

  void orderNow() async {
    String acctUserID = await getStringDataLocally(key: userID);
    if (acctUserID == 'gcBXhffMjEQRANQ5YzVzmmndkfn1') {
      //showSnackBar("נא לצאת מחשבון האורח ולהיכנס לחשבון שלך", scaffoldKey);
      String response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new ShopLogin()));
      return;
    }

    await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new ShopCart(
            itemId: widget.itemId,
            itemName: widget.itemName,
            itemPrice: this.itemByWeightPrice.length == 0
                ? this.itemByQuantityPrice
                : this.itemByWeightPrice,
            itemDescription: widget.itemDescription,
            itemImage: widget.itemImage,
            itemColor: widget.itemColor,
            itemSize: widget.itemSize,
            itemWeightKilos: (selectedWeightKilos != selectedWeightKilos)
                ? selectedWeightKilos
                : selectedWeightKilos,
            itemWeightGrams: (selectedWeightGrams != selectedWeightGrams)
                ? selectedWeightGrams
                : selectedWeightGrams,
            itemQuant: this.itemQuantity,
            itemRemarks: this.controllerRemarks.text.length == 0
                ? "אין הערות"
                : this.controllerRemarks.text,
            itemRating: widget.itemRating)));
    retrievePrefs();
    setState(() {});
  }

  retrievePrefs() async {
    this.itemByQuantityPrice = widget.itemPrice;
    prefs = await SharedPreferences.getInstance();
    this.cartContentsSize = prefs.getInt("cartCounter");
    this.isLoggedIn = await getBoolDataLocally(key: loggedIn);

    this.dropDownWeightKilos = buildAndGetDropDownItems(categoryWeightKilos);
    this.selectedWeightKilos = widget.itemWeightKilos == "null"
        ? categoryWeightKilos[0]
        : widget.itemWeightKilos;

    this.dropDownWeightGrams = buildAndGetDropDownItems(categoryWeightGrams);
    this.selectedWeightGrams = widget.itemWeightGrams == "null"
        ? categoryWeightGrams[0]
        : widget.itemWeightGrams;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrievePrefs();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            "פרטי המוצר",
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: new Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            new Container(
              height: 300.0,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new NetworkImage(widget.itemImage),
                      fit: BoxFit.fitHeight),
                  borderRadius: new BorderRadius.only(
                    bottomRight: new Radius.circular(120.0),
                    bottomLeft: new Radius.circular(120.0),
                  )),
            ),
            new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    height: 150.0,
                  ),
                  new Card(
                    child: new Container(
                      width: screenSize.width,
                      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text(
                            widget.itemName,
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              new Text(
                                this.itemByWeightPrice.length == 0
                                    ? this.itemByQuantityPrice
                                    : this.itemByWeightPrice + " " + "ש'ח",
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.red[500],
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),
                          ((this.selectedWeightGrams != '-1' &&
                                      this.selectedWeightGrams != '0') ||
                                  (this.selectedWeightKilos != '-1' &&
                                      this.selectedWeightKilos != '0'))
                              ? Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "משקל בק'ג",
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        productsDropDown(
                                            textTitle: "משקל בק'ג",
                                            selectedItem:
                                                this.selectedWeightKilos,
                                            dropDownItems: dropDownWeightKilos,
                                            changedDropDownItems:
                                                changedDropDownWeightKilos)
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      children: [
                                        Text(
                                          "משקל בגרם",
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        productsDropDown(
                                            textTitle: "משקל בגרם",
                                            selectedItem:
                                                this.selectedWeightGrams,
                                            dropDownItems: dropDownWeightGrams,
                                            changedDropDownItems:
                                                changedDropDownWeightGrams),
                                      ],
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        incrementQuantity();
                                      },
                                      child: new Icon(
                                        Icons.add_circle_outline,
                                        size: 38.0,
                                        color: Colors.black38,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                      ),
                                      child: new Text(
                                        this.itemQuantity,
                                        style: new TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        decrementQuantity();
                                      },
                                      child: new Icon(
                                        Icons.remove_circle_outline,
                                        size: 38.0,
                                        color: Colors.black38,
                                      ),
                                    )
                                  ],
                                ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  new Card(
                    child: new Container(
                      width: screenSize.width,
                      height: 150.0,
                      child: new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.itemImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                    new CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            new ImageInLarge(
                                                widget.itemImages[index])));
                              },
                              child: new Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  new Container(
                                    margin: new EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    height: 140.0,
                                    width: 140.0,
                                    child: new Image.network(
                                        widget.itemImages[index]),
                                  ),
                                  new Container(
                                    margin: new EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    height: 140.0,
                                    width: 140.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.grey.withAlpha(50)),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                  new Card(
                    child: new Container(
                      width: screenSize.width,
                      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text(
                            "תאור",
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text(
                            widget.itemDescription,
                            style: new TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w400),
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: this.controllerRemarks,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'בקשות מיוחדות מהחנות',
                              hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          TextField(
                            controller: this.controllerRemarks,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'בקשות מיוחדות מהחנות'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: new Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            new FloatingActionButton(
              onPressed: () async {
                String acctUserID = await getStringDataLocally(key: userID);
                if (acctUserID == 'gcBXhffMjEQRANQ5YzVzmmndkfn1') {
                  String response = await Navigator.of(context).push(
                      new CupertinoPageRoute(
                          builder: (BuildContext context) => new ShopLogin()));
                  return;
                }

                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new ShopCart()));
                //retrievePrefs();
                //setState(() {});
              },
              child: new Icon(Icons.shopping_cart),
            ),
            new CircleAvatar(
              radius: 10.0,
              backgroundColor: Colors.red,
              child: new Text(
                this.cartContentsSize == null
                    ? "0"
                    : this.cartContentsSize.toString(),
                style: new TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: new BottomAppBar(
          color: Theme.of(context).primaryColor,
          elevation: 0.0,
          shape: new CircularNotchedRectangle(),
          notchMargin: 5.0,
          child: new Container(
            height: 60.0,
            decoration:
                new BoxDecoration(color: Theme.of(context).primaryColor),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (() {
                    this.orderNow();
                  }),
                  child: new Container(
                    width: (screenSize.width - 20),
                    child: new Text(
                      "לחץ להוספה לעגלה",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 36),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
