import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/state_management/item_details_provider/item_details_provider.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:Toogle/tools/app_tools.dart';
import 'cart.dart';
import 'package:Toogle/Core/app_localizations.dart';
import 'images_in_large.dart';
//import 'package:Toogle/tools/app_data.dart';
//import 'package:Toogle/userScreens/loginlogout.dart';

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
  BuildContext context;

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
  // Widget section //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////
  Widget customFloatingButton(ItemDetailProvider itemDetailProvider) {
    return new Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        new FloatingActionButton(
          onPressed: () async {
            itemDetailProvider.orderNow(widget.context);
          },
          child: new Icon(Icons.shopping_cart),
        ),
        new CircleAvatar(
          radius: 10.0,
          backgroundColor: Colors.red,
          child: new Text(
            itemDetailProvider.cartContentsSize == null
                ? "0"
                : itemDetailProvider.cartContentsSize.toString(),
            style: new TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        )
      ],
    );
  }

  Widget customBottomBar(ItemDetailProvider itemDetailProvider) {
    return new BottomAppBar(
      color: Theme.of(context).primaryColor,
      elevation: 0.0,
      shape: new CircularNotchedRectangle(),
      notchMargin: 5.0,
      child: new Container(
        height: 60.0,
        decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (() {
                itemDetailProvider.orderNow(widget.context);
              }),
              child: new Container(
                width: (itemDetailProvider.screenSize.width - 20),
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
    );
  }

  Widget customAppBar(ItemDetailProvider itemDetailProvider) {
    if (itemDetailProvider.retrievedItemDetails == false) {
      itemDetailProvider.retrievedItemDetails = true;
      itemDetailProvider.retrievePrefs();
      itemDetailProvider.screenSize = MediaQuery.of(context).size;
    }

    return new AppBar(
      title: new Text(
        "פרטי המוצר",
      ),
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget customBody(ItemDetailProvider itemDetailProvider) {
    return new Stack(
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
                  width: itemDetailProvider.screenSize.width,
                  margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new SizedBox(
                        height: 10.0,
                      ),
                      new Text(
                        itemDetailProvider.itemName,
                        style: new TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          new Text(
                            itemDetailProvider.itemByWeightPrice.length == 0
                                ? itemDetailProvider.itemByQuantityPrice
                                : itemDetailProvider.itemByWeightPrice +
                                    " " +
                                    "ש'ח",
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
                      ((itemDetailProvider.selectedWeightGrams != '-1' &&
                                  itemDetailProvider.selectedWeightGrams !=
                                      '0') ||
                              (itemDetailProvider.selectedWeightKilos != '-1' &&
                                  itemDetailProvider.selectedWeightKilos !=
                                      '0'))
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
                                        selectedItem: itemDetailProvider
                                            .selectedWeightKilos,
                                        dropDownItems: itemDetailProvider
                                            .dropDownWeightKilos,
                                        changedDropDownItems: itemDetailProvider
                                            .changedDropDownWeightKilos)
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
                                        selectedItem: itemDetailProvider
                                            .selectedWeightGrams,
                                        dropDownItems: itemDetailProvider
                                            .dropDownWeightGrams,
                                        changedDropDownItems: itemDetailProvider
                                            .changedDropDownWeightGrams),
                                  ],
                                )
                              ],
                            )
                          : Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    itemDetailProvider.incrementQuantity();
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
                                    itemDetailProvider.itemQuantity,
                                    style: new TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    itemDetailProvider.decrementQuantity();
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
                  width: itemDetailProvider.screenSize.width,
                  height: 150.0,
                  child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: itemDetailProvider.itemImages.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                                new CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        new ImageInLarge(itemDetailProvider
                                            .itemImages[index])));
                          },
                          child: new Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              new Container(
                                margin:
                                    new EdgeInsets.only(left: 5.0, right: 5.0),
                                height: 140.0,
                                width: 140.0,
                                child:
                                    new Image.network(widget.itemImages[index]),
                              ),
                              new Container(
                                margin:
                                    new EdgeInsets.only(left: 5.0, right: 5.0),
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
                  width: itemDetailProvider.screenSize.width,
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
                        itemDetailProvider.itemDescription,
                        style: new TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w400),
                      ),
                      new SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: itemDetailProvider.controllerRemarks,
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
                        controller: itemDetailProvider.controllerRemarks,
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
    );
  }

  // Method section //////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    return Consumer<ItemDetailProvider>(
        builder: (context, itemDetailProvider, child) {
      itemDetailProvider.itemId = widget.itemId;
      itemDetailProvider.itemImage = widget.itemImage;
      itemDetailProvider.itemName = widget.itemName;
      itemDetailProvider.itemPrice = widget.itemPrice;
      itemDetailProvider.itemRating = widget.itemRating;
      itemDetailProvider.itemImages = widget.itemImages;
      itemDetailProvider.itemDescription = widget.itemDescription;
      itemDetailProvider.itemSize = widget.itemSize;
      itemDetailProvider.itemColor = widget.itemColor;
      itemDetailProvider.itemWeightKilos = widget.itemWeightKilos;
      itemDetailProvider.itemWeightGrams = widget.itemWeightGrams;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: itemDetailProvider.scaffoldKey,
          appBar: customAppBar(itemDetailProvider),
          body: customBody(itemDetailProvider),
          floatingActionButton: customFloatingButton(itemDetailProvider),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: customBottomBar(itemDetailProvider),
        ),
      );
    });
  }
}
