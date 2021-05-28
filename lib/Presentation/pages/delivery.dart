import 'package:Toogle/tools/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/app_localizations.dart';

class ShopDelivery extends StatefulWidget {
  String acctEmail;
  ShopDelivery(this.acctEmail);
  @override
  _ShopDeliveryState createState() => _ShopDeliveryState();
}

class _ShopDeliveryState extends State<ShopDelivery> {
  TextEditingController controllerFullName = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerAddress = new TextEditingController();
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String userEmail = "";

  //Widget section///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  Widget customAppBar() {
    return new AppBar(
      title: new Text("פרטי הלקוח"),
      centerTitle: false,
    );
  }

  Widget customBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Text(
              "שם מלא",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            new TextField(
              controller: controllerFullName,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: "שם מלא",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "טלפון",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            new TextField(
              controller: controllerPhone,
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
            Text(
              "Email",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            new TextField(
              enabled: false,
              style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf)),
              controller: controllerEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "כתובת",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            new TextField(
              minLines: 2,
              maxLines: 2,
              controller: controllerAddress,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: "כתובת",
                prefixIcon: Icon(Icons.contact_mail),
              ),
            ),
            new SizedBox(height: 20.0),
            appButton(
                btnTxt: "עדכון פרטים",
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor,
                onBtnclicked: () => updateUserDetails()),
          ],
        ),
      ),
    );
  }

  //Method section///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: customAppBar(),
        body: customBody(),
      ),
    );
  }

  updateUserDetails() async {
    if (controllerFullName.text.length == 0) {
      showSnackBar("חסר שם", scaffoldKey);
      return;
    } else if (controllerPhone.text.length == 0) {
      showSnackBar("חסר טלפון", scaffoldKey);
      return;
    } else if (controllerAddress.text.length == 0) {
      showSnackBar("חסרה כתובת מלאה", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    bool result = await firebaseMethods.updateUserDetails(
        controllerFullName.text,
        controllerPhone.text,
        controllerEmail.text,
        controllerAddress.text);
    closeProgressDialog(context);
    if (result == true) {
      showSnackBar("Update Successful!", scaffoldKey);
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pop(context);
      });
    } else
      showSnackBar("Update failed.  Please try later!", scaffoldKey);
  }

  retrieveUserDetails() async {
    controllerFullName.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";
    controllerAddress.text = "";

    var snapshot = await firebaseMethods.retrieveUserDetails(widget.acctEmail);
    controllerFullName.text = snapshot[0].data['accountFullName'].toString();
    controllerPhone.text = snapshot[0].data['phoneNumber'].toString();
    controllerEmail.text = snapshot[0].data['userEmail'].toString();
    controllerAddress.text = snapshot[0].data['address'].toString();
  }
}
