//import 'package:Toogle/tools/app_data.dart';
//import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:random_string/random_string.dart';
import 'package:Toogle/Core/app_localizations.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  List<DropdownMenuItem<String>> dropDownColors;
  String selectedColor;
  List<String> colorList = new List();

  List<DropdownMenuItem<String>> dropDownSizes;
  String selectedSize;
  List<String> sizesList = new List();

  List<DropdownMenuItem<String>> dropDownCategories;
  String selectedCategory;
  List<String> categoryList = new List();

  List<String> shopCategoryLevel1 = [];
  List<String> shopCategoryLevel2 = [];
  List<String> shopCategoryLevel3 = [];

  String selectedCategory1 = "123456789";
  String selectedCategory2 = "123456789";
  String selectedCategory3 = "123456789";
  String selectedWeightGrams = "-1";
  String selectedWeightKilos = "-1";
  List<DropdownMenuItem<String>> dropDownCategory1;
  List<DropdownMenuItem<String>> dropDownCategory2;
  List<DropdownMenuItem<String>> dropDownCategory3;
  List<DropdownMenuItem<String>> dropDownWeightGrams;
  List<DropdownMenuItem<String>> dropDownWeightKilos;
  List<String> categoryLevel1 = [];
  List<String> categoryLevel2 = [];
  List<String> categoryLevel3 = [];
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
  List<String> listLevel2 = [];
  List<String> listLevel3 = [];

  List<String> shopDetails;

  List<File> imageList;
  String shopCategoryCode = "";

  TextEditingController productTitleController = new TextEditingController();
  TextEditingController productPriceController = new TextEditingController();
  TextEditingController productDescriptionController =
      new TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colorList = localColors;

    retrieveSubcategories();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: customAppBar(),
        body: customBody(),
      ),
    );
  }

  //Widget section///////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  Widget customAppBar() {
    return AppBar(
      title: new Text("הוספת מוצרים"),
      centerTitle: false,
      elevation: 0.0,
      actions: <Widget>[
        new Padding(
          padding: EdgeInsets.only(top: 10.0, right: 12.0, bottom: 10.0),
          child: new RaisedButton.icon(
            color: Colors.green,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
            ),
            onPressed: () {
              pickImage();
            },
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              "הוספת תמונות",
              style: new TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget customBody() {
    return new SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            height: 10.0,
          ),
          multiImageList(
              imageList: imageList,
              removeNewImage: (index) {
                removeImage(index);
              }),
          new SizedBox(
            height: 10.0,
          ),
          productTextField(
              maxLines: 1,
              textTitle: "שם המוצר",
              textHint: "שם המוצר",
              textType: TextInputType.text,
              controller: productTitleController),
          productTextField(
              textTitle: "מחיר המוצר",
              textHint: "מחיר המוצר",
              textType: TextInputType.number,
              controller: productPriceController),
          productTextField(
              textTitle: "תאור המוצר",
              textHint: "תאור המוצר",
              height: 180.0,
              textType: TextInputType.text,
              controller: productDescriptionController,
              maxLines: 4),
          SizedBox(height: 10.0),
          productsDropDown(
              textTitle: " קטגוריה ראשית",
              selectedItem: selectedCategory1,
              dropDownItems: dropDownCategory1,
              changedDropDownItems: changedDropDownCategory1),
          productsDropDown(
              textTitle: "קטגוריה משנית",
              selectedItem: selectedCategory2,
              dropDownItems: dropDownCategory2,
              changedDropDownItems: changedDropDownCategory2),
          productsDropDown(
              textTitle: "קטגוריה משנית משנית",
              selectedItem: selectedCategory3,
              dropDownItems: dropDownCategory3,
              changedDropDownItems: changedDropDownCategory3),
          SizedBox(height: 10.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                productsDropDown(
                    textTitle: "משקל בק'ג",
                    selectedItem: selectedWeightKilos,
                    dropDownItems: dropDownWeightKilos,
                    changedDropDownItems: changedDropDownWeightKilos),
                productsDropDown(
                    textTitle: "משקל בגרם",
                    selectedItem: selectedWeightGrams,
                    dropDownItems: dropDownWeightGrams,
                    changedDropDownItems: changedDropDownWeightGrams),
              ],
            ),
          ),
          new SizedBox(height: 20.0),
          appButton(
              btnTxt: "אישור",
              btnPadding: 20.0,
              btnColor: Theme.of(context).primaryColor,
              onBtnclicked: () => addNewProducts()),
        ],
      ),
    );
  }

  //Method section//////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  void changedDropDownColor(String argumentSelectedColor) {
    setState(() {
      selectedColor = argumentSelectedColor;
      print(selectedColor);
    });
  }

  void changedDropDownSize(String argumentSelectedSize) {
    setState(() {
      selectedSize = argumentSelectedSize;
      print(selectedSize);
    });
  }

  void changedDropDownCategory(String argumentSelectedCategory) {
    setState(() {
      selectedCategory = argumentSelectedCategory;
      print(selectedCategory);
    });
  }

  void changedDropDownCategory1(String argumentSelectedCategory) {
    setState(() {
      this.listLevel3 = ["הכל"];
      selectedCategory3 = "הכל";
      this.dropDownCategory3 = buildAndGetDropDownItems(this.listLevel3);

      selectedCategory1 = argumentSelectedCategory;
      String codeLevel1 = "";

      //finding the code of the selected value in Level1
      String str = this.shopDetails[6];

      str = str.substring(0, str.length - 2);

      List<String> list = str.split(",");

      for (int a = 0; a < list.length; a++) {
        list[a] = list[a].substring(1);
        int pos = list[a].indexOf("^^^");
        String name = list[a].substring(pos + 3);
        codeLevel1 = list[a].substring(0, pos);

        if (name == selectedCategory1) break;
      }

      //codeLevel2: the code of the selected item in Level1

      str = shopDetails[7];

      int pos = str.indexOf("[");
      str = str.substring(pos + 1);
      pos = str.indexOf("]");
      str = str.substring(0, pos);
      this.categoryLevel2 = str.split(",");

      this.listLevel2 = [];

      for (int a = 0; a < this.categoryLevel2.length; a++) {
        this.categoryLevel2[a] = this.categoryLevel2[a].substring(1);

        int pos = 0;
        String code = "";
        pos = this.categoryLevel2[a].indexOf("^^^");
        code = this.categoryLevel2[a].substring(0, 3);

        if (code.substring(0, 3) == codeLevel1 ||
            code.substring(0, 3) == "000") {
          int pos = this.categoryLevel2[a].indexOf("^^^");
          listLevel2.add(this.categoryLevel2[a].substring(pos + 3));
        }
      }

      this.selectedCategory2 = listLevel2[0];

      this.dropDownCategory2 = buildAndGetDropDownItems(listLevel2);
    });
  }

  void changedDropDownCategory2(String argumentSelectedCategory) {
    setState(() {
      selectedCategory2 = argumentSelectedCategory;
      String codeLevel2 = "";

      //finding the code of the selected value in Level1
      String str = this.shopDetails[7];

      str = str.substring(0, str.length - 2);

      List<String> list = str.split(",");

      for (int a = 0; a < list.length; a++) {
        list[a] = list[a].substring(1);
        int pos = list[a].indexOf("^^^");
        String name = list[a].substring(pos + 3);
        codeLevel2 = list[a].substring(0, pos);

        if (name == selectedCategory2) break;
      }

      //codeLevel2: the code of the selected item in Level1

      str = shopDetails[8];
      int pos = str.indexOf("[");
      str = str.substring(pos + 1);
      pos = str.indexOf("]");
      str = str.substring(0, pos);
      this.categoryLevel3 = str.split(",");
      this.listLevel3 = [];

      for (int a = 0; a < this.categoryLevel3.length; a++) {
        if (a > 0) this.categoryLevel3[a] = this.categoryLevel3[a].substring(1);

        int pos = 0;
        String code = "";
        pos = this.categoryLevel3[a].indexOf("^^^");
        if (pos < 0) continue;
        code = this.categoryLevel3[a].substring(0, pos);

        if (code.substring(0, 6) == codeLevel2 ||
            code.substring(0, 3) == "000") {
          int pos = this.categoryLevel3[a].indexOf("^^^");
          listLevel3.add(this.categoryLevel3[a].substring(pos + 3));
        }
      }

      this.selectedCategory3 = listLevel3[0];
      this.dropDownCategory3 = buildAndGetDropDownItems(listLevel3);
    });
  }

  void changedDropDownCategory3(String argumentSelectedCategory) {
    setState(() {
      this.selectedCategory3 = argumentSelectedCategory;
    });
  }

  void changedDropDownWeightGrams(String argumentSelectedCategory) {
    print(argumentSelectedCategory + " Grams");
    setState(() {
      selectedWeightGrams = argumentSelectedCategory;
    });
  }

  void changedDropDownWeightKilos(String argumentSelectedCategory) {
    print(argumentSelectedCategory + " Kilos");
    setState(() {
      selectedWeightKilos = argumentSelectedCategory;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget launchButton = FlatButton(
      child: Text("יציאה"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget remindButton = FlatButton(
      child: Text("גלריה"),
      onPressed: () async {
        File file = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          //imagesMap[imagesMap.length] = file;
          List<File> imageFile = new List();
          imageFile.add(file);
          //imageList = new List.from(imageFile);
          if (imageList == null) {
            imageList = new List.from(imageFile, growable: true);
          } else {
            if (this.imageList.length > 1) {
              showSnackBar("ניתן להעלות עד 3 תמונות!", scaffoldKey);
              return;
            }
            for (int s = 0; s < imageFile.length; s++) {
              imageList.add(file);
            }
          }
          setState(() {});
        }
        Navigator.pop(context);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("מצלמה"),
      onPressed: () async {
        File file = await ImagePicker.pickImage(source: ImageSource.camera);
        if (file != null) {
          //imagesMap[imagesMap.length] = file;
          List<File> imageFile = new List();
          imageFile.add(file);
          //imageList = new List.from(imageFile);
          if (imageList == null) {
            imageList = new List.from(imageFile, growable: true);
          } else {
            if (this.imageList.length > 1) {
              showSnackBar("ניתן להעלות עד 3 תמונות!", scaffoldKey);
              return;
            }
            for (int s = 0; s < imageFile.length; s++) {
              imageList.add(file);
            }
          }
          setState(() {});
        }
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Align(alignment: Alignment.center, child: Text("הוספת תמונה")),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(":מאיפה להוסיף תמונה"),
        ],
      ),
      actions: [
        remindButton,
        cancelButton,
        launchButton,
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

  pickImage() async {
    this.showAlertDialog(context);
  }

  removeImage(int index) async {
    setState(() {
      imageList.removeAt(index);
    });
  }

  addNewProducts() async {
    if (imageList == null || imageList.isEmpty) {
      showSnackBar("נא להעלות לפחות תמונה אחת", scaffoldKey);
      return;
    }

    if (productTitleController.text == "") {
      showSnackBar("שם המוצר - חסר", scaffoldKey);
      return;
    }
    if (productPriceController.text == "") {
      showSnackBar("מחיר המוצר - חסר", scaffoldKey);
      return;
    }
    if (productDescriptionController.text == "") {
      showSnackBar("תאור המוצר", scaffoldKey);
      return;
    }

    if (selectedCategory == "Select a category") {
      showSnackBar("נא לבחור קטגוריה", scaffoldKey);
      return;
    }

//show the progress dialog
    displayProgressDialog(context);

    String prodId = randomBetween(100000, 2000000).toString();

    Map<String, dynamic> newProduct = {
      productId: prodId,
      productPrice: productPriceController.text,
      productTitle: productTitleController.text,
      productDescription: productDescriptionController.text,
      'productCategory1': this.selectedCategory1,
      'productCategory2': this.selectedCategory2,
      'productCategory3': this.selectedCategory3,
      productRating: "0.0",
      'procductWeightKilos': this.selectedWeightKilos.toString(),
      'productWeightGrams': this.selectedWeightGrams.toString()
    };

//add the product's info to Firebase DB
    String productID;
    FirebaseMethods appMethod = new FirebaseMethods();
    try {
      productID = await appMethod.addNewProduct(newProduct: newProduct);
    } on PlatformException catch (e) {}

//upload the images to Firebase Storage
    List<String> imagesURL;
    try {
      imagesURL = await appMethod.uploadProductImages(
          docID: prodId, imageList: imageList);
    } on PlatformException catch (e) {
      closeProgressDialog(context);
      showSnackBar(
          "העלאת תמונה נכשלה ולכן לא ניתן להוסיף מוצר כרגע", scaffoldKey);
      return;
    }

    //update Firebase DB about the image list for the new product we have created now
    bool result =
        await appMethod.updateProductImages(docID: prodId, data: imagesURL);

    if (result == true) {
      closeProgressDialog(context);

      Navigator.of(context).pop();
    } else {
      closeProgressDialog(context);
      showSnackBar("לא ניתן להוסיף את המוצר כרגע", scaffoldKey);
    }
  }

  void resetEverything() {
    setState(() {
      imageList.clear();
      productTitleController.text = "";
      productPriceController.text = "";
      productDescriptionController.text = "";
      selectedCategory = "Select a category";
      selectedColor = "Select a color";
      selectedSize = "Select a size";
    });
  }

  retrieveSubcategories() async {
    String shopCategory = "";
    String shopID = await getStringDataLocally(key: 'shopID');
    FirebaseMethods appMethod = new FirebaseMethods();
    this.shopDetails = await appMethod.retrieveShopDetails(shopID);

    String str = shopDetails[6];
    int pos = str.indexOf("[");
    str = str.substring(pos + 1);
    pos = str.indexOf("]");
    str = str.substring(0, pos);
    this.categoryLevel1 = str.split(",");
    for (int a = 0; a < this.categoryLevel1.length; a++) {
      int pos = this.categoryLevel1[a].indexOf("^^^");
      this.categoryLevel1[a] = this.categoryLevel1[a].substring(pos + 3);
    }
    this.selectedCategory1 = this.categoryLevel1[0];
    this.dropDownCategory1 = buildAndGetDropDownItems(this.categoryLevel1);

    this.selectedWeightGrams = this.categoryWeightGrams[0];
    this.selectedWeightKilos = this.categoryWeightKilos[0];
    this.dropDownWeightGrams =
        buildAndGetDropDownItems(this.categoryWeightGrams);
    this.dropDownWeightKilos =
        buildAndGetDropDownItems(this.categoryWeightKilos);

    setState(() {});
  }
}
