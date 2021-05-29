//import 'package:Toogle/tools/app_data.dart';
//import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:Toogle/tools/firebase_methods.dart';

//import '../tools/firebase_methods.dart';
import 'package:Toogle/Core/app_localizations.dart';

class UpdateProducts extends StatefulWidget {
  int index;
  String productId;
  UpdateProducts(this.index, this.productId);
  @override
  _UpdateProductsState createState() => _UpdateProductsState();
}

class _UpdateProductsState extends State<UpdateProducts> {
  List<DropdownMenuItem<String>> dropDownCategories;
  String selectedCategory;
  List<String> categoryList = new List();

  List<File> imageList;
  List<String> categoryLevel1 = [];
  List<String> categoryLevel2 = [];
  List<String> categoryLevel3 = [];

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
  List<String> listLevel2 = [];
  List<String> listLevel3 = [];
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
  List<String> shopDetails;

  TextEditingController productTitleController = new TextEditingController();
  TextEditingController productPriceController = new TextEditingController();
  TextEditingController productDescriptionController =
      new TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String productId = "";

  void changedDropDownCategory(String argumentSelectedCategory) {
    setState(() {
      selectedCategory = argumentSelectedCategory;
      print(selectedCategory);
    });
  }

  pickImage() async {
    this.showAlertDialog(context);
  }

  removeImage(int index) async {
    setState(() {
      imageList.removeAt(index);
    });
  }

  updateProducts() async {
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
      showSnackBar("תאור המוצר - חסר", scaffoldKey);
      return;
    }

    if (selectedCategory1 == "הכל") {
      showSnackBar("נא לבחור קטגוריה", scaffoldKey);
      return;
    }

//show the progress dialog
    displayProgressDialog(context);

    Map<String, dynamic> newProduct = {
      //productId: widget.productId,
      productTitle: productTitleController.text,
      productPrice: productPriceController.text,
      productDescription: productDescriptionController.text,
      'productCategory1': selectedCategory1,
      'productCategory2': selectedCategory2,
      'productCategory3': selectedCategory3,
      productRating: "0.0",
      'procductWeightKilos': this.selectedWeightKilos.toString(),
      'productWeightGrams': this.selectedWeightGrams.toString()
    };

//add the product's info to Firebase DB
    String productID;
    FirebaseMethods appMethod = new FirebaseMethods();
    try {
      productID = await appMethod.updateProduct(
          newProduct: newProduct, productId: widget.productId);
    } on PlatformException catch (e) {}

//upload the images to Firebase Storage
    List<String> imagesURL;
    try {
      imagesURL = await appMethod.uploadProductImages(
          docID: widget.productId, imageList: imageList);
    } on PlatformException catch (e) {
      closeProgressDialog(context);
      showSnackBar(
          "העלאת תמונה נכשלה ולכן לא ניתן להוסיף מוצר כרגע", scaffoldKey);
      return;
    }

    //update Firebase DB about the image list for the new product we have created now
    bool result = await appMethod.updateProductImages(
        docID: widget.productId, data: imagesURL);

    if (result == true) {
      closeProgressDialog(context);

      Navigator.of(context).pop();
    } else {
      closeProgressDialog(context);
      showSnackBar("לא ניתן להוסיף את המוצר כרגע", scaffoldKey);
    }

    retrieveProductSettings();
    //resetEverything();
  }

  void resetEverything() {
    setState(() {
      imageList.clear();
      productTitleController.text = "";
      productPriceController.text = "";
      productDescriptionController.text = "";
      selectedCategory = "Select a category";
    });
  }

  retrieveProductSettings() async {
    FirebaseMethods appMethod = new FirebaseMethods();
    var snapshot = await appMethod.retrieveProductSettings();

    this.imageList = [];

    this.selectedCategory1 =
        snapshot[widget.index]['productCategory1'].toString();
    this.selectedCategory2 =
        snapshot[widget.index]['productCategory2'].toString();
    this.selectedCategory3 =
        snapshot[widget.index]['productCategory3'].toString();

    List list2 = snapshot[widget.index]['productImages'];
    for (int i = 0; i < list2.length; i++) {
      this.imageList.add(File(list2[i]));
    }

    this.productId = snapshot[widget.index].data['productId'].toString();
    productTitleController.text =
        snapshot[widget.index].data['productTitle'].toString();
    productPriceController.text =
        snapshot[widget.index].data['productPrice'].toString();
    productDescriptionController.text =
        snapshot[widget.index].data['productDescription'].toString();
    selectedCategory =
        snapshot[widget.index].data['productCategory'].toString();

    String productWeightGrams =
        snapshot[widget.index].data['productWeightGrams'].toString();

    String productWeightKilos =
        snapshot[widget.index].data['procductWeightKilos'].toString();

    List<String> listValuesDropDown = [];

    for (int i = 0; i < shopSupermarketCategoryLevel1.length; i++) {
      listValuesDropDown.add(shopSupermarketCategoryLevel1[i]);
    }

    dropDownCategories = buildAndGetDropDownItems(listValuesDropDown);

    this.selectedWeightKilos = productWeightKilos;
    this.selectedWeightGrams = productWeightGrams;

    setState(() {});
  }

  retrieveSubcategories() async {
    String shopCategory = "";
    String shopID = await getStringDataLocally(key: 'shopID');
    FirebaseMethods appMethod = new FirebaseMethods();
    this.shopDetails = await appMethod.retrieveShopDetails(shopID);

    String temp = shopDetails[6];

    temp = temp.substring(1).substring(0, temp.length - 2);

    List<String> list = temp.split(",");
    for (int x = 1; x < list.length; x++) {
      list[x] = list[x].substring(1);
    }

    for (int a = 0; a < list.length; a++) {
      int pos = list[a].indexOf("^^^");
      list[a] = list[a].substring(pos + 3);
    }
    this.categoryLevel1 = list;
    this.dropDownCategory1 = buildAndGetDropDownItems(this.categoryLevel1);

    setState(() {});
  }

  void changedDropDownCategory1(String argumentSelectedCategory) {
    setState(() {
      this.selectedCategory3 = "הכל";
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

      //codeLevel1: the code of the selected item in Level1

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

      //changedDropDownCategory2("הכל");
    });
  }

  void changedDropDownCategory2(String argumentSelectedCategory) {
    setState(() {
      this.selectedCategory3 = "הכל";
      selectedCategory2 = argumentSelectedCategory;
      String codeLevel2 = "";

      //finding the code of the selected value in Level1
      String str = this.shopDetails[7];

      str = str.substring(0, str.length - 2);

      List<String> list = str.split(",");
      int a = 0;
      for (a = 0; a < list.length; a++) {
        list[a] = list[a].substring(1);
        int pos = list[a].indexOf("^^^");
        String name = list[a].substring(pos + 3);
        codeLevel2 = list[a].substring(0, pos);

        if (name == selectedCategory2) break;
      }
      //codeLevel1: the code of the selected item in Level1

      str = shopDetails[8];
      int pos = str.indexOf("[");
      str = str.substring(pos + 1);
      pos = str.indexOf("]");
      str = str.substring(0, pos);
      this.categoryLevel3 = str.split(",");
      this.listLevel3 = [];

      for (int a = 0; a < this.categoryLevel3.length; a++) {
        this.categoryLevel3[a] = this.categoryLevel3[a].substring(1);

        int pos = 0;
        String code = "";
        pos = this.categoryLevel3[a].indexOf("^^^");
        if (pos > 0) code = this.categoryLevel3[a].substring(0, 6);

        if (code != "" &&
            (code.substring(0, 6) == codeLevel2 ||
                code.substring(0, 6) == "000000")) {
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
      selectedCategory3 = argumentSelectedCategory;
    });
  }

  void changedDropDownWeightGrams(String argumentSelectedCategory) {
    setState(() {
      selectedWeightGrams = argumentSelectedCategory;
    });
  }

  void changedDropDownWeightKilos(String argumentSelectedCategory) {
    setState(() {
      selectedWeightKilos = argumentSelectedCategory;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveSubcategories();

    retrieveProductSettings();
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

  @override
  Widget build(BuildContext context) {
    if (this.imageList == null) return Container();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: new Text(
            "עדכון מוצר",
          ),
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
        ),
        body: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SizedBox(
                height: 10.0,
              ),
              multiImageList(
                  imageList: this.imageList,
                  removeNewImage: (index) {
                    removeImage(index);
                  }),
              new SizedBox(
                height: 10.0,
              ),
              productTextField(
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
                  textTitle: "קטגוריה ראשית",
                  selectedItem: this.selectedCategory1,
                  dropDownItems: this.dropDownCategory1,
                  changedDropDownItems: changedDropDownCategory1),
              productsDropDown(
                  textTitle: "קטגוריה משנית",
                  selectedItem: this.selectedCategory2,
                  dropDownItems: this.dropDownCategory2,
                  changedDropDownItems: changedDropDownCategory2),
              productsDropDown(
                  textTitle: "קטגוריה משנית-משנית",
                  selectedItem: this.selectedCategory3,
                  dropDownItems: this.dropDownCategory3,
                  changedDropDownItems: changedDropDownCategory3),
              SizedBox(height: 20.0),
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
                  btnTxt: "עדכון מוצר",
                  btnPadding: 20.0,
                  btnColor: Theme.of(context).primaryColor,
                  onBtnclicked: () => updateProducts()),
            ],
          ),
        ),
      ),
    );
  }
}
