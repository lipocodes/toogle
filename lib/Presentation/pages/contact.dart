import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Toogle/app_localizations.dart';

class Contact extends StatelessWidget {
  final valueName = TextEditingController();
  final valuePhone = TextEditingController();
  final valueEmail = TextEditingController();
  final valueText = TextEditingController();

  //Widget section//////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
  Widget customAppBar() {
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

  Widget customBody(BuildContext context) {
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
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextFormField(
              controller: valueName,
              decoration: new InputDecoration(
                labelText: "שם",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          new SizedBox(height: 10.0),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextFormField(
              keyboardType: TextInputType.number,
              controller: valuePhone,
              decoration: new InputDecoration(
                labelText: "טלפון",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          new SizedBox(height: 10.0),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextFormField(
              controller: valueEmail,
              decoration: new InputDecoration(
                labelText: "דואר אלקטרוני",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          new SizedBox(height: 10.0),
          new ListTile(
            leading: const Icon(Icons.text_fields),
            title: SingleChildScrollView(
              child: new TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: valueText,
                decoration: new InputDecoration(
                  labelText: "תוכן",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                child: new OutlineButton(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 0.0),
                  child: Text(
                    "שליחה",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    sendEmail(context);
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
    return SafeArea(
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(),
        body: customBody(context),
      ),
    );
  }

  sendEmail(BuildContext context) async {
    int pos = valueEmail.text.indexOf('@');
    String emailUser = valueEmail.text.substring(0, pos);
    String emailSupplier =
        valueEmail.text.substring(pos + 1, valueEmail.text.length - 4);

    String str = "Name: " +
        valueName.text +
        "    Phone: " +
        valuePhone.text +
        "    Email: " +
        emailUser +
        "  " +
        emailSupplier +
        "  Content: " +
        valueText.text;

    final String _email = 'mailto:' +
        'toogle.app@gmail.com' +
        '?subject=' +
        "User has just sent a message" +
        '&body=' +
        str;
    try {
      await launch(_email);
    } catch (e) {
      print('eeeeeeeeeeeeeeeeeeeeeeee ' + e.toString());
    } finally {
      Navigator.of(context).pop();
    }
  }
}
