import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'app_orders.dart';
import 'app_products.dart';
import 'add_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:Toogle/Core/app_localizations.dart';
//import 'package:Toogle/tools/app_tools.dart';
import 'package:flutter_sms/flutter_sms.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String acctName = "";
  String acctEmail = "";
  // String acctPhone = "";
  Size screenSize;
  FirebaseMethods firebaseMethods = new FirebaseMethods();

  Future getCurrentUser() async {
    acctName = await getStringDataLocally(key: 'fullName');
    acctEmail = await getStringDataLocally(key: 'userEmail');
    //acctPhone = await getStringDataLocally(key: 'userPhone');

    setState(() {});
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: new Text(
            "ניהול",
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: new Column(children: <Widget>[
            new SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new AppOrders()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.notifications),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text("הזמנות"),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new AppProducts()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.shop),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text("מוצרים"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            new SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  new AddProducts()));
                        },
                        child: new CircleAvatar(
                          maxRadius: 70.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(Icons.add),
                              new SizedBox(
                                height: 10.0,
                              ),
                              new Text("הוספת מוצרים"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // new SizedBox(height: 20.0),
          ]),
        ),
      ),
    );
  }
}
