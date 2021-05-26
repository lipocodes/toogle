import 'package:flutter/material.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import '../tools/firebase_methods.dart';
import 'package:Toogle/adminScreens/update_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:Toogle/app_localizations.dart';

class AppProducts extends StatefulWidget {
  @override
  _AppProductsState createState() => _AppProductsState();
}

class _AppProductsState extends State<AppProducts> {
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  var snapshot;

  retrieveProducts() async {
    this.snapshot = await firebaseMethods.retrieveProducts();
    //print("qqqqqqqqqqqqqqqq= " + snapshot.toString());
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot == null) return Container();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        appBar: AppBar(
          title: new Text(
            "עדכון מוצר",
          ),
          centerTitle: false,
        ),
        //body: listProducts(snapshot),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: snapshot.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new UpdateProducts(
                        index, snapshot[index].data['productId'].toString())));
                this.retrieveProducts();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(snapshot[index]
                                  .data['productImages'][0]
                                  .toString())))),
                  Text(
                    snapshot[index].data['productTitle'].toString().length < 20
                        ? snapshot[index].data['productTitle'].toString()
                        : snapshot[index]
                            .data['productTitle']
                            .toString()
                            .substring(0, 20),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                      onTap: () async {
                        FirebaseMethods firebaseMethods = new FirebaseMethods();
                        await firebaseMethods.removeProduct(index,
                            snapshot[index].data['productId'].toString());
                        this.retrieveProducts();
                        Navigator.pop(context);
                      },
                      child: Text("מחיקה",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              backgroundColor: Colors.grey))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
