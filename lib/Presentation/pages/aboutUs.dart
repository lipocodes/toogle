import 'package:flutter/material.dart';

class ShopAboutUs extends StatefulWidget {
  @override
  _ShopAboutUsState createState() => _ShopAboutUsState();
}

class _ShopAboutUsState extends State<ShopAboutUs> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("About Us",),
        centerTitle: false,
      ),
      body: new Center(
          child: new Text("About the Shop", style: TextStyle(fontSize: 25.0),)
      ),
    );
  }
}


