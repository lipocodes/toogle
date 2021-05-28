import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Presentation/pages/loginlogout.dart';
import 'package:Toogle/Presentation/state_management/myHomePage_provider/myHomePage_state.dart';
import 'package:Toogle/Presentation/state_management/user_provider/user_state.dart';
import 'package:Toogle/adminScreens/adminHome.dart';
import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePageProvider extends ChangeNotifier {
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
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerShopNumber = TextEditingController();
  String defaultShopName = "ברכת המזון";

  switchShop(String numberShop) async {
    int cartCounter;
    this.categoryLevel1 = [];
    this.categoryLevel2 = [];
    this.categoryLevel3 = [];
    this.shopCategoryLevel1 = [];
    this.shopCategoryLevel2 = [];
    this.shopCategoryLevel3 = [];
    try {
      cartCounter = prefs.getInt("cartCounter");

      if (cartCounter == null)
        cartCounter = 0;
      else if (cartCounter > 0) {
        cartCounter = 0;
        prefs.setInt("cartCounter", 0);
        prefs.setStringList("cartContents", []);
      }
    } catch (e) {
      print("eeeeeeeeeeeee=" + e.toString());
    }

    String shopName =
        await firebaseMethods.convertShopIDToShopName(numberShop.trim());

//this.listShopName
    this.visitedShopID = numberShop.trim();
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

    selectedShop = shopName;
    /*setState(() {
     
    });*/
  }

  Future<void> openDialogSwitchShop() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Directionality(
              textDirection: TextDirection.rtl, child: Text('מספר החנות')),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: controllerShopNumber,
              decoration: InputDecoration(hintText: "נא להכניס מספר חנות"),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ביטול'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('אישור'),
              onPressed: () {
                this.switchShop(controllerShopNumber.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('נא להכניס מספר טלפון'),
          content: TextField(
            textDirection: TextDirection.ltr,
            controller: controllerPhone,
            //decoration: InputDecoration(hintText: "מספר הטלפון שלך"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ביטול'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('אישור'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

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

    if (this.visitedShopID.length != 3) this.visitedShopID = "325";
    String shopName =
        await firebaseMethods.convertShopIDToShopName(this.visitedShopID);

    var listCategories = await firebaseMethods.getCategories(visitedShopID);

    categoryLevel1 = [];
    categoryLevel2 = [];
    categoryLevel3 = [];

    for (int a = 0; a < listCategories[0].length; a++) {
      categoryLevel1.add(listCategories[0][a].toString());
    }

    for (int a = 0; a < listCategories[1].length; a++) {
      categoryLevel2.add(listCategories[1][a].toString());
    }

    for (int a = 0; a < listCategories[2].length; a++) {
      categoryLevel3.add(listCategories[2][a].toString());
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

    selectedShop = shopName;
    /*setState(() {
      
    });*/
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

    //setState(() {});
  }

  void changedDropDownCategory1(String argumentSelectedCategory1) {
    this.selectedCategory1 = "הכל";
    this.selectedCategory2 = "הכל";
    this.selectedCategory3 = "הכל";
    this.shopCategoryLevel1 = [];
    this.shopCategoryLevel2 = [];

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

    this.dropDownCategory2 = buildAndGetDropDownItems(this.shopCategoryLevel2);
    this.selectedCategory2 = dropDownCategory2[0].value;

    /*setState(() {
     
    });*/
  }

  void changedDropDownCategory2(String argumentSelectedCategory2) {
    this.selectedCategory2 = "הכל";
    this.selectedCategory3 = "הכל";
    this.shopCategoryLevel1 = [];
    this.shopCategoryLevel2 = [];
    this.shopCategoryLevel3 = [];

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

    /*setState(() {
      
    });*/
  }

  void changedDropDownCategory3(String argumentSelectedCategory3) {
    /*setState(() {
      selectedCategory3 = argumentSelectedCategory3;
    });*/
  }

  getPhoneVisitedShop() async {
    this.phoneShop =
        await firebaseMethods.getPhoneVisitedShop(this.visitedShopID);
    // setState(() {});
  }

  checkIfLoggedIn() async {
    if (this.acctEmail.contains("guest") == true) {
      await firebaseMethods.logOutUser();
      String response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new ShopLogin()));
      if (response.length == 3) {
        this.visitedShopID = response;
        writeDataLocally(key: "visitedShopID", value: this.visitedShopID);
        await getCurrentUser();
      } else if (response == "noShop") {
        await getCurrentUser();
      }
    } else {
      //if it's a logged in user
      bool response = await firebaseMethods.logOutUser();

      //getCurrentUser();
      if (response == true) {
        //await this.retrieveShopID();
        this.shopID = "123";
        //getCurrentUser();
        print("Logged out!!!");
        changeState(UserLoggedInState());
        notifyListeners();
        //setState(() {});
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

    //setState(() {});
  }

  MyHomePageState _state; //an object of one of the possible states
  MyHomePageState get state =>
      _state; //a class can access _state only by a getter
  void changeState(MyHomePageState myHomePageState) {
    _state = myHomePageState;
    notifyListeners(); //make all the Widgets which listen to this Provider know about the new state.

    // call the usecase to get the response
    /* Either<ServerException, Fact> failOrFact = await _getRandomFactUsecase(
      params: Params(language: language),
    );*/
    // check either the usecase return exception or result
    /*failOrFact.fold(
      (exception) {
        // if an exception was handled, just return error message
        _state = NewUserError(message: exception.toString());
        notifyListeners();
      },
      (fact) {
        // if a Fact object was returned, make a new state based on it
        addFact(fact);
        _state = NewFactLoaded(result: fact);
        notifyListeners();
      },
    );*/
  }
}
