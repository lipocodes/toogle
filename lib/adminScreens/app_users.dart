import 'package:flutter/material.dart';

class AppUsers extends StatefulWidget {
  @override
  _AppUsersState createState() => _AppUsersState();
}

class _AppUsersState extends State<AppUsers> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("App Users",),
        centerTitle: false,
      ),
      body: new Center(
          child: new Text("App Users", style: TextStyle(fontSize: 25.0),)
      ),
    );
  }
}