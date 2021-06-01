//import 'package:Toogle/tools/app_data.dart';
import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/state_management/createEditShop_provider/createEditShop_state.dart';
import 'package:Toogle/Presentation/state_management/createEditShop_provider/create_edit_shop_provider.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:Toogle/tools/app_tools.dart';
//import 'package:Toogle/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';

class CreateEditShop extends StatelessWidget {
  String acctEmail = "";
  String acctUserID = "";

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  CreateEditShop({this.acctEmail, this.acctUserID});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateEditShopProvider>(
        builder: (context, createEditShopProvider, child) {
      if (createEditShopProvider.state == UpdateShopDetails()) {
        Navigator.pop(context);
      }
      return SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: new Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).primaryColor,
            resizeToAvoidBottomInset: false,
            appBar: customAppBar(),
            body: customBody(context, createEditShopProvider),
          ),
        ),
      );
    });
  }
}

Widget customAppBar() {
  return new AppBar(
    title: new Text("יצירה / עדכון חנות"),
    centerTitle: false,
  );
}

Widget customBody(
    BuildContext context, CreateEditShopProvider createEditShopProvider) {
  if (createEditShopProvider.retrievedShopDetailsYet == false) {
    createEditShopProvider.retrievedShopDetailsYet = true;
    createEditShopProvider.retrieveShopDetails();
    createEditShopProvider.retrieveSubcategories();
  }

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                createEditShopProvider.shopID == "noShop"
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "כתובת החנות עבור הלקוחות:",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),

                          //SizedBox(width: 20),
                          RaisedButton(
                            //     disabledColor: Colors.red,
                            // disabledTextColor: Colors.black,
                            padding: const EdgeInsets.all(5),
                            textColor: Colors.blueAccent,
                            color: Colors.white,
                            onPressed: () {
                              FlutterClipboard.copy("https://www.6yamim.xyz/#/")
                                  .then((value) => print('xxxxxxxxxxxxxxxxx'));
                            },
                            child: Text('להעתיק כתובת'),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 10,
                ),
                Text("חנות מספר" + "  " + createEditShopProvider.shopID,
                    style: TextStyle(fontSize: 14)),
                SizedBox(width: 50.0),
                createEditShopProvider.shopID == "noShop"
                    ? Container()
                    : InkWell(
                        child: SelectableText(
                          "https://www.6yamim.xyz/#/",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () => launch("https://www.6yamim.xyz/#/")),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                "*",
                style: TextStyle(color: Colors.red, fontSize: 22),
              ),
              SizedBox(width: 10.0),
              Text(
                "שם החנות",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          new TextField(
            controller: createEditShopProvider.controllerFullName,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: "שם החנות",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                "*",
                style: TextStyle(color: Colors.red, fontSize: 22),
              ),
              SizedBox(width: 10.0),
              Text(
                "טלפון",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          new TextField(
            controller: createEditShopProvider.controllerPhone,
            keyboardType: TextInputType.phone,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: "טלפון",
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                "*",
                style: TextStyle(color: Colors.red, fontSize: 22),
              ),
              SizedBox(width: 10.0),
              Text(
                "דואר אלקטרוני",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          new TextField(
            controller: createEditShopProvider.controllerEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: "דואר אלקטרוני",
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                "*",
                style: TextStyle(color: Colors.red, fontSize: 22),
              ),
              SizedBox(width: 10.0),
              Text(
                "כתובת",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          new TextField(
            minLines: 2,
            maxLines: 2,
            controller: createEditShopProvider.controllerAddress,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: "כתובת",
              prefixIcon: Icon(Icons.contact_mail),
            ),
          ),
          //if no shop yet & no shop category selected yet
          if (createEditShopProvider.shopID == "noShop") ...[
            Row(
              children: [
                new SizedBox(height: 10.0),
                Text(
                  "*",
                  style: TextStyle(color: Colors.red, fontSize: 22),
                ),
                productsDropDown(
                    textTitle: "קטגוריה",
                    selectedItem: createEditShopProvider.selectedCategory,
                    dropDownItems: createEditShopProvider.shopCategoriesList,
                    changedDropDownItems:
                        createEditShopProvider.changedDropDownCategory),
              ],
            )
          ],
          new SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "בניית עץ קטגוריות עבור החנות",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          new SizedBox(height: 10.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  productsDropDown(
                      textTitle: "קטגוריה ראשית",
                      selectedItem: createEditShopProvider.selectedCategory1,
                      dropDownItems: createEditShopProvider.dropDownCategory1,
                      changedDropDownItems:
                          createEditShopProvider.changedDropDownCategory1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.black,
                        child: Text("הוספה"),
                        onPressed: () {
                          createEditShopProvider.addToCategory1(context);
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.black,
                        child: Text("מחיקה"),
                        onPressed: () {
                          createEditShopProvider.removeFromCategory1(
                              createEditShopProvider.selectedCategory1);
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          productsDropDown(
                              textTitle: "קטגוריה משנית",
                              selectedItem:
                                  createEditShopProvider.selectedCategory2,
                              dropDownItems:
                                  createEditShopProvider.dropDownCategory2,
                              changedDropDownItems: createEditShopProvider
                                  .changedDropDownCategory2),
                          if (createEditShopProvider.selectedCategory1 !=
                                  "123456789" &&
                              createEditShopProvider.selectedCategory1 !=
                                  "הכל") ...[
                            Row(
                              children: [
                                RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.black,
                                  child: Text("הוספה"),
                                  onPressed: () {
                                    createEditShopProvider
                                        .addToCategory2(context);
                                  },
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                  ),
                                ),
                                RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.black,
                                  child: Text("מחיקה"),
                                  onPressed: () {
                                    createEditShopProvider.removeFromCategory2(
                                        createEditShopProvider
                                            .selectedCategory2);
                                  },
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      productsDropDown(
                          textTitle: "קטגוריה תת-משנית",
                          selectedItem:
                              createEditShopProvider.selectedCategory3,
                          dropDownItems:
                              createEditShopProvider.dropDownCategory3,
                          changedDropDownItems:
                              createEditShopProvider.changedDropDownCategory3),
                      if (createEditShopProvider.selectedCategory2 !=
                              "123456789" &&
                          createEditShopProvider.selectedCategory2 !=
                              "הכל") ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              textColor: Colors.white,
                              color: Colors.black,
                              child: Text("הוספה"),
                              onPressed: () {
                                createEditShopProvider.addToCategory3(context);
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                            ),
                            RaisedButton(
                              textColor: Colors.white,
                              color: Colors.black,
                              child: Text("מחיקה"),
                              onPressed: () {
                                createEditShopProvider.removeFromCategory3(
                                    createEditShopProvider.selectedCategory3);
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),

          new SizedBox(height: 60.0),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                        title: new Text("תשלום באמצעות פייפאל"),
                        content: new Text(
                            "כדי לקבל תשלומים באמצעות פייפאל,  צריך להזין בתיבה שמתחת את שם המשתמש בפייפאל"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("סגור"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
            },
            child: Center(
              child: Column(
                children: [
                  Text("הסבר: תשלום בפייפאל",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          Text(
            "חשבון פייפאל",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          new TextField(
            minLines: 1,
            maxLines: 1,
            controller: createEditShopProvider.paypalPaymentController,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: "חשבון פייפאל",
              prefixIcon: Icon(Icons.contact_mail),
            ),
          ),
          new SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                        title: new Text("create_edit_dialog_title_credit_card"),
                        content: Container(
                          height: 200,
                          child: Column(
                            children: [
                              new Text(
                                  "על מנת לקבל תשלומים באמצעות כרטיסי אשראי, עליך ליצור חשבון באתר הבא. לאחר אישור החשבון, פשוט הכנס את שם המשתמש שלך בתיבה למטה."),
                              GestureDetector(
                                  child: Text("יצירת חשבון",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue)),
                                  onTap: () async {
                                    await launch(
                                      "https://app.upay.co.il/API6/clientsecure/interface.php?minoraction=signup",
                                      forceSafariVC: false,
                                    );
                                  })
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("סגור"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
            },
            child: Center(
              child: Column(
                children: [
                  Text("הסבר: תשלום בכרטיסי אשראי",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),

          Text(
            "דף סליקה - כרטיסי אשראי",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          new TextField(
            minLines: 1,
            maxLines: 1,
            controller: createEditShopProvider.creditCardPaymentController,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: "דף סליקה - כרטיסי אשראי",
              prefixIcon: Icon(Icons.contact_mail),
            ),
          ),
          new SizedBox(height: 20.0),
          createEditShopProvider.enableUpdateStoreButton == true
              ? appButton(
                  btnTxt: "עדכון פרטים",
                  btnPadding: 20.0,
                  btnColor: Theme.of(context).primaryColor,
                  onBtnclicked: () =>
                      createEditShopProvider.updateShopDetails(context))
              : Container(),
        ],
      ),
    ),
  );
}
