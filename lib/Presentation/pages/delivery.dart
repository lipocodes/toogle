import 'package:Toogle/Presentation/state_management/delivery_provider/delivery_provider.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:Toogle/tools/app_tools.dart';
//import 'package:Toogle/app_localizations.dart';

class ShopDelivery extends StatefulWidget {
  String acctEmail;
  ShopDelivery({this.acctEmail});
  @override
  _ShopDeliveryState createState() => _ShopDeliveryState();
}

class _ShopDeliveryState extends State<ShopDelivery> {
  //Widget section///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  Widget customAppBar() {
    return new AppBar(
      title: new Text("פרטי הלקוח"),
      centerTitle: false,
    );
  }

  Widget customBody() {
    var prov = Provider.of<DeliveryProvider>(context);
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
              controller: prov.controllerFullName,
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
              controller: prov.controllerPhone,
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
              controller: prov.controllerEmail,
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
              controller: prov.controllerAddress,
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
                onBtnclicked: () => prov.updateUserDetails(context)),
          ],
        ),
      ),
    );
  }

  //Method section///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  /*@override
  void initState() {
    var prov = Provider.of<DeliveryProvider>(context);
    // TODO: implement initState
    super.initState();
    prov.retrieveUserDetails();
  }*/

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<DeliveryProvider>(context);
    prov.retrieveUserDetails();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: prov.scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: customAppBar(),
        body: customBody(),
      ),
    );
  }
}
