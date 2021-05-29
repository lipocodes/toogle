import 'dart:convert';
import 'package:Toogle/Presentation/pages/contact.dart';
import 'package:Toogle/Presentation/pages/myHomePage.dart';
import 'package:Toogle/Presentation/state_management/contact_provider/contact_provider.dart';
import 'package:Toogle/Presentation/state_management/myHomePage_provider/myHomePage_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'Presentation/pages/loginlogout.dart';
import 'Presentation/state_management/user_provider/user_provider.dart';
//import 'userScreens/myHomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ContactProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          //'/': (BuildContext context) => MyHomePage(),
          '/contact': (BuildContext context) => Contact(),
        },
        home: MyHomePage(),
      ),
    );
  }
}
