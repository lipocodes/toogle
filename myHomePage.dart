import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toogleWeb/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toogleWeb/tools/firebase_methods.dart';
import 'package:toogleWeb/tools/app_tools.dart';
import 'package:toogleWeb/tools/app_data.dart';
import 'favourites.dart';
import 'loginlogout.dart';
import 'delivery.dart';
import 'history.dart';
import 'create_edit_shop.dart';
import 'item_details.dart';
import 'cart.dart';
import 'package:toogleWeb/adminScreens/adminHome.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cartContentsSize = 0;
  BuildContext context;
  String acctAddress = "";
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  String acctUserID = "";
  String acctShopID = "";
  //String textEditShop = "Create Shop";
  bool isLoggedIn = false;
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  int numberItemsCart = 0;
  List<String> cartContents;
  bool updateNumberItems = false;
  String shopID = "";
  String shopCategory = "";
  List<String> shopSubCategories = [];
  String selectedShop = "123456789";
  String selectedSubCategory = "123456789";
  List<DropdownMenuItem<String>> dropDownShop;
  List<DropdownMenuItem<String>> dropDownSubCategories;
  List<String> shopList = new List();
  List<String> listShopID = [];
  List<String> listShopName = [];

  Future getCurrentUser() async {
    isLoggedIn = await getBoolDataLocally(key: loggedIn);
    if (isLoggedIn == true) {
      acctAddress = await getStringDataLocally(key: address);
      acctName = await getStringDataLocally(key: fullName);
      acctUserID = await getStringDataLocally(key: userID);
      acctEmail = await getStringDataLocally(key: userEmail);
      acctPhotoURL = await getStringDataLocally(key: photoURL);
      acctShopID = await getStringDataLocally(key: shopID);
    }

    acctName == null
        ? acctName = AppLocalizations.of(context).translate('myHome_guest')
        : acctName = acctName;
    acctUserID == null ? acctUserID = "" : acctUserID = acctUserID;
    acctEmail == null ? acctEmail = "guest@gmail.com" : acctEmail = acctEmail;
    acctPhotoURL == null ? acctPhotoURL = "" : acctPhotoURL = acctPhotoURL;
    acctShopID == null ? acctShopID = "" : acctShopID = acctShopID;
    isLoggedIn == null ? isLoggedIn = false : isLoggedIn = true;

    this.shopList = [];
    this.listShopID = [];
    this.listShopName = [];

    List<String> detailsShops = await firebaseMethods.retrieveShopList();

    this.listShopID.add("123");
    this.listShopName.add(
          AppLocalizations.of(context).translate('myHomePage_choose_shop'),
        );

    for (int i = 0; i < detailsShops.length; i++) {
      List<String> temp = detailsShops[i].split("^^^");
      this.listShopID.add(temp[0]);
      this.listShopName.add(temp[1]);
    }

    this.shopList = this.listShopName;
    if (this.shopList.length > 1) {
      this.dropDownShop = buildAndGetDropDownItems(this.shopList);

      if (isLoggedIn == true) {
        List<String> list1 = [];

        this.dropDownShop = buildAndGetDropDownItems(this.shopList);
        this.selectedShop = dropDownShop[0].value;

        this.shopSubCategories = shopBuildingMaterials;
        this.dropDownSubCategories =
            buildAndGetDropDownItems(this.shopSubCategories);
        this.selectedSubCategory = dropDownSubCategories[0].value;

        for (int i = 0; i < this.shopSubCategories.length; i++) {
          list1.add(AppLocalizations.of(context)
              .translate(this.shopSubCategories[i]));
        }

        this.shopSubCategories = list1;

        this.dropDownSubCategories =
            buildAndGetDropDownItems(this.shopSubCategories);

        this.selectedSubCategory = dropDownSubCategories[0].value;
      }
    }

    setState(() {});
  }

  retrieveShopList() async {
    firebaseMethods.retrieveShopList();
  }

  Future retrieveShopID() async {
    try {
      var temp = await getStringDataLocally(key: "shopID");

      if (temp.runtimeType.toString() == "String") {
        this.shopID = temp.toString();
        if (this.shopID == "noShop") return;
        List<String> shopDetails =
            await firebaseMethods.retrieveShopDetails(this.shopID);

        this.selectedShop =
            shopDetails[1].toString() != null ? shopDetails[1].toString() : "";

        this.shopCategory = shopDetails[5].toString();
        writeDataLocally(
            key: "creditCardPayment", value: shopDetails[6].toString());
        writeDataLocally(
            key: "paypalPayment", value: shopDetails[7].toString());
        if (this.shopCategory == "חומרי בניין" ||
            this.shopCategory == "???? ????") {
          this.shopSubCategories = shopBuildingMaterials;
        } else if (this.shopCategory == "צעצועים ומשחקים" ||
            this.shopCategory == "????? ????") {
          this.shopSubCategories = shopToys;
        }
      } else
        this.shopID = "";
    } catch (e) {
      this.shopID = "";
    }
    //setState(() {});

    return;
  }

  void changedDropDownSubCategory(String argumentSelectedSubCategory) {
    setState(() {
      selectedSubCategory = argumentSelectedSubCategory;
    });
  }

  void changedDropDownShop(String argumentSelectedShop) {
    for (int i = 0; i < this.listShopName.length; i++) {
      if (this.listShopName[i] == argumentSelectedShop) {
        this.shopID = this.listShopID[i];
        if (this.shopID == "123") this.shopID = "noShop";
        writeDataLocally(key: "shopID", value: this.shopID);
      }
    }
    setState(() {
      selectedShop = argumentSelectedShop;
    });
  }

  Future checkIfLoggedIn() async {
    await getCurrentUser();

    if (isLoggedIn == false) {
      bool response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new ShopLogin()));
      if (response == true) {
        //await this.retrieveShopID();
        await getCurrentUser();
      }
    } else {
      bool response = await firebaseMethods.logOutUser();

      if (response == true) {
        //await this.retrieveShopID();
        this.shopID = "123";
        getCurrentUser();
        print("Logged out!!!");
        setState(() {});
      }
    }
  }

  void openAdmin() async {
    if (this.isLoggedIn == false) {
      showSnackBar(
          AppLocalizations.of(context).translate('myHomePage_please_login'),
          scaffoldKey);
      return;
    }

    var querySnapshot =
        await firebaseMethods.retrieveUserDetails(this.acctEmail);
    String myShop = querySnapshot.documents[0].data()['shopID'].toString();

    if (myShop != "noShop") {
      await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new AdminHome()));
    } else if (myShop == "noShop") {
      showSnackBar(AppLocalizations.of(context).translate('myHomePage_no_shop'),
          scaffoldKey);
    }
  }

  retrievePrefs() async {
    prefs = await SharedPreferences.getInstance();
    this.cartContentsSize = prefs.getInt("cartCounter");

    setState(() {});
  }

  Widget noDataFound() {
    return new Container(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.find_in_page, color: Colors.black45, size: 80),
            new Text(
              AppLocalizations.of(context)
                  .translate('myHomePage_no_products_yet'),
              style: new TextStyle(color: Colors.black45, fontSize: 20.0),
            ),
            new SizedBox(
              height: 10.0,
            ),
            new Text(
              AppLocalizations.of(context)
                  .translate('myHomePage_please_return_later'),
            ),
          ],
        ),
      ),
    );
  }

  Widget notLoggedIn() {
    return new Container(
      child: new Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.find_in_page, color: Colors.black45, size: 80),
              new Text(
                AppLocalizations.of(context)
                    .translate('myHomePage_not_logged_in_yet'),
                style: new TextStyle(color: Colors.black45, fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProducts(
      BuildContext context, int index, DocumentSnapshot document) {
    print("qqqqqqqqqqqqqqqqqqqqqqqqqq=" + document.runtimeType.toString());

    /*List serviceImages = document[productImages] as List;
 
    String title = document[productTitle].toString();
    int len = title.length;
    if (len > 15) title = title.substring(0, 15);
    String id = document[productId].toString();
    String price = document[productPrice].toString();
    String rating = document[productRating].toString();
    String description = document[productDescription].toString();
    String size = document[productSize].toString();
    String color = document[productColor].toString();

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(new CupertinoPageRoute(
            builder: (BuildContext context) => new ItemDetail(
                itemId: id,
                itemImage: serviceImages[0],
                itemName: document[productTitle],
                itemPrice: price,
                itemRating: rating,
                itemImages: serviceImages,
                itemDescription: description,
                itemSize: size,
                itemColor: color)));

        retrievePrefs();
        setState(() {});
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
                  height: 50.0,
                  color: Colors.black.withAlpha(100),
                  child: Column(
                    children: [
                      new Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(title,
                              style: new TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                  color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: [
                          new Text(
                            price.toString() +
                                " " +
                                AppLocalizations.of(context)
                                    .translate('myHome_currency'),
                            style: TextStyle(
                                color: Colors.red[500],
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /*new Container(
                  height: 20.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    borderRadius: new BorderRadius.only(
                        topRight: new Radius.circular(5.0),
                        bottomRight: new Radius.circular(5.0)),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Icon(Icons.star, color: Colors.blue, size: 20.0),
                      new Text(rating.toString(),
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),*/
                //new IconButton(icon: Icon(Icons.favorite_border, color: Colors.blue), onPressed: () {},),
              ],
            ),
          ],
        ),
      ),
    );*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //readFile('phone');
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      prefs = sp;
      cartContents = sp.getStringList('cartContents');
      this.cartContentsSize = sp.getInt('cartCounter');
      setState(() {});
    });
    if (this.isLoggedIn == true) {
      getCurrentUser();
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    this.context = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: GestureDetector(
          child: new Text(selectedShop == "123456789" ? "Shop" : selectedShop),
          onLongPress: openAdmin,
        ),
        centerTitle: true,
        actions: [
          new IconButton(
              icon: new Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new ShopFavorites(this.shopID)));
              }),
        ],
      ),
      body: Container(
        child: new Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                this.isLoggedIn == true
                    ? productsDropDown(
                        textTitle: "Color",
                        selectedItem: selectedShop,
                        dropDownItems: dropDownShop,
                        changedDropDownItems: changedDropDownShop)
                    : Container(),
                this.isLoggedIn == true
                    ? productsDropDown(
                        textTitle: "Color",
                        selectedItem: selectedSubCategory,
                        dropDownItems: dropDownSubCategories,
                        changedDropDownItems: changedDropDownSubCategory)
                    : Container(),
              ],
            ),
            this.isLoggedIn == false
                ? notLoggedIn()
                : this.selectedSubCategory !=
                        AppLocalizations.of(context).translate(
                            'category_building_materials_subcategory_general')
                    ? new Flexible(
                        child: new StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(usersData)
                                .where('userEmail',
                                    isEqualTo: 'menashe.altman@gmail.com')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return new Center(
                                  child: new CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)),
                                );
                              } else {
                                final int dataCount =
                                    snapshot.data.documents.length;
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final DocumentSnapshot document =
                                            snapshot.data.documents[index];
                                        return buildProducts(
                                            context, index, document);
                                      });
                                }
                              }
                            }))
                    : new Flexible(
                        child: new StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("products_" + this.shopID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return new Center(
                                  child: new CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)),
                                );
                              } else {
                                final int dataCount =
                                    snapshot.data.documents.length;
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final DocumentSnapshot document =
                                            snapshot.data.documents[index];
                                        return buildProducts(
                                            context, index, document);
                                      });
                                }
                              }
                            })),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          new FloatingActionButton(
            onPressed: () async {
              if (this.shopID == "" || this.shopID == "123")
                this.shopID = "noShop";
              if (this.isLoggedIn == true && this.shopID != "noShop") {
                await Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new ShopCart()));

                retrievePrefs();
                setState(() {});
              } else if (this.shopID == "noShop") {
                showSnackBar(
                    AppLocalizations.of(context)
                        .translate('myHomePage_choose_shop'),
                    scaffoldKey);
              } else {
                showSnackBar(
                    AppLocalizations.of(context)
                        .translate('myHomePage_please_login'),
                    scaffoldKey);
              }
            },
            child: Icon(Icons.shopping_cart),
          ),
          new CircleAvatar(
              radius: 12.0,
              backgroundColor: Colors.red,
              child: Text(
                  this.cartContentsSize.toString() != "null"
                      ? this.cartContentsSize.toString()
                      : "0",
                  style: new TextStyle(color: Colors.white, fontSize: 8.0))),
        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(acctName),
              accountEmail: new Text(acctEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Icon(Icons.person),
              ),
            ),
            /*new ListTile(
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new ShopNotifications()));
              },
              leading: new CircleAvatar(
                  child: new Icon(Icons.notifications,
                      color: Colors.white, size: 15.0)),
              title: new Text(
                AppLocalizations.of(context)
                    .translate('myHomePage_order_notification'),
              ),
            ),*/
            new ListTile(
              enabled: this.isLoggedIn == true ? true : false,
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new ShopHistory()));
              },
              leading: new CircleAvatar(
                  child:
                      new Icon(Icons.history, color: Colors.white, size: 15.0)),
              title: new Text(AppLocalizations.of(context)
                  .translate('myHomePage_order_history')),
            ),
            new Divider(),
            new ListTile(
              enabled: this.isLoggedIn == true ? true : false,
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new CreateEditShop(this.acctEmail, this.acctUserID)));
              },
              leading: new CircleAvatar(
                  child: new Icon(Icons.shopping_cart,
                      color: Colors.white, size: 15.0)),
              title: new Text(AppLocalizations.of(context)
                  .translate('myHome_create_edit_shop')),
            ),
            new Divider(),
            new ListTile(
              enabled: this.isLoggedIn == true ? true : false,
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new ShopDelivery(this.acctEmail)));
              },
              leading: new CircleAvatar(
                  child: new Icon(Icons.home, color: Colors.white, size: 15.0)),
              title: new Text(AppLocalizations.of(context)
                  .translate('myHome_delivery_address')),
            ),
            new Divider(),
            new ListTile(
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Contact()));
              },
              leading: new Text(
                  AppLocalizations.of(context).translate('myHome_contact')),
              trailing: new CircleAvatar(
                  child: new Icon(Icons.help, color: Colors.white, size: 15.0)),
            ),
            new ListTile(
              onTap: () {
                checkIfLoggedIn();
              },
              title: new Text(isLoggedIn == true
                  ? AppLocalizations.of(context).translate('myHome_logout')
                  : AppLocalizations.of(context).translate('myHome_login')),
              trailing: new CircleAvatar(
                  child: new Icon(Icons.exit_to_app,
                      color: Colors.white, size: 15.0)),
            ),
          ],
        ),
      ),
    );
  }
}
