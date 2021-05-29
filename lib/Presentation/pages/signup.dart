import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:flutter/material.dart';
//import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:flutter/services.dart';
import 'package:Toogle/Core/app_localizations.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController fullName = new TextEditingController();
  TextEditingController fullAddress = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController repeatPassword = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  FirebaseMethods firebaseMethod = new FirebaseMethods();

  //Widget section //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  Widget customAppBar() {
    return AppBar(
      title: new Text(
        "הרשמה",
      ),
      centerTitle: false,
      elevation: 0.0,
    );
  }

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
                textHint: "שם מלא",
                textIcon: new Icon(Icons.person),
                controller: fullName,
                textType: TextInputType.text),
            new SizedBox(height: 30.0),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "כתובת מלאה",
                textIcon: new Icon(Icons.home),
                controller: fullAddress,
                textType: TextInputType.text),
            new SizedBox(height: 30.0),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "מספר טלפון",
                textIcon: new Icon(Icons.phone),
                controller: phoneNumber,
                textType: TextInputType.phone),
            new SizedBox(height: 30.0),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "דואר אלקטרוני",
                textIcon: new Icon(Icons.email),
                controller: email,
                textType: TextInputType.emailAddress),
            new SizedBox(height: 30.0),
            appTextField(
                isPassword: true,
                sidePadding: 18.0,
                textHint: "סיסמא",
                textIcon: new Icon(Icons.lock),
                controller: password,
                textType: TextInputType.text),
            new SizedBox(height: 30.0),
            appTextField(
                isPassword: true,
                sidePadding: 18.0,
                textHint: "סיסמא שוב",
                textIcon: new Icon(Icons.lock),
                controller: repeatPassword,
                textType: TextInputType.text),
            new SizedBox(height: 10.0),
            appButton(
                btnTxt: "צור חשבון חדש",
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor,
                onBtnclicked: verifyDetails),
          ],
        ),
      ),
    );
  }

  //Method section ////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    this.context = context;

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: customAppBar(),
      body: customBody(),
    );
  }

  void verifyDetails() async {
    if (fullName.text == "") {
      showSnackBar("שם מלא -  חסר", scaffoldKey);
      return;
    }
    if (fullAddress.text == "") {
      showSnackBar("כתובת מלאה -  חסרה", scaffoldKey);
      return;
    } else if (phoneNumber.text == "") {
      showSnackBar("מספר טלפון - חסר", scaffoldKey);
      return;
    } else if (email.text == "") {
      showSnackBar("דואר אלקטרוני - חסר", scaffoldKey);
      return;
    } else if (password.text == "") {
      showSnackBar("סיסמא  - חסרה", scaffoldKey);
      return;
    } else if (password.text != repeatPassword.text) {
      showSnackBar("הסיסמאות צריכות להיות זהות", scaffoldKey);
      return;
    }

    displayProgressDialog(context);

    String response;
    try {
      response = await firebaseMethod.createUserAccount(
        fullName: fullName.text,
        fullAddress: fullAddress.text,
        phone: phoneNumber.text,
        email: email.text,
        password: password.text,
      );
      if (response == "failed") {
        showSnackBar("חשבון קיים עבור כתובת הדוא'ל הזו", scaffoldKey);
        closeProgressDialog(context);
        return;
      }
      if (response == "complete") {
        closeProgressDialog(context);
        Navigator.of(context).pop();
        showSnackBar("Congratulations, account created!", scaffoldKey);
      } else {
        closeProgressDialog(context);
        Navigator.of(context).pop();
        //showSnackBar(
        //"An account under this email  - already exists!", scaffoldKey);
      }
    } on PlatformException catch (e) {
      closeProgressDialog(context);
      print("eeeeeeeee=" + e.toString());
      Navigator.of(context).pop();
      showSnackBar("Account already exists!", scaffoldKey);
    }
  }
}
