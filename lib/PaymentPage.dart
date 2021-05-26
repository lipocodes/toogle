import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("מסך התשלום"),
      ),

      body: WebView(initialUrl: "https://google.com"),

    );

  }
}
