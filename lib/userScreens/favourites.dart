import 'package:Toogle/tools/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Toogle/tools/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'item_details.dart';
import 'package:Toogle/app_localizations.dart';

class ShopFavorites extends StatefulWidget {
  String acctShopID;
  ShopFavorites(this.acctShopID);
  @override
  _ShopFavoritesState createState() => _ShopFavoritesState();
}

class _ShopFavoritesState extends State<ShopFavorites> {
  List<String> list1;
  BuildContext context;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  bool isLoggedIn = false;
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  Firestore firestore = Firestore.instance;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String itemId = "";

  void retrieveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    list1 = prefs.getStringList("favorites");
  }

  void removeFromFavorites({String itemId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // List<String> list2;
      list1 = prefs.getStringList("favorites");
      list1.remove(itemId);
      prefs.setStringList("favorites", list1);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveFavorites();
  }

  Widget noDataFound() {
    return new Container(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.find_in_page, color: Colors.black45, size: 80),
            new Text(
              "No products available yet",
              style: new TextStyle(color: Colors.black45, fontSize: 20.0),
            ),
            new SizedBox(
              height: 10.0,
            ),
            new Text("Please check back later!"),
          ],
        ),
      ),
    );
  }

  Widget buildProducts(
      BuildContext context, int index, DocumentSnapshot document) {
    List serviceImages = document[productImages] as List;

    String title = document[productTitle].toString();
    int len = title.length;
    if (len > 8) title = title.substring(0, 8);
    this.itemId = document[productId].toString();
    String price = document[productPrice].toString();
    String rating = document[productRating].toString();
    String description = document[productDescription].toString();
    String size = document[productSize].toString();
    String color = document[productColor].toString();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new CupertinoPageRoute(
            builder: (BuildContext context) => new ItemDetail(
                itemId: this.itemId,
                itemImage: serviceImages[0],
                itemName: document[productTitle],
                itemPrice: price,
                itemRating: rating,
                itemImages: serviceImages,
                itemDescription: description,
                itemSize: size,
                itemColor: color)));
      },
      child: new Card(
        child: Stack(
          alignment: FractionalOffset.topLeft,
          children: <Widget>[
            new Stack(
              alignment: FractionalOffset.bottomCenter,
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: new NetworkImage(
                            serviceImages[0],
                          ))),
                ),
                new Container(
                  height: 40.0,
                  color: Colors.black.withAlpha(100),
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          price.toString() + " " + "ש'ח",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 20.0,
                  width: 0.0,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    borderRadius: new BorderRadius.only(
                        topRight: new Radius.circular(5.0),
                        bottomRight: new Radius.circular(5.0)),
                  ),
                ),
                new IconButton(
                  icon: Icon(Icons.cancel, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      removeFromFavorites(itemId: itemId);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("מוצרים מועדפים"),
        centerTitle: false,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Flexible(
                  child: new StreamBuilder(
                      stream: firestore
                          .collection("products_" + widget.acctShopID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Center(
                            child: new CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor)),
                          );
                        } else {
                          final int dataCount = snapshot.data.documents.length;
                          print("Data count is $dataCount");
                          if (dataCount == 0) {
                            return noDataFound();
                          } else {
                            return new GridView.builder(
                                gridDelegate:
                                    // ignore: missing_return
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: dataCount,
                                itemBuilder: (BuildContext context, int index) {
                                  final DocumentSnapshot document =
                                      snapshot.data.documents[index];

                                  if (list1.contains(document['productId'])) {
                                    return buildProducts(
                                        context, index, document);
                                  } else {
                                    return Container();
                                  }
                                });
                          }
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
