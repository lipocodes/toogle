import 'package:Toogle/Presentation/state_management/delivery_provider/delivery_provider.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:Toogle/Presentation/widgets/widgets.dart';
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

  Widget customBody(DeliveryProvider deliveryProvider) {
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
            customTextField(
              controller: deliveryProvider.controllerFullName,
              enabled: true,
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.text,
              filled: true,
              fillColor: Colors.white,
              inputBorder: InputBorder.none,
              hintText: "שם מלא",
              prefixIcon: Icon(Icons.person),
            ),
            SizedBox(height: 20.0),
            Text(
              "טלפון",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            customTextField(
              controller: deliveryProvider.controllerPhone,
              enabled: true,
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.phone,
              filled: true,
              fillColor: Colors.white,
              inputBorder: InputBorder.none,
              hintText: "טלפון",
              prefixIcon: Icon(Icons.phone),
            ),
            SizedBox(height: 20.0),
            Text(
              "Email",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            customTextField(
              enabled: false,
              minLines: 1,
              maxLines: 2,
              style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf)),
              controller: deliveryProvider.controllerEmail,
              keyboardType: TextInputType.emailAddress,
              filled: true,
              fillColor: Colors.white,
              inputBorder: InputBorder.none,
              hintText: "דוא'ל",
              prefixIcon: Icon(Icons.email),
            ),
            SizedBox(height: 20.0),
            Text(
              "כתובת",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            customTextField(
              enabled: true,
              minLines: 1,
              maxLines: 2,
              controller: deliveryProvider.controllerAddress,
              keyboardType: TextInputType.text,
              filled: true,
              fillColor: Colors.white,
              inputBorder: InputBorder.none,
              hintText: "כתובת",
              prefixIcon: Icon(Icons.contact_mail),
            ),
            new SizedBox(height: 20.0),
            appButton(
                btnTxt: "עדכון פרטים",
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor,
                onBtnclicked: () =>
                    deliveryProvider.updateUserDetails(context)),
          ],
        ),
      ),
    );
  }

  //Method section///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    bool retrievedUserDetailsYet = false;
    var prov = Provider.of<DeliveryProvider>(context);

    // prov.retrieveUserDetails(widget.acctEmail);
    return Consumer<DeliveryProvider>(
        builder: (context, deliveryProvider, child) {
      if (retrievedUserDetailsYet == false) {
        deliveryProvider.retrieveUserDetails(widget.acctEmail);
        retrievedUserDetailsYet = true;
      }

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: prov.scaffoldKey,
          backgroundColor: Theme.of(context).primaryColor,
          appBar: customAppBar(),
          body: customBody(deliveryProvider),
        ),
      );
    });
  }
}
