import 'package:Toogle/Presentation/state_management/contact_provider/contact_provider.dart';
import 'package:Toogle/Presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Toogle/Core/app_localizations.dart';

class Contact extends StatelessWidget {
  //Widget section//////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
  Widget customAppBar(ContactProvider contactProvider) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: new Text(
        "",
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget customBody(BuildContext context, ContactProvider contactProvider) {
    //var prov = Provider.of<ContactProvider>(context);
    print("pppppppppppppppppp=" + contactProvider.state.toString());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(
            "יצירת קשר",
            style: new TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900),
          ),
          new SizedBox(
            height: 20.0,
          ),
          customListTile(
              icon: Icon(Icons.person),
              textInputType: TextInputType.text,
              maxLines: 1,
              controller: contactProvider.valueName,
              labelText: "שם"),
          new SizedBox(height: 10.0),
          customListTile(
              icon: Icon(Icons.phone),
              textInputType: TextInputType.phone,
              maxLines: 1,
              controller: contactProvider.valuePhone,
              labelText: "טלפון"),
          new SizedBox(height: 10.0),
          customListTile(
              icon: Icon(Icons.email),
              textInputType: TextInputType.emailAddress,
              maxLines: 1,
              controller: contactProvider.valueEmail,
              labelText: "דואר אלקטרוני"),
          new SizedBox(height: 10.0),
          customListTile(
              icon: Icon(Icons.text_fields),
              textInputType: TextInputType.multiline,
              maxLines: 5,
              controller: contactProvider.valueText,
              labelText: "תוכן"),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 20.0, right: 50.0),
            child: Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFB3F5FC),
                      Color(0xFF81D4FA),
                      Color(0xFF29B6F6),
                    ],
                  ),
                ),
                child: new OutlinedButton(
                  child: Text(
                    "שליחה",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    contactProvider.sendEmail(context);
                  },
                )),
          ),
        ],
      ),
    );
  }

  //Method section//////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
      return SafeArea(
        child: new Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppBar(contactProvider),
          body: customBody(context, contactProvider),
        ),
      );
    });
  }
}
