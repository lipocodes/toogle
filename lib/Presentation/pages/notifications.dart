import 'package:flutter/material.dart';

class ShopNotifications extends StatefulWidget {
  @override
  _ShopNotificationsState createState() => _ShopNotificationsState();
}

class _ShopNotificationsState extends State<ShopNotifications> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Notifications",),
        centerTitle: false,
      ),
      body: new Center(
          child: new Text("My Notifications", style: TextStyle(fontSize: 25.0),)
      ),
    );
  }
}

