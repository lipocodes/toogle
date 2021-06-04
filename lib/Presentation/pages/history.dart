import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Presentation/state_management/shopHistory_provider.dart/shopHistory_provider.dart';
import 'package:flutter/material.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:Toogle/Core/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:Toogle/tools/app_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopHistory extends StatefulWidget {
  @override
  _ShopHistoryState createState() => _ShopHistoryState();
}

class _ShopHistoryState extends State<ShopHistory> {
  //Widget section///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  Widget customAppBar() {
    return new AppBar(
      title: new Text("הזמנות"),
      centerTitle: false,
    );
  }

  Widget customBody(ShopHistoryProvider shopHistoryProvider) {
    var orderDetails;
    if (shopHistoryProvider.retrieveOrderHistoryYet != true) {
      shopHistoryProvider.retrieveOrderHistoryYet = true;
      orderDetails = shopHistoryProvider.retrieveShopsOrders();
    }

    return ListView.separated(
      controller: shopHistoryProvider.scrollController,
      reverse: true,
      separatorBuilder: (context, index) => Divider(
        color: Colors.transparent,
      ),
      itemCount: shopHistoryProvider.orderID.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "הזמנות",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("מספר הזמנה",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      SizedBox(width: 16),
                      Text(shopHistoryProvider.orderID[index],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.payment_sharp),
                      if (shopHistoryProvider.paymentMethods[index] == "Phone")
                        Text("טלפון - המוכר ייצור קשר לקבלת תשלום",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.red)),
                      if (shopHistoryProvider.paymentMethods[index] == "Paypal")
                        Text(
                            "פייפאל - נא לוודא שקיבלת אישור תשלום במייל מחברת פייפאל",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.red)),
                      if (shopHistoryProvider.paymentMethods[index] ==
                          "CreditCards")
                        Text(
                            "כרטיס אשראי - נא לוודא שקיבלת אישור תשלום במייל מחברת יופיי",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.red))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.date_range),
                      Text(shopHistoryProvider.dateOrders[index],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star),
                      if (shopHistoryProvider.selectedStatus[index] ==
                          "בהמתנה לטיפול") ...[
                        Text("בהמתנה לטיפול",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ] else if (shopHistoryProvider.selectedStatus[index] ==
                          "בטיפול") ...[
                        Text("בטיפול",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ] else if (shopHistoryProvider.selectedStatus[index] ==
                          "נשלח ללקוח") ...[
                        Text("נשלח ללקוח",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ] else if (shopHistoryProvider.selectedStatus[index] ==
                          "בוטל") ...[
                        Text("בוטל",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ]
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      Text(shopHistoryProvider.shopName[index],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.email),
                      Text(
                        shopHistoryProvider.shopEmail[index],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      GestureDetector(
                        onTap: () async {
                          String num = shopHistoryProvider.shopPhone[index];
                          String url = "tel:" + num;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text(
                          shopHistoryProvider.shopPhone[index],
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          String num = "+972" +
                              shopHistoryProvider.shopDetails[index][4]
                                  .substring(1);
                          var whatsappUrl = "whatsapp://send?phone=$num";
                          await canLaunch(whatsappUrl)
                              ? launch(whatsappUrl)
                              : print(
                                  "Whatsapp is not installed on this device!!!!!!");
                        },
                        child: Row(
                          children: [
                            IconButton(
                                icon: FaIcon(FontAwesomeIcons.whatsapp),
                                onPressed: () {
                                  //print("Pressed");
                                }),
                            Text(
                              "972" +
                                  shopHistoryProvider.shopPhone[index]
                                      .substring(1),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /*SizedBox(
                height: 30,
              ),
              for (int i = 0;
                  i < shopHistoryProvider.orderDetails[index].length;
                  i++) ...[
                Row(
                  children: [
                    Text(
                      "פריט מספר" + " " + (i + 1).toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    /*Icon(Icons.shopping_cart),*/ Text("קוד מוצר"),
                    SizedBox(width: 20),
                    Text(
                      shopHistoryProvider.getOrderDetails(index, i, 1),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    /*Icon(Icons.reorder),*/ Text("שם המוצר"),
                    SizedBox(width: 20),
                    Text(
                      shopHistoryProvider.getOrderDetails(index, i, 2),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    /*Icon(Icons.attach_money)*/ Text("מחיר המוצר"),
                    SizedBox(width: 20),
                    Text(
                      shopHistoryProvider.getOrderDetails(index, i, 5),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    /*Icon(Icons.add_shopping_cart),*/ Text("מספר הפריטים"),
                    SizedBox(width: 20),
                    Text(
                      shopHistoryProvider.getOrderDetails(index, i, 3),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    /*Icon(Icons.account_circle)*/ Text("הערות"),
                    SizedBox(width: 20),
                    Text(
                      shopHistoryProvider.getOrderDetails(index, i, 4),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (shopHistoryProvider.getOrderDetails(index, i, 6) !=
                        '0') ...[
                      Text(
                        " משקל:",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Text(
                        shopHistoryProvider.getOrderDetails(index, i, 6),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        " ק'ג",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                    SizedBox(width: 20),
                    if (shopHistoryProvider.getOrderDetails(index, i, 7) !=
                        '0') ...[
                      Text(
                        shopHistoryProvider.getOrderDetails(index, i, 7),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        " גרם",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ],
                ),
              ],*/
            ],
          ),
        ),
      ),
    );
  }

  //Method section////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopHistoryProvider>(
        builder: (context, shopHistoryProvider, child) {
      if (shopHistoryProvider.shopDetails == null ||
          shopHistoryProvider.orderDetails == null) {
        return Container();
      } else {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: WillPopScope(
            onWillPop: () {
              shopHistoryProvider.retrieveOrderHistoryYet = false;
              Navigator.pop(context);
              return null;
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: customAppBar(),
              body: customBody(shopHistoryProvider),
            ),
          ),
        );
      }
    });
  }
}
