import 'dart:convert';
import 'package:Toogle/Presentation/pages/myHomePage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'Presentation/state_management/user_provider/user_provider.dart';
//import 'userScreens/myHomePage.dart';

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
      home: MultiProvider(providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
      ], child: MyHomePage()),
    );
  }
}
