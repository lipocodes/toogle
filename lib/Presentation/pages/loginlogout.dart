//import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:Toogle/Core/app_localizations.dart';
//import 'package:Toogle/tools/app_data.dart';

class ShopLogin extends StatefulWidget {
  @override
  _ShopLoginState createState() => _ShopLoginState();
}

class _ShopLoginState extends State<ShopLogin> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController repeatPassword = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  FirebaseMethods firebaseMethod = new FirebaseMethods();

//Widget section/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
  Widget customBody() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new SizedBox(height: 30.0),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "דואר אלקטרוני",
                textIcon: new Icon(Icons.email),
                controller: email),
            new SizedBox(height: 30.0),
            appTextField(
                isPassword: true,
                sidePadding: 18.0,
                textHint: "סיסמא",
                textIcon: new Icon(Icons.lock),
                controller: password),
            new SizedBox(height: 10.0),
            appButton(
                btnTxt: "כניסה",
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor,
                onBtnclicked: verifyLogin),
            new SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => Signup()));
              },
              child: new Text("עדיין לא רשום? לחץ כאן",
                  style: new TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

//method section////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    this.context = context;

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: new Text(
          "כניסה",
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: customBody(),
    );
  }

  void verifyLogin() async {
    if (email.text == "") {
      showSnackBar("דואר אלקטרוני - חסר", scaffoldKey);
      return;
    } else if (password.text == "") {
      showSnackBar("סיסמא  - חסרה", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    bool response = false;
    try {
      response = await firebaseMethod.loginUser(
          email: email.text, password: password.text);
    } catch (e) {
      response = false;
    }

    if (response == true) {
      closeProgressDialog(context);
      String shopId = await getStringDataLocally(key: shopID);
      //if this user owns a shop, redirect him to the shop
      if (shopId.length > 0) {
        Navigator.of(context).pop(shopId);
      }
      Navigator.of(context).pop("true");
    } else {
      closeProgressDialog(context);
      email.text = "";
      password.text = "";
      showSnackBar("שם משתמש או סיסמא - לא", scaffoldKey);
      await firebaseMethod.loginUser(
          email: "guest@gmail.com", password: "123456");
      return;
    }
  }
}
