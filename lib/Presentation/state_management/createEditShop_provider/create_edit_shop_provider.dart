import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/state_management/contact_provider/contact_state.dart';
import 'package:Toogle/Presentation/state_management/createEditShop_provider/createEditShop_state.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateEditShopProvider extends ChangeNotifier {
  CreateEditShopState _state;
  CreateEditShopState get state => _state;

  List<String> shopCategoryLevel1 = [];
  List<String> shopCategoryLevel2 = [];
  List<String> shopCategoryLevel3 = [];
  String selectedCategory1 = "123456789";
  String selectedCategory2 = "123456789";
  String selectedCategory3 = "123456789";
  List<DropdownMenuItem<String>> dropDownCategory1;
  List<DropdownMenuItem<String>> dropDownCategory2;
  List<DropdownMenuItem<String>> dropDownCategory3;
  List<String> categoryLevel1 = [];
  List<String> categoryLevel2 = [];
  List<String> categoryLevel3 = [];
  List<String> tempCategoryLevel1 = [];
  List<DropdownMenuItem<String>> dropDownCategories;
  List<String> categoryList = new List();
  List<String> shopDetails;
  List<String> listLevel2 = [];
  List<String> listLevel3 = [];
  TextEditingController controllerFullName = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerAddress = new TextEditingController();
  TextEditingController shopCategoryController = new TextEditingController();
  TextEditingController paypalPaymentController = new TextEditingController();
  TextEditingController creditCardPaymentController =
      new TextEditingController();
  TextEditingController controllerAddToCategory1 = new TextEditingController();
  TextEditingController controllerAddToCategory2 = new TextEditingController();
  TextEditingController controllerAddToCategory3 = new TextEditingController();
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  String shopID = "";
  String selectedCategory = "";
  List<DropdownMenuItem<String>> shopCategoriesList;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isNewShop = false;
  String sendReceipt = "כן";
  bool enableUpdateStoreButton = true;
  bool enableShopCategories = true;
  String acctEmail = "";
  String acctUserID = "";
  bool retrievedShopDetailsYet = false;

  void changeState(CreateEditShopState createEditShopState) {
    _state = createEditShopState;
    notifyListeners();
  }

  addToCategory1(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                      ],
                      controller: controllerAddToCategory1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'שם הקטגוריה החדשה'),
                    ),
                    SizedBox(
                      width: 200.0,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              for (int x = 0; x < categoryLevel1.length; x++) {
                                String str = categoryLevel1[x];
                                int pos = str.indexOf("^^^");
                                if (pos < 0) continue;
                                String name = str.substring(pos + 3);
                                if (name ==
                                    this.controllerAddToCategory1.text) {
                                  showSnackBar("ערך זה כבר קיים", scaffoldKey);
                                  Navigator.pop(context);
                                  return;
                                }
                              }

                              if (this.controllerAddToCategory1.text.length ==
                                  0) {
                                showSnackBar(
                                    "חסר שם לקטגוריה החדשה", scaffoldKey);
                                Navigator.pop(context);
                                return;
                              }

                              int length = this.categoryLevel1.length;

                              String len = length.toString();
                              if (len.length == 1)
                                len = "00" + len;
                              else if (len.length == 2) len = "0" + len;
                              String phrase = len.toString() +
                                  "^^^" +
                                  controllerAddToCategory1.text;
                              this.categoryLevel1.add(phrase);

                              List<String> tempCategoryLevel1 =
                                  this.categoryLevel1;

                              for (int x = 0;
                                  x < tempCategoryLevel1.length;
                                  x++) {
                                int pos = tempCategoryLevel1[x].indexOf("^^^");
                                if (pos < 0) continue;
                                tempCategoryLevel1[x].substring(pos + 3);
                              }

                              List<String> listCategory1 = [];
                              for (int x = 0;
                                  x < tempCategoryLevel1.length;
                                  x++) {
                                String str = tempCategoryLevel1[x];
                                int pos = str.indexOf("^^^");
                                if (pos < 0) continue;
                                listCategory1.add(str.substring(pos + 3));
                              }

                              this.dropDownCategory1 =
                                  buildAndGetDropDownItems(listCategory1);
                              selectedCategory1 = listCategory1[0];

                              changeState(AddedToCategory1());
                            },
                            child: Text(
                              "הוספה",
                              style: TextStyle(color: Colors.white),
                            ),
                            //color: Colors.black,
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "ביטול",
                              style: TextStyle(color: Colors.white),
                            ),
                            // color: Colors.black,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  addToCategory2(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                      ],
                      controller: controllerAddToCategory2,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'שם הקטגוריה החדשה'),
                    ),
                    SizedBox(
                      width: 200.0,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              for (int x = 0; x < categoryLevel2.length; x++) {
                                String str = categoryLevel2[x];
                                int pos = str.indexOf("^^^");
                                if (pos < 0) continue;
                                String name = str.substring(pos + 3);
                                if (name ==
                                    this.controllerAddToCategory2.text) {
                                  showSnackBar("ערך זה כבר קיים", scaffoldKey);
                                  Navigator.pop(context);
                                  return;
                                }
                              }

                              if (this.controllerAddToCategory2.text.length ==
                                  0) {
                                showSnackBar(
                                    "חסר שם לקטגוריה החדשה", scaffoldKey);
                                Navigator.pop(context);
                                return;
                              }
                              String codeSelectedCategory1 = "";

                              //finding the code of the value selected in Category1
                              for (int p = 0;
                                  p < this.categoryLevel1.length;
                                  p++) {
                                String str = this.categoryLevel1[p];
                                if (str.substring(0, 1) == "  ")
                                  str.substring(1);
                                int pos = str.indexOf("^^^");
                                codeSelectedCategory1 = str.substring(0, pos);
                                String name = str.substring(pos + 3);
                                if (name == this.selectedCategory1) {
                                  break;
                                }
                              }

                              //counting how many items in Category1 have a 'parent' with this code
                              int count = 0;
                              int lastIndex = 0;
                              for (int p = 0;
                                  p < this.categoryLevel2.length;
                                  p++) {
                                String str = this.categoryLevel2[p];
                                if (str.indexOf(' ') == 0)
                                  str = str.substring(1);
                                else if (str.indexOf('  ') == 0)
                                  str = str.substring(2);

                                int pos = str.indexOf("^^^");
                                if (pos < 0) continue;
                                String code = str.substring(0, pos);

                                if (code.substring(0, 3) ==
                                    codeSelectedCategory1) {
                                  count++;
                                  lastIndex = p;
                                }
                              }

                              count = count + 1;
                              String num = count.toString();
                              if (num.length == 1)
                                num = "00" + num;
                              else if (num.length == 2) num = "0" + num;
                              String phrase = codeSelectedCategory1 +
                                  num +
                                  "^^^" +
                                  this.controllerAddToCategory2.text;

                              if (lastIndex > 0) {
                                this
                                    .categoryLevel2
                                    .insert(lastIndex + 1, phrase);
                              } else {
                                this.categoryLevel2.add(phrase);
                              }

                              List<String> tempCategoryLevel2 =
                                  this.categoryLevel2;
                              for (int x = 0;
                                  x < tempCategoryLevel2.length;
                                  x++) {
                                int pos = tempCategoryLevel2[x].indexOf("^^^");
                                if (pos < 0) continue;
                                tempCategoryLevel2[x].substring(pos + 3);
                              }

                              List<String> listCategory2 = [];
                              //listCategory2.add("הכל");

                              for (int x = 0;
                                  x < tempCategoryLevel2.length;
                                  x++) {
                                listCategory2
                                    .add(tempCategoryLevel2[x].substring(9));
                              }

                              this.dropDownCategory2 =
                                  buildAndGetDropDownItems(listCategory2);
                              selectedCategory2 = listCategory2[0];

                              changeState(AddedToCategory2());
                            },
                            child: Text(
                              "הוספה",
                              style: TextStyle(color: Colors.white),
                            ),
                            //color: Colors.black,
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "ביטול",
                              style: TextStyle(color: Colors.white),
                            ),
                            //color: Colors.black,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  addToCategory3(BuildContext context) async {
    int count = 0;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                      ],
                      controller: controllerAddToCategory3,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'שם הקטגוריה החדשה'),
                    ),
                    SizedBox(
                      width: 200.0,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              for (int x = 0; x < categoryLevel3.length; x++) {
                                String str = categoryLevel3[x];
                                int pos = str.indexOf("^^^");
                                if (pos < 0) continue;
                                String name = str.substring(pos + 3);
                                if (name ==
                                    this.controllerAddToCategory3.text) {
                                  showSnackBar("ערך זה כבר קיים", scaffoldKey);
                                  Navigator.pop(context);
                                  return;
                                }
                              }
                              if (this.controllerAddToCategory3.text.length ==
                                  0) {
                                showSnackBar(
                                    "חסר שם לקטגוריה החדשה", scaffoldKey);
                                Navigator.pop(context);
                                return;
                              }
                              String codeSelectedCategory2 = "";

                              //finding the code of the value selected in Category1
                              for (int p = 0;
                                  p < this.categoryLevel2.length;
                                  p++) {
                                String str = this.categoryLevel2[p];
                                if (str.substring(0, 1) == "  ")
                                  str.substring(1);
                                int pos = str.indexOf("^^^");
                                codeSelectedCategory2 = str.substring(0, pos);
                                String name = str.substring(pos + 3);
                                if (name == this.selectedCategory2) {
                                  break;
                                }
                              }

                              //counting how many items in Category1 have a 'parent' with this code

                              int lastIndex = 0;
                              for (int p = 0;
                                  p < this.categoryLevel3.length;
                                  p++) {
                                String str = this.categoryLevel3[p];

                                if (str.indexOf(' ') == 0)
                                  str = str.substring(1);
                                else if (str.indexOf('  ') == 0)
                                  str = str.substring(2);

                                int pos = str.indexOf("^^^");
                                if (pos < 0) continue;
                                String code = str.substring(0, pos);

                                if (code.substring(0, 6) ==
                                    codeSelectedCategory2) {
                                  count++;

                                  lastIndex = p;
                                }
                              }

                              count = count + 1;
                              String num = count.toString();

                              if (num.length == 1)
                                num = "00" + num;
                              else if (num.length == 2) num = "0" + num;
                              String phrase = codeSelectedCategory2 +
                                  num +
                                  "^^^" +
                                  this.controllerAddToCategory3.text;

                              if (lastIndex > 0) {
                                this
                                    .categoryLevel3
                                    .insert(lastIndex + 1, phrase);
                              } else {
                                this.categoryLevel3.add(phrase);
                              }

                              List<String> tempCategoryLevel3 =
                                  this.categoryLevel3;
                              for (int x = 0;
                                  x < tempCategoryLevel3.length;
                                  x++) {
                                int pos = tempCategoryLevel3[x].indexOf("^^^");
                                if (pos < 0) continue;
                                tempCategoryLevel3[x].substring(pos + 3);
                              }

                              List<String> listCategory3 = [];

                              for (int x = 0;
                                  x < tempCategoryLevel3.length;
                                  x++) {
                                int pos = tempCategoryLevel3[x].indexOf("^^^");
                                if (pos < 0) continue;
                                listCategory3.add(
                                    tempCategoryLevel3[x].substring(pos + 3));
                              }

                              this.dropDownCategory3 =
                                  buildAndGetDropDownItems(listCategory3);
                              selectedCategory3 = listCategory3[0];

                              changeState(AddedToCategory3());
                            },
                            child: Text(
                              "הוספה",
                              style: TextStyle(color: Colors.white),
                            ),
                            //color: Colors.black,
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "ביטול",
                              style: TextStyle(color: Colors.white),
                            ),
                            //color: Colors.black,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  removeFromCategory1(String valueToRemove) async {
    if (valueToRemove == "הכל") return;
    String str = "";
    String codeRemovedCategory = "";

    List<String> tempCategoryLevel1 = [];
    for (int x = 0; x < this.categoryLevel1.length; x++) {
      str = this.categoryLevel1[x];

      if (str.indexOf(" ") == 0) {
        str = str.substring(1);
      } else if (str.indexOf("  ") == 0) {
        str = str.substring(2);
      }

      int pos = str.indexOf("^^^");
      if (pos < 0) continue;
      codeRemovedCategory = str.substring(0, pos);

      String name = str.substring(pos + 3);

      if (name != valueToRemove) {
        tempCategoryLevel1.add(this.categoryLevel1[x]);
      }
    }

    this.categoryLevel1 = tempCategoryLevel1;

    //going over categoryLevel2 and deleting the subcategories of the removed category from categoryLevel1
    String code = "";
    List<String> tempCategoryLevel2 = [];
    for (int x = 0; x < this.categoryLevel2.length; x++) {
      str = this.categoryLevel2[x];

      if (this.categoryLevel2[x].indexOf(" ") == 0) {
        this.categoryLevel2[x] = this.categoryLevel2[x].substring(1);
      } else if (this.categoryLevel2[x].indexOf("  ") == 0) {
        this.categoryLevel2[x] = this.categoryLevel2[x].substring(2);
      }

      int pos = str.indexOf("^^^");
      if (pos < 0) continue;
      code = str.substring(0, pos);

      String name = str.substring(pos + 3);

      if (codeRemovedCategory != code.substring(0, 3)) {
        tempCategoryLevel2.add(str);
      }
    }
    this.categoryLevel2 = tempCategoryLevel2;

    //going over categoryLevel3 and deleting the subcategories of the removed category from categoryLevel2
    List<String> tempCategoryLevel3 = [];

    for (int p = 0; p < this.categoryLevel3.length; p++) {
      str = this.categoryLevel3[p];

      int pos = str.indexOf("^^^");
      if (pos < 0) continue;

      String code = str.substring(0, pos);
      String name = str.substring(pos + 3);
      if (codeRemovedCategory != code.substring(0, 3)) {
        tempCategoryLevel3.add(str);
      }
    }
    this.categoryLevel3 = tempCategoryLevel3;

    List<String> listCategory1 = [];
    for (int x = 0; x < tempCategoryLevel1.length; x++) {
      String str = tempCategoryLevel1[x];
      int pos = str.indexOf("^^^");
      listCategory1.add(str.substring(pos + 3));
    }

    this.dropDownCategory1 = buildAndGetDropDownItems(listCategory1);
    selectedCategory1 = listCategory1[0];

    List<String> listCategory2 = [];
    for (int x = 0; x < tempCategoryLevel2.length; x++) {
      String str = tempCategoryLevel2[x];
      int pos = str.indexOf("^^^");
      listCategory2.add(str.substring(pos + 3));
    }

    this.dropDownCategory2 = buildAndGetDropDownItems(listCategory2);
    selectedCategory2 = listCategory2[0];

    List<String> listCategory3 = [];
    for (int x = 0; x < tempCategoryLevel3.length; x++) {
      String str = tempCategoryLevel3[x];
      int pos = str.indexOf("^^^");
      listCategory3.add(str.substring(pos + 3));
    }

    this.dropDownCategory3 = buildAndGetDropDownItems(listCategory3);
    selectedCategory3 = listCategory3[0];
    changeState(RemoveFromCategory1());
  }

  removeFromCategory2(String valueToRemove) async {
    if (valueToRemove == "הכל") return;
    String str = "";
    String codeRemovedCategory = "";
    //going over categoryLevel2 & locationg the category to be removed
    for (int p = 0; p < this.categoryLevel2.length; p++) {
      str = this.categoryLevel2[p];

      int pos = str.indexOf("^^^");
      if (pos < 0) continue;
      codeRemovedCategory = str.substring(0, pos);
      String name = str.substring(pos + 3);

      if (name == valueToRemove) {
        this.categoryLevel2.removeAt(p);
        break;
      }
    }

    //going over categoryLevel3 & locating the sub-categories to be removed
    List<String> tempCategoryLevel3 = [];

    for (int p = 0; p < this.categoryLevel3.length; p++) {
      String str = "";
      str = this.categoryLevel3[p];
      int pos = str.indexOf("^^^");
      if (pos < 0) continue;
      String code = str.substring(0, pos);
      String name = str.substring(pos + 1);
      if (codeRemovedCategory != code.substring(0, 6)) {
        tempCategoryLevel3.add(this.categoryLevel3[p]);
      }
    }
    this.categoryLevel3 = tempCategoryLevel3;

    List<String> tempCategoryLevel2 = [];
    for (int g = 0; g < this.categoryLevel2.length; g++) {
      String str = this.categoryLevel2[g];
      int pos = this.categoryLevel2[g].indexOf("^^^");
      if (pos < 0) continue;
      str = str.substring(pos + 3);
      tempCategoryLevel2.add(str);
    }

    this.dropDownCategory2 = buildAndGetDropDownItems(tempCategoryLevel2);
    selectedCategory2 = tempCategoryLevel2[0];

    for (int g = 0; g < this.categoryLevel3.length; g++) {
      String str = this.categoryLevel3[g];
      int pos = this.categoryLevel3[g].indexOf("^^^");
      if (pos < 0) continue;
      str = str.substring(pos + 3);
      tempCategoryLevel3.add(str);
    }

    this.dropDownCategory3 = buildAndGetDropDownItems(tempCategoryLevel3);
    selectedCategory3 = tempCategoryLevel3[0];
    changeState(RemoveFromCategory2());
  }

  removeFromCategory3(String valueToRemove) async {
    if (valueToRemove == "הכל") return;

    String str = "";
    List<String> tempCategoryLevel3 = [];
    List<String> listCategory3 = [];

    for (int h = 0; h < this.categoryLevel3.length; h++) {
      String str = this.categoryLevel3[h];
      int pos = str.indexOf("^^^");
      String name = str.substring(pos + 3);

      if (name != valueToRemove) {
        tempCategoryLevel3.add(name);
        listCategory3.add(this.categoryLevel3[h]);
      }
    }

    this.dropDownCategory3 = buildAndGetDropDownItems(tempCategoryLevel3);
    selectedCategory3 = tempCategoryLevel3[0];

    this.categoryLevel3 = listCategory3;
    changeState(RemoveFromCategory3());
  }

  retrieveSubcategories() async {
    String shopCategory = "";
    String shopID = await getStringDataLocally(key: 'shopID');
    List<String> tempCategoryLevel1 = [];

    //if this is an existing store
    /*if (shopID.length >= 16)*/ {
      FirebaseMethods appMethod = new FirebaseMethods();
      this.shopDetails = await appMethod.retrieveShopDetails(shopID);

      //populating  this.categoryLevel1 &  this.categoryLevel2 &  this.categoryLevel3
      String str = shopDetails[6];

      if (str != "[]") {
        int pos = str.indexOf("[");
        str = str.substring(pos + 1);
        pos = str.indexOf("]");
        str = str.substring(0, pos);
        tempCategoryLevel1 = str.split(",");
        this.categoryLevel1 = str.split(",");
        for (int x = 0; x < categoryLevel1.length; x++) {
          if (x > 0) categoryLevel1[x] = categoryLevel1[x].substring(1);
        }
      } else {
        this.categoryLevel1.add("000^^^הכל");
      }

      str = shopDetails[7];

      if (str != "[]") {
        int pos = str.indexOf("[");
        str = str.substring(pos + 1);
        pos = str.indexOf("]");
        str = str.substring(0, pos);
        this.categoryLevel2 = str.split(",");
        for (int x = 0; x < categoryLevel2.length; x++) {
          if (x > 0) categoryLevel2[x] = categoryLevel2[x].substring(1);
        }
      } else {
        this.categoryLevel2.add("000000^^^הכל");
      }

      str = shopDetails[8];
      if (str != "[]") {
        int pos = str.indexOf("[");
        str = str.substring(pos + 1);
        pos = str.indexOf("]");
        str = str.substring(0, pos);
        this.categoryLevel3 = str.split(",");
        for (int x = 0; x < categoryLevel3.length; x++) {
          if (x > 0) categoryLevel3[x] = categoryLevel3[x].substring(1);
        }
      } else {
        this.categoryLevel3.add("000000000^^^הכל");
      }

      for (int a = 0; a < tempCategoryLevel1.length; a++) {
        int pos = tempCategoryLevel1[a].indexOf("^^^");
        tempCategoryLevel1[a] = tempCategoryLevel1[a].substring(pos + 3);
      }

      if (tempCategoryLevel1.length > 0) {
        this.selectedCategory1 = tempCategoryLevel1[0];
        this.dropDownCategory1 = buildAndGetDropDownItems(tempCategoryLevel1);
      }

      changeState(RetrieveSubcategories());
    }
  }

  void changedDropDownCategory1(String argumentSelectedCategory) async {
    //if this is an existing store
    this.selectedCategory1 = argumentSelectedCategory;

    //going over this.categoryLevel1 & finding the code of the selected value
    String codeSelectedValueCategoryLevel1 = "";

    for (int i = 0; i < this.categoryLevel1.length; i++) {
      String temp = this.categoryLevel1[i];
      if (temp.indexOf(' ') == 0)
        temp = temp.substring(1);
      else if (temp.indexOf('  ') == 0) temp = temp.substring(2);

      int pos = temp.indexOf("^^^");

      codeSelectedValueCategoryLevel1 = temp.substring(0, pos);

      String name = temp.substring(pos + 3);
      if (name == argumentSelectedCategory) {
        break;
      }
    }

    FirebaseMethods appMethod = new FirebaseMethods();
    this.shopDetails = await appMethod.retrieveShopDetails(shopID);
    if (this.shopID != "noShop") {
      String str = shopDetails[7];

      int pos = str.indexOf("[");

      if (str != "[]") {
        str = str.substring(pos + 1);
        pos = str.indexOf("]");
        str = str.substring(0, pos);
        this.categoryLevel2 = str.split(",");
        for (int x = 0; x < this.categoryLevel2.length; x++) {
          if (this.categoryLevel2[x].indexOf(' ') == 0) {
            this.categoryLevel2[x] = this.categoryLevel2[x].substring(1);
          } else if (this.categoryLevel2[x].indexOf('  ') == 0) {
            this.categoryLevel2[x] = this.categoryLevel2[x].substring(2);
          }
        }
      }
    } else {
      if (argumentSelectedCategory == "סופרמרקטים") {
        this.categoryLevel2 = shopSupermarketCategoryLevel2;
      } else if (argumentSelectedCategory == "חומרי בניין") {
        this.categoryLevel2 = shopBuildingMaterialsCategoryLevel2;
      } else if (argumentSelectedCategory == "צעצועים") {
        this.categoryLevel2 = shopToysCategoryLevel2;
      } else if (argumentSelectedCategory == "אחר") {
        this.categoryLevel2 = [];
      }
    }

    //if there is already a shop
    //going over this.categoryLevel2 & gathering all the fields which have codes with first 3 digits like the selected value in this.categoryLevel1
    List<String> tempCategoryLevel2 = [];
    for (int i = 0; i < this.categoryLevel2.length; i++) {
      String temp = this.categoryLevel2[i];
      if (temp.indexOf(' ') == 0)
        temp = temp.substring(1);
      else if (temp.indexOf('  ') == 0) temp = temp.substring(2);

      int pos = temp.indexOf("^^^");
      if (pos < 0) continue;

      String code = temp.substring(0, pos);

      String name = temp.substring(pos + 3);

      if (code.substring(0, 3) == codeSelectedValueCategoryLevel1 ||
          code == "000000") {
        tempCategoryLevel2.add(name);
      }
    }

    if (tempCategoryLevel2.length > 0) {
      this.selectedCategory2 = tempCategoryLevel2[0];
      this.dropDownCategory2 = buildAndGetDropDownItems(tempCategoryLevel2);
      this.selectedCategory3 = "הכל";
      this.dropDownCategory3 = buildAndGetDropDownItems(["הכל"]);
    }
    changeState(ChangedDropDownCategory1());
  }

  void changedDropDownCategory2(String argumentSelectedCategory) async {
    //if this is an existing store
    this.selectedCategory2 = argumentSelectedCategory;

    //going over this.categoryLevel1 & finding the code of the selected value
    String codeSelectedValueCategoryLevel2 = "";
    for (int i = 0; i < this.categoryLevel2.length; i++) {
      String temp = this.categoryLevel2[i];
      if (temp.substring(0, 1) == " ")
        temp = temp.substring(1);
      else if (temp.substring(0, 2) == " ") temp = temp.substring(2);
      int pos = temp.indexOf("^^^");
      codeSelectedValueCategoryLevel2 = temp.substring(0, pos);

      String name = temp.substring(pos + 3);
      if (name == argumentSelectedCategory) {
        break;
      }
    }

    FirebaseMethods appMethod = new FirebaseMethods();
    this.shopDetails = await appMethod.retrieveShopDetails(shopID);
    if (this.shopID != "noShop") {
      String str = shopDetails[8];
      int pos = str.indexOf("[");
      str = str.substring(pos + 1);
      pos = str.indexOf("]");
      str = str.substring(0, pos);
      this.categoryLevel3 = str.split(",");
      for (int i = 0; i < this.categoryLevel3.length; i++) {
        if (this.categoryLevel3[i].indexOf("  ") == 0) {
          this.categoryLevel3[i] = this.categoryLevel3[i].substring(2);
        }
      }
    } else {
      if (argumentSelectedCategory == "סופרמרקטים") {
        this.categoryLevel3 = shopSupermarketCategoryLevel3;
      } else if (argumentSelectedCategory == "חומרי בניין") {
        this.categoryLevel3 = shopBuildingMaterialsCategoryLevel3;
      } else if (argumentSelectedCategory == "צעצועים") {
        this.categoryLevel3 = shopToysCategoryLevel3;
      } else if (argumentSelectedCategory == "אחר") {
        this.categoryLevel3 = shopOther3;
      }
    }

    for (int x = 0; x < this.categoryLevel3.length; x++) {
      if (this.categoryLevel3[x].indexOf(" ") == 0) {
        this.categoryLevel3[x] = this.categoryLevel3[x].substring(1);
      }
      if (this.categoryLevel3[x].indexOf("  ") == 0) {
        this.categoryLevel3[x] = this.categoryLevel3[x].substring(2);
      }
    }

    //if there is already a shop
    //going over this.categoryLevel2 & gathering all the fields which have codes with first 3 digits like the selected value in this.categoryLevel1
    List<String> tempCategoryLevel3 = [];

    for (int i = 0; i < this.categoryLevel3.length; i++) {
      String temp = this.categoryLevel3[i];
      int pos = temp.indexOf("^^^");
      if (pos < 0) continue;

      String code = temp.substring(0, pos);

      String name = temp.substring(pos + 3);

      if (code.substring(0, 6) == codeSelectedValueCategoryLevel2 ||
          code == "000000000") {
        tempCategoryLevel3.add(name);
      }
    }
    print(tempCategoryLevel3.toString());
    if (tempCategoryLevel3.length > 0) {
      this.selectedCategory3 = tempCategoryLevel3[0];
      this.dropDownCategory3 = buildAndGetDropDownItems(tempCategoryLevel3);
    }

    changeState(ChangedDropDownCategory2());
  }

  void changedDropDownCategory3(String argumentSelectedCategory) {
    selectedCategory3 = argumentSelectedCategory;
    changeState(ChangedDropDownCategory3());
  }

  retrieveShopDetails(String acctEmail) async {
    //this.acctEmail = "lior751@walla.com";
    this.acctEmail = acctEmail;
    if (this.shopID == null || this.shopID == "noShop" || this.shopID == "")
      isNewShop = true;

    var querySnapshot =
        await firebaseMethods.retrieveUserDetails(this.acctEmail);

    var a = querySnapshot[0].data;

    this.shopID = a['shopID'].toString();

    if (this.shopID == "noShop") {
      List<String> temp = [];

      for (int i = 0; i < shopCategories.length; i++) {
        temp.add(shopCategories[i]);
      }

      shopCategoriesList = buildAndGetDropDownItems(temp);

      this.selectedCategory = shopCategories[0];
    } else {
      querySnapshot = await firebaseMethods.retrieveShopDetails(shopID);

      for (int i = 0; i < shopCategories.length; i++) {
        String temp = shopCategories[i];
        categoryList.add(temp);
      }
      changeState(RetrieveShopDetails());

      this.selectedCategory = categoryList[0];
      shopCategoriesList = buildAndGetDropDownItems(categoryList);

      this.shopID = querySnapshot[0].toString();
      this.controllerFullName.text = querySnapshot[1].toString();
      this.controllerAddress.text = querySnapshot[2].toString();
      this.controllerEmail.text = querySnapshot[3].toString();
      this.controllerPhone.text = querySnapshot[4].toString();
      this.creditCardPaymentController.text = querySnapshot[9].toString();
      this.paypalPaymentController.text = querySnapshot[10].toString();
      writeDataLocally(key: "creditCards", value: querySnapshot[9].toString());
      writeDataLocally(key: "paypal", value: querySnapshot[10].toString());
    }
  }

  updateShopDetails(BuildContext context, String acctUserID) async {
    //no shop yet... We create a new shopID
    if (this.shopID == "") {
      int timeNow = new DateTime.now().microsecondsSinceEpoch;
      this.shopID = timeNow.toString();
    }

    if (this.controllerFullName.text == null ||
        this.controllerFullName.text.isEmpty) {
      showSnackBar("נא להכניס שם חנות", scaffoldKey);
      return;
    }

    if (this.controllerPhone.text == null ||
        this.controllerPhone.text.isEmpty) {
      showSnackBar("נא להכניס מספר טלפון", scaffoldKey);
      return;
    }

    if (this.controllerEmail.text == null ||
        this.controllerEmail.text.isEmpty) {
      showSnackBar("נא להכניס דואר אלקטרוני", scaffoldKey);
      return;
    }

    if (this.controllerAddress.text == null ||
        this.controllerAddress.text.isEmpty) {
      showSnackBar("נא להכניס את כתובת החנות", scaffoldKey);
      return;
    }

    if (this.selectedCategory == "בחירת קטגוריה") {
      showSnackBar("נא לבחור קטגוריה לחנות", scaffoldKey);
      return;
    }

    if (creditCardPaymentController.text.length > 0) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("אזהרה חשובה"),
        content: Text(
            " חשוב לשים לב ששם המשתמש שלך בסעיף סליקה בכרטיסי אשראי -  נכון"),
        actions: [
          okButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    //update the shopID filed for this user

    await firebaseMethods.updateUserShopId(this.acctUserID, this.shopID);

    List<String> tempCategoryLevel1 = this.categoryLevel1;
    if (tempCategoryLevel1.length == 0) tempCategoryLevel1.add("הכל");
    List<String> tempCategoryLevel2 = this.categoryLevel2;
    if (tempCategoryLevel2.length == 0) tempCategoryLevel2.add("הכל");
    List<String> tempCategoryLevel3 = this.categoryLevel3;
    if (tempCategoryLevel3.length == 0) tempCategoryLevel3.add("הכל");

    bool result = await firebaseMethods.updateShopDetails(
      this.shopID,
      controllerFullName.text,
      controllerAddress.text,
      controllerPhone.text,
      controllerEmail.text,
      this.acctUserID,
      paypalPaymentController.text,
      sendReceipt,
      creditCardPaymentController.text,
      this.selectedCategory,
      categoryLevel1,
      categoryLevel2,
      categoryLevel3,
    );

    if (result == true) {
      writeDataLocally(
          key: "paypal", value: paypalPaymentController.text.toString());
      writeDataLocally(
          key: "creditCards",
          value: creditCardPaymentController.text.toString());

      changeState(UpdateShopDetails());
    } else
      showSnackBar("העדכון נכשל. נא לנסות מאוחר יותר", scaffoldKey);
  }

  void changedDropDownCategory(String argumentSelectedCategory) {
    if (argumentSelectedCategory == "בחירת קטגוריה") {
      showSnackBar("נא לבחור קטגוריה", scaffoldKey);
      return;
    }

    if (this.shopID == "noShop") {
      if (argumentSelectedCategory == "סופרמרקטים") {
        List<String> tempCategoryLevel1 = ["הכל"];
        List<String> tempCategoryLevel2 = ["הכל"];
        List<String> tempCategoryLevel3 = ["הכל"];
        this.categoryLevel1 = shopSupermarketCategoryLevel1;
        this.categoryLevel2 = shopSupermarketCategoryLevel2;
        this.categoryLevel3 = shopSupermarketCategoryLevel3;
        this.dropDownCategory1 = buildAndGetDropDownItems(this.categoryLevel1);
        this.selectedCategory2 = tempCategoryLevel2[0];
        this.dropDownCategory2 = buildAndGetDropDownItems(tempCategoryLevel2);
        this.selectedCategory3 = tempCategoryLevel3[0];
        this.dropDownCategory3 = buildAndGetDropDownItems(tempCategoryLevel3);
      } else if (argumentSelectedCategory == "חומרי בניין") {
        List<String> tempCategoryLevel1 = ["הכל"];
        List<String> tempCategoryLevel2 = ["הכל"];
        List<String> tempCategoryLevel3 = ["הכל"];
        this.categoryLevel1 = shopBuildingMaterialsCategoryLevel1;
        this.categoryLevel2 = shopBuildingMaterialsCategoryLevel2;
        this.categoryLevel3 = shopBuildingMaterialsCategoryLevel3;
        this.dropDownCategory1 = buildAndGetDropDownItems(this.categoryLevel1);
        this.selectedCategory2 = tempCategoryLevel2[0];
        this.dropDownCategory2 = buildAndGetDropDownItems(tempCategoryLevel2);
        this.selectedCategory3 = tempCategoryLevel3[0];
        this.dropDownCategory3 = buildAndGetDropDownItems(tempCategoryLevel3);
      } else if (argumentSelectedCategory == "צעצועים") {
        List<String> tempCategoryLevel1 = ["הכל"];
        List<String> tempCategoryLevel2 = ["הכל"];
        List<String> tempCategoryLevel3 = ["הכל"];
        this.categoryLevel1 = shopToysCategoryLevel1;
        this.categoryLevel2 = shopToysCategoryLevel2;
        this.categoryLevel3 = shopToysCategoryLevel3;
        this.dropDownCategory1 = buildAndGetDropDownItems(this.categoryLevel1);
        this.selectedCategory2 = tempCategoryLevel2[0];
        this.dropDownCategory2 = buildAndGetDropDownItems(tempCategoryLevel2);
        this.selectedCategory3 = tempCategoryLevel3[0];
        this.dropDownCategory3 = buildAndGetDropDownItems(tempCategoryLevel3);
      } else {
        List<String> tempCategoryLevel1 = ["הכל"];
        List<String> tempCategoryLevel2 = ["הכל"];
        List<String> tempCategoryLevel3 = ["הכל"];
        this.categoryLevel1 = shopOther1;
        this.categoryLevel2 = shopOther2;
        this.categoryLevel3 = shopOther3;

        this.dropDownCategory1 = buildAndGetDropDownItems(tempCategoryLevel1);
        this.selectedCategory1 = tempCategoryLevel1[0];

        this.dropDownCategory2 = buildAndGetDropDownItems(tempCategoryLevel2);
        this.selectedCategory2 = tempCategoryLevel2[0];

        this.dropDownCategory3 = buildAndGetDropDownItems(tempCategoryLevel3);
        this.selectedCategory3 = tempCategoryLevel3[0];
      }
    }

    selectedCategory = argumentSelectedCategory;

    List<String> codePartCategory1 = [];
    List<String> namePartCategory1 = [];
    //going over categoryLevel1 & parsing it into codes & names
    for (int i = 0; i < this.categoryLevel1.length; i++) {
      String temp = this.categoryLevel1[i];
      int pos = temp.indexOf("^^^");
      if (pos < 0) continue;
      codePartCategory1.add(temp.substring(0, pos));
      namePartCategory1.add(temp.substring(pos + 3));
    }
    //only if there's an exisitng shop, we can populate categoryLevel1
    if (namePartCategory1.length > 0) {
      this.selectedCategory1 = namePartCategory1[0];
      this.dropDownCategory1 = buildAndGetDropDownItems(namePartCategory1);
    }
    changeState(ChangedDropDownCategory1());
  }
}
