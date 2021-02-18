import 'dart:convert';

import 'package:flutter/material.dart';
import 'userScreens/myHomePage.dart';
import 'userScreens/counter_page.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';
import 'userScreens/contact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: MyHomePage(),
      //home:CounterPage(),
    );
  }
}
