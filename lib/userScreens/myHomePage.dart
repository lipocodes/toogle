import 'package:Toogle/tools/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'favourites.dart';
import 'cart.dart';
import 'history.dart';
import 'create_edit_shop.dart';
import 'delivery.dart';
import 'loginlogout.dart';
//import 'package:Toogle/userScreen/contact.dart';
import 'contact.dart';
import 'item_details.dart';
import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/tools/app_data.dart';
import 'package:Toogle/adminScreens/adminHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Toogle/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  String acctPhone = "";
  String acctPhotoURL = "";
  String acctUserID = "";
  String acctShopID = "";
  //String textEditShop = "Create Shop";
  bool isLoggedIn = false;
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  Firestore firestore = Firestore.instance;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  int numberItemsCart = 0;
  List<String> cartContents;
  bool updateNumberItems = false;
  String visitedShopID = "";
  String shopID = "";
  String shopCategory = "";
  List<String> shopCategoryLevel1 = [];
  List<String> shopCategoryLevel2 = [];
  List<String> shopCategoryLevel3 = [];
  String selectedShop = "123456789";
  String selectedCategory1 = "123456789";
  String selectedCategory2 = "123456789";
  String selectedCategory3 = "123456789";
  List<DropdownMenuItem<String>> dropDownShop;
  List<DropdownMenuItem<String>> dropDownCategory1;
  List<DropdownMenuItem<String>> dropDownCategory2;
  List<DropdownMenuItem<String>> dropDownCategory3;
  List<String> shopList = new List();
  List<String> listShopID = [];
  List<String> listShopName = [];
  List<String> categoryLevel1 = [];
  List<String> categoryLevel2 = [];
  List<String> categoryLevel3 = [];
  String selectedSubCategory = "123456789";
  List<String> listForbiddenShops = ["1606740010857512"];
  TextEditingController controllerSearch = new TextEditingController();
  ScrollController controllerScroll = ScrollController();
  String selectedProductInSearch = "";
  List<String> listProductsVisitedShop = [];
  List<String> searchSuggestions = [];
  String searchPattern = "";
  int shopTransitions = 0;
  String phoneShop = "";

  loginAsGuest() async {
    bool response = false;
    try {
      response = await firebaseMethods.loginUser(
          email: "guest@gmail.com", password: "123456");

      await getCurrentUser();
    } catch (e) {
      response = false;
    }
  }

  Future getCurrentUser() async {
    //await clearDataLocally();
    //await retrieveShopID();

    isLoggedIn = await getBoolDataLocally(key: loggedIn);
    if (isLoggedIn == true) {
      acctAddress = await getStringDataLocally(key: address);
      acctName = await getStringDataLocally(key: fullName);
      acctUserID = await getStringDataLocally(key: userID);
      acctEmail = await getStringDataLocally(key: userEmail);
      acctPhone = await getStringDataLocally(key: userPhone);
      acctPhotoURL = await getStringDataLocally(key: photoURL);
      acctShopID = await getStringDataLocally(key: shopID);
    }

    acctName == null ? acctName = "אורח" : acctName = acctName;
    acctUserID == null ? acctUserID = "" : acctUserID = acctUserID;
    acctEmail == null ? acctEmail = "guest@gmail.com" : acctEmail = acctEmail;
    acctPhone == null ? acctPhone = "" : acctPhone = acctPhone;

    acctPhotoURL == null ? acctPhotoURL = "" : acctPhotoURL = acctPhotoURL;
    acctShopID == null ? acctShopID = "" : acctShopID = acctShopID;
    isLoggedIn == null ? isLoggedIn = false : isLoggedIn = true;

    this.shopList = [];
    this.listShopID = [];
    this.listShopName = [];

    List<String> detailsShops =
        await firebaseMethods.retrieveShopList(this.isLoggedIn);

    this.listShopID.add("123");
    if (detailsShops.length > 0)
      this.listShopName.add(
            "נא לבחור חנות",
          );

    for (int i = 0; i < detailsShops.length; i++) {
      List<String> temp = detailsShops[i].split("^^^");

      //show only shop that this user may watch
      if (acctEmail == "lior751@walla.com") {
        this.listShopID.add(temp[0]);
        this.listShopName.add(temp[1]);
        //if this shop is allowed for this user
      } else if (!this.listForbiddenShops.contains(temp[0])) {
        this.listShopID.add(temp[0]);
        this.listShopName.add(temp[1]);
      }
    }

    this.shopList = this.listShopName;
    if (this.shopList.length > 1) {
      this.dropDownShop = buildAndGetDropDownItems(this.shopList);

      if (isLoggedIn == true) {
        List<String> list1 = [];
        List<String> list2 = [];
        List<String> list3 = [];

        this.dropDownShop = buildAndGetDropDownItems(this.shopList);
        this.selectedShop = dropDownShop[0].value;

        this.shopCategoryLevel1 = shopBuildingMaterialsCategoryLevel1;
        this.shopCategoryLevel2 = shopBuildingMaterialsCategoryLevel2;
        this.shopCategoryLevel3 = shopBuildingMaterialsCategoryLevel3;

        this.dropDownCategory1 =
            buildAndGetDropDownItems(this.shopCategoryLevel1);

        this.selectedCategory1 = dropDownCategory1[0].value;

        for (int i = 0; i < this.shopCategoryLevel1.length; i++) {
          String temp = this.shopCategoryLevel1[i];
          int pos = temp.indexOf("^^^");
          temp = temp.substring(pos + 3);
          list1.add(temp);
        }

        this.shopCategoryLevel1 = list1;
        //this.shopCategoryLevel2 = list2;
        //this.shopCategoryLevel3 = list3;

        this.dropDownCategory1 =
            buildAndGetDropDownItems(this.shopCategoryLevel1);

        this.selectedCategory1 = dropDownCategory1[0].value;
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // we need the user to login as Guest as default
    loginAsGuest();

    //readFile('phone');
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      prefs = sp;
      cartContents = sp.getStringList('cartContents');
      this.cartContentsSize = sp.getInt('cartCounter');
      setState(() {});
    });
    //getCurrentUser();
  }

  retrieveShopList() async {
    firebaseMethods.retrieveShopList(this.isLoggedIn);
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
          this.shopCategoryLevel1 = shopBuildingMaterials;
        } else if (this.shopCategory == "צעצועים ומשחקים" ||
            this.shopCategory == "????? ????") {
          this.shopCategoryLevel1 = shopToys;
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
    selectedSubCategory = argumentSelectedSubCategory;

    setState(() {});
  }

  void changedDropDownCategory1(String argumentSelectedCategory1) {
    this.selectedCategory1 = "הכל";
    this.selectedCategory2 = "הכל";
    this.selectedCategory3 = "הכל";
    this.shopCategoryLevel1 = [];
    this.shopCategoryLevel2 = [];
    setState(() {
      String codeTemp1 = "";
      for (int i = 0; i < categoryLevel1.length; i++) {
        int pos = categoryLevel1[i].indexOf("^^^");
        if (pos <= 0) continue;
        String temp = categoryLevel1[i].substring(pos + 3);
        codeTemp1 = categoryLevel1[i].substring(0, pos);
        if (temp == argumentSelectedCategory1) break;
      }

      selectedCategory1 = argumentSelectedCategory1;

      String codeTemp2 = "";
      for (int i = 0; i < categoryLevel2.length; i++) {
        int pos = categoryLevel2[i].indexOf("^^^");
        if (pos <= 0) continue;
        String temp = categoryLevel2[i].substring(pos + 3);
        codeTemp2 = categoryLevel2[i].substring(0, pos);

        if (codeTemp2.substring(0, 3) == codeTemp1 ||
            codeTemp2.substring(0, 3) == "000") {
          this.shopCategoryLevel2.add(temp);
        }
      }

      this.dropDownCategory2 =
          buildAndGetDropDownItems(this.shopCategoryLevel2);
      this.selectedCategory2 = dropDownCategory2[0].value;
    });
  }

  void changedDropDownCategory2(String argumentSelectedCategory2) {
    this.selectedCategory2 = "הכל";
    this.selectedCategory3 = "הכל";
    this.shopCategoryLevel1 = [];
    this.shopCategoryLevel2 = [];
    this.shopCategoryLevel3 = [];
    setState(() {
      String codeTemp2 = "";
      for (int i = 0; i < categoryLevel2.length; i++) {
        int pos = categoryLevel2[i].indexOf("^^^");
        if (pos <= 0) continue;
        String temp = categoryLevel2[i].substring(pos + 3);
        codeTemp2 = categoryLevel2[i].substring(0, pos);
        if (temp == argumentSelectedCategory2) break;
      }

      selectedCategory2 = argumentSelectedCategory2;

      String codeTemp3 = "";
      for (int i = 0; i < categoryLevel3.length; i++) {
        int pos = categoryLevel3[i].indexOf("^^^");
        if (pos <= 0) continue;
        String temp = categoryLevel3[i].substring(pos + 3);
        codeTemp3 = categoryLevel3[i].substring(0, pos);

        if (codeTemp3.substring(0, 6) == codeTemp2 ||
            codeTemp3.substring(0, 6) == "000000") {
          this.shopCategoryLevel3.add(temp);
        }
      }

      if (this.shopCategoryLevel3.length > 0) {
        this.dropDownCategory3 =
            buildAndGetDropDownItems(this.shopCategoryLevel3);
        this.selectedCategory3 = dropDownCategory3[0].value;
      }
    });
  }

  void changedDropDownCategory3(String argumentSelectedCategory3) {
    setState(() {
      selectedCategory3 = argumentSelectedCategory3;
    });
  }

  void changedDropDownShop(String argumentSelectedShop) async {
    int cartCounter;
    this.categoryLevel1 = [];
    this.categoryLevel2 = [];
    this.categoryLevel3 = [];
    this.shopCategoryLevel1 = [];
    this.shopCategoryLevel2 = [];
    this.shopCategoryLevel3 = [];
    try {
      cartCounter = prefs.getInt("cartCounter");
      if (cartCounter == null) cartCounter = 0;
    } catch (e) {
      print("eeeeeeeeeee=" + e.toString());
    }

    for (int i = 0; i < this.listShopName.length; i++) {
      if (this.listShopName[i] == argumentSelectedShop) {
        String id = prefs.getString("visitedShopID");

        this.visitedShopID = this.listShopID[i];

        //if the shop we're entering is the same as the last we visited
        if (id != this.visitedShopID) {
          cartCounter = 0;
          prefs.setInt("cartCounter", 0);
          prefs.setStringList("cartContents", []);
        }

        if (this.visitedShopID == "123") this.visitedShopID = "noShop";

        writeDataLocally(key: "visitedShopID", value: this.visitedShopID);
      }
    }

    var listCategories = await firebaseMethods.getCategories(visitedShopID);

    for (int a = 0; a < listCategories[0].length; a++) {
      categoryLevel1.add(listCategories[0][a].toString());
    }

    for (int a = 0; a < listCategories[1].length; a++) {
      categoryLevel2.add(listCategories[1][a].toString());
    }

    for (int a = 0; a < listCategories[2].length; a++) {
      categoryLevel3.add(listCategories[2][a].toString());
    }

    //we look at this shop's past visitors, and add this visitor if not existent yet
    var list = listCategories[3];

    List<String> visitorList = [];
    if (list == "null") {
      for (int x = 0; x < list.length; x++) {
        visitorList.add(list[x]);
      }
    }

    List<DocumentSnapshot> snapshot =
        await firebaseMethods.retrieveUserDetails(this.acctEmail);
    acctPhone = snapshot[0]['phoneNumber'].toString();

    if (!visitorList.contains(acctPhone) && !this.acctEmail.contains('guest')) {
      //if the list is too long, we need to cut the oldest member of it
      if (visitorList.length > 50) {
        List<String> temp = [];
        for (int x = 1; x < visitorList.length; x++) {
          temp.add(visitorList[x]);
        }
        visitorList = temp;
      }
      visitorList.add(acctPhone);

      bool response = await firebaseMethods.addVisitorToShopList(
          this.visitedShopID, visitorList);
    }

    this.shopCategoryLevel1 = categoryLevel1;
    this.shopCategoryLevel2 = categoryLevel2;
    this.shopCategoryLevel3 = categoryLevel3;

    this.dropDownCategory1 = buildAndGetDropDownItems(this.shopCategoryLevel1);

    List<String> list1 = [];
    for (int i = 0; i < this.shopCategoryLevel1.length; i++) {
      String temp = this.shopCategoryLevel1[i];
      int pos = temp.indexOf("^^^");
      if (pos <= 0) continue;
      temp = temp.substring(pos + 3);
      list1.add(temp);
    }

    this.shopCategoryLevel1 = list1;

    this.dropDownCategory1 = buildAndGetDropDownItems(this.shopCategoryLevel1);

    this.selectedCategory1 = dropDownCategory1[0].value;

    listProductsVisitedShop =
        await firebaseMethods.retrieveVisitedShopProducts(visitedShopID);

    setState(() {
      selectedShop = argumentSelectedShop;
    });
  }

  getPhoneVisitedShop() async {
    this.phoneShop =
        await firebaseMethods.getPhoneVisitedShop(this.visitedShopID);
    setState(() {});
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    //if we are now inside a shop: getting its  phone number
    if (this.phoneShop.length == 0 && this.visitedShopID.length > 0) {
      getPhoneVisitedShop();
      writeDataLocally(key: "visitedShopID", value: this.visitedShopID);
    }

    this.context = context;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.videocam),
                iconSize: 40,
                color: Colors.white,
                splashColor: Colors.purple,
                onPressed: () async {
                  String url = "http://shopping-il.com/#videos";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.admin_panel_settings),
                iconSize: 40,
                color: Colors.black,
                splashColor: Colors.purple,
                onPressed: () async {
                  openAdmin();
                },
              ),
              if (this.visitedShopID.length > 0 &&
                  this.phoneShop.length > 0) ...[
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    Icons.phone,
                  ),
                  iconSize: 24,
                  color: Colors.white,
                  splashColor: Colors.purple,
                  onPressed: () async {
                    String num = this.phoneShop;
                    String url = "tel:" + num;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                SizedBox(width: 15),
                IconButton(
                    icon: FaIcon(FontAwesomeIcons.whatsapp),
                    onPressed: () async {
                      String num = "+972" + this.phoneShop.substring(1);
                      var whatsappUrl = "whatsapp://send?phone=$num";
                      await canLaunch(whatsappUrl)
                          ? launch(whatsappUrl)
                          : print(
                              "Whatsapp is not installed on this device!!!!!!");
                    }),
              ],
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Stack(
            children: [
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (dropDownShop == null)
                    Container()
                  else if (dropDownShop.length > 0) ...[
                    Container(
                      width: 200,
                      child: productsDropDown(
                          textTitle: "Color",
                          selectedItem: selectedShop,
                          dropDownItems: dropDownShop,
                          changedDropDownItems: changedDropDownShop),
                    )
                  ],
                  if (this.selectedShop != "נא לבחור חנות") ...[
                    Container(
                      width: 200,
                      child: productsDropDown(
                          textTitle: "Color",
                          selectedItem: selectedCategory1,
                          dropDownItems: dropDownCategory1,
                          changedDropDownItems: changedDropDownCategory1),
                    )
                  ],
                  if (this.selectedCategory1 != "הכל" ||
                      this.selectedCategory1 == "123456789") ...[
                    Container(
                      width: 200,
                      child: productsDropDown(
                          textTitle: "Color",
                          selectedItem: selectedCategory2,
                          dropDownItems: dropDownCategory2,
                          changedDropDownItems: changedDropDownCategory2),
                    )
                  ],
                  if (this.selectedCategory2 != "הכל" ||
                      this.selectedCategory2 == "123456789") ...[
                    Container(
                      width: 200,
                      child: productsDropDown(
                          textTitle: "Color",
                          selectedItem: selectedCategory3,
                          dropDownItems: dropDownCategory3,
                          changedDropDownItems: changedDropDownCategory3),
                    )
                  ],
                  if (this.controllerSearch.text.length > 0) ...[
                    new Flexible(
                        child: new StreamBuilder(
                            stream: firestore
                                .collection("products_" + this.visitedShopID)
                                .where("productTitle",
                                    isEqualTo: this.selectedProductInSearch)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return noDataFound();
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
                  ]
                  //if the user has chosen all the 3 categories
                  else if ((this.selectedCategory3 != "הכל" &&
                      this.selectedCategory3 != "123456789")) ...[
                    new Flexible(
                        child: new StreamBuilder(
                            stream: firestore
                                .collection("products_" + this.visitedShopID)
                                .where('productCategory1',
                                    isEqualTo: this.selectedCategory1)
                                .where('productCategory2',
                                    isEqualTo: this.selectedCategory2)
                                .where('productCategory3',
                                    isEqualTo: this.selectedCategory3)
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
                  ]

                  //if the user has chosen categories 1,2
                  else if (this.selectedCategory2 != "הכל" &&
                      this.selectedCategory2 != "123456789") ...[
                    new Flexible(
                        child: new StreamBuilder(
                            stream: firestore
                                .collection("products_" + this.visitedShopID)
                                .where('productCategory1',
                                    isEqualTo: this.selectedCategory1)
                                .where('productCategory2',
                                    isEqualTo: this.selectedCategory2)
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
                  ]
                  //if the user has chosen only category 1
                  else if (this.selectedCategory1 != "הכל" &&
                      this.selectedCategory1 != "123456789") ...[
                    new Flexible(
                        child: new StreamBuilder(
                            stream: firestore
                                .collection("products_" + this.visitedShopID)
                                .where('productCategory1',
                                    isEqualTo: this.selectedCategory1)
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
                  ]
                  //if all the categories are '123456789'
                  else ...[
                    new Flexible(
                        child: new StreamBuilder(
                            stream: firestore
                                .collection("products_" + this.visitedShopID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return noDataFound();
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
                  ],
                ],
              ),
              if (this.visitedShopID.length > 0) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              width: 150,
                              height: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                    new Radius.circular(15.0),
                                  ),
                                ),
                                child: TextField(
                                  controller: controllerSearch,
                                  onChanged: (text) {
                                    setState(() {
                                      this.searchSuggestions = [];
                                      if (this.controllerSearch.text.length ==
                                          0) {
                                        this.selectedProductInSearch = "";
                                      }

                                      if (text.length == 0) {
                                        this.selectedProductInSearch = "";
                                      } else {
                                        for (int i = 0;
                                            i < listProductsVisitedShop.length;
                                            i++) {
                                          if (listProductsVisitedShop[i]
                                                  .indexOf(text) ==
                                              0) {
                                            this.searchSuggestions.add(
                                                listProductsVisitedShop[i]);
                                          }
                                        }
                                      }
                                    });
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.teal)),
                                    hintText: "חיפוש בחנות",
                                  ),
                                ),
                              )),
                          if (searchSuggestions.length > 0) ...[
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  this.controllerSearch.text = "";
                                  this.searchSuggestions = [];
                                });
                              },
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF0D47A1),
                                      Color(0xFF1976D2),
                                      Color(0xFF42A5F5),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Text('נקה',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                          if (searchSuggestions.length > 0) ...[
                            Material(
                              elevation: 20,
                              child: Container(
                                  height: 100,
                                  width: 250,
                                  child: new ListView.builder(
                                      //scrollDirection: Axis.horizontal,
                                      itemCount: searchSuggestions.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: new Text(
                                              searchSuggestions[index],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          onTap: (() {
                                            setState(() {
                                              this.selectedProductInSearch =
                                                  searchSuggestions[index];
                                              controllerSearch.text =
                                                  this.selectedProductInSearch;
                                              this.searchSuggestions = [];
                                              FocusScope.of(context).unfocus();
                                            });
                                          }),
                                        );
                                      })),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: !this.acctEmail.contains("guest")
            ? new Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  new FloatingActionButton(
                    onPressed: () async {
                      String acctEmail = prefs.getString("acctEmail");
                      if (acctEmail == "guest@gmail.com") {
                        String response = await Navigator.of(context).push(
                            new CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    new ShopLogin()));
                      } else {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (BuildContext context) => new ShopCart()));
                        //retrievePrefs();
                        //setState(() {});
                      }
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
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              new ListTile(
                enabled: this.isLoggedIn == true &&
                        this.acctEmail != 'guest@gmail.com'
                    ? true
                    : false,
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new ShopHistory()));
                },
                leading: new CircleAvatar(
                    child: new Icon(Icons.history,
                        color: Colors.white, size: 15.0)),
                title: new Text("הזמנות קודמות"),
              ),
              new Divider(),
              new ListTile(
                enabled: this.isLoggedIn == true &&
                        this.acctEmail != 'guest@gmail.com'
                    ? true
                    : false,
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          new CreateEditShop(this.acctEmail, this.acctUserID)));
                },
                leading: new CircleAvatar(
                    child: new Icon(Icons.shopping_cart,
                        color: Colors.white, size: 15.0)),
                title: new Text("יצירה/עריכה של חנות"),
              ),
              new Divider(),
              new ListTile(
                enabled: this.isLoggedIn == true &&
                        this.acctEmail != 'guest@gmail.com'
                    ? true
                    : false,
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          new ShopDelivery(this.acctEmail)));
                },
                leading: new CircleAvatar(
                    child:
                        new Icon(Icons.home, color: Colors.white, size: 15.0)),
                title: new Text("כתובת למשלוח"),
              ),
              new Divider(),
              new ListTile(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new Contact()));
                },
                leading: new Text("יצירת קשר"),
                trailing: new CircleAvatar(
                    child:
                        new Icon(Icons.help, color: Colors.white, size: 15.0)),
              ),
              new ListTile(
                onTap: () {
                  checkIfLoggedIn();
                },
                title: new Text(
                    (isLoggedIn == true && !this.acctEmail.contains("guest"))
                        ? "יציאה"
                        : "כניסה"),
                trailing: new CircleAvatar(
                    child: new Icon(Icons.exit_to_app,
                        color: Colors.white, size: 15.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future checkIfLoggedIn() async {
    if (isLoggedIn == false) {
      String response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new ShopLogin()));

      if (response == "true") {
        await getCurrentUser();
      } else if (response.length >= 16 || response == "y?%&I`bZ4\$") {
        this.visitedShopID = response;
        writeDataLocally(key: "visitedShopID", value: this.visitedShopID);
        await getCurrentUser();
      } else if (response == "noShop") {
        await getCurrentUser();
      }
    } else if (isLoggedIn == true && this.acctEmail.contains("guest") == true) {
      await firebaseMethods.logOutUser();
      String response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new ShopLogin()));
      if (response == "true") {
        await getCurrentUser();
      } else if (response.length >= 16 || response == "y?%&I`bZ4\$") {
        this.visitedShopID = response;
        writeDataLocally(key: "visitedShopID", value: this.visitedShopID);
        await getCurrentUser();
      } else if (response == "noShop") {
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
      showSnackBar("נא להיכנס לחשבון שלך קודם", scaffoldKey);
      return;
    }

    List<DocumentSnapshot> snapshot =
        await firebaseMethods.retrieveUserDetails(this.acctEmail);
    String myShop = snapshot[0]['shopID'].toString();
    if (myShop != "noShop") {
      await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new AdminHome()));
    } else if (myShop == "noShop") {
      showSnackBar("אין לך חנות עדיין", scaffoldKey);
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
              "לא קיימים מוצרים עדיין",
              style: new TextStyle(color: Colors.black45, fontSize: 20.0),
            ),
            new SizedBox(
              height: 10.0,
            ),
            new Text(
              "נא לחזור מאוחר יותר!",
            ),
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
    if (len > 15) title = title.substring(0, 15);
    String id = document[productId].toString();
    String price = document[productPrice].toString();
    String rating = document[productRating].toString();
    String description = document[productDescription].toString();
    String size = document[productSize].toString();
    String color = document[productColor].toString();
    String procductWeightKilos = document['procductWeightKilos'].toString();
    String procductWeightGrams = document['productWeightGrams'].toString();

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
                itemColor: color,
                itemWeightKilos: procductWeightKilos,
                itemWeightGrams: procductWeightGrams)));

        retrievePrefs();
        setState(() {});
      },
      child: new Card(
        child: Stack(
          alignment: FractionalOffset.bottomCenter,
          children: <Widget>[
            new Stack(
              alignment: FractionalOffset.bottomCenter,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: serviceImages[0],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                new Container(
                  height: 50.0,
                  color: Colors.black.withAlpha(100),
                  child: Column(
                    children: [
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(title,
                              style: new TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16.0,
                                  color: Colors.white)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(
                            price.toString() + " " + "ש'ח",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
