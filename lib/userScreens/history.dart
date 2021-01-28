import 'package:flutter/material.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:Toogle/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Toogle/tools/app_tools.dart';

class ShopHistory extends StatefulWidget {
  @override
  _ShopHistoryState createState() => _ShopHistoryState();
}

class _ShopHistoryState extends State<ShopHistory> {
  FirebaseMethods appMethod = new FirebaseMethods();
  List<String> shopsOrders = [];
  String shopID = "";
  String localOrderID = "";
  String dateOrder = "";
  String statusOrder = "";
  List<List<String>> shopDetails = [];
  List<List<String>> orderDetails = [];
  List<String> listOrderDetails = [];
  List<String> list = [];
  List<String> orderID = [];
  List<String> selectedStatus = [];
  List<String> paymentMethods = [];
  List<String> dateOrders = [];
  ScrollController _scrollController = new ScrollController();

  retrieveShopsOrders() async {
    //displayProgressDialog(context);
    //retrieve the list of this user's orders & the shops where he has purchased from
    this.shopsOrders = await appMethod.retrieveShopsOrders();

    int len = this.shopsOrders == null ? 0 : this.shopsOrders.length;

    this.shopDetails = [];
    this.orderDetails = [];

    //going over the orderID^^^shopID list and creating list of the shopID & orderID
    for (int i = 0; i < len; i++) {
      List tempList = shopsOrders[i].split("^^^");

      this.shopID = tempList[0];
      this.shopID = this.shopID.replaceAll(' ', '');
      String localOrderID = tempList[1];
      this.orderID.add(localOrderID);

      this.dateOrders.add(tempList[2]);
      this.selectedStatus.add(tempList[3]);

      this.paymentMethods.add(tempList[4]);

      this.list = await appMethod.retrieveShopDetails(this.shopID);

      this.shopDetails.add(this.list);
      List<String> response =
          await appMethod.retreiveOrderDetails(this.shopID, localOrderID);

      this.orderDetails.add(response);
    }

    setState(() {});
  }

  getOrderDetails(int index, int i, int neededDatum) {
    String str = this.orderDetails[index][i].toString();

    List<String> list = str.split("^^^");

    return list[neededDatum];
  }

  removeOrder(int index) async {
    /*displayProgressDialog(context);
    await appMethod.removeOrder(index).then((value) {
      closeProgressDialog(context);
      retrieveOrders();
    });*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveShopsOrders();
  }

  @override
  Widget build(BuildContext context) {
    if (this.shopDetails == null || this.orderDetails == null)
      return Container();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: new AppBar(
          title: new Text("הזמנות"),
          centerTitle: false,
        ),
        body: ListView.separated(
          controller: _scrollController,
          reverse: true,
          separatorBuilder: (context, index) => Divider(
            color: Colors.transparent,
          ),
          itemCount: this.orderDetails.length,
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
                              fontSize: 22,
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
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                          SizedBox(width: 20),
                          Text(this.orderID[index],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.payment_sharp),
                          if (this.paymentMethods[index] == "Phone")
                            Text("טלפון - המוכר ייצור קשר לקבלת תשלום",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red)),
                          if (this.paymentMethods[index] == "Paypal")
                            Text(
                                "פייפאל - נא לוודא שקיבלת אישור תשלום במייל מחברת פייפאל",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red)),
                          if (this.paymentMethods[index] == "CreditCards")
                            Text(
                                "כרטיס אשראי - נא לוודא שקיבלת אישור תשלום במייל מחברת יופיי",
                                style: TextStyle(
                                    fontSize: 20,
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
                          Text(this.dateOrders[index],
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
                          if (this.selectedStatus[index] ==
                              "בהמתנה לטיפול") ...[
                            Text("בהמתנה לטיפול",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ] else if (this.selectedStatus[index] ==
                              "בטיפול") ...[
                            Text("בטיפול",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ] else if (this.selectedStatus[index] ==
                              "נשלח ללקוח") ...[
                            Text("נשלח ללקוח",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ] else if (this.selectedStatus[index] == "בוטל") ...[
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
                          Text(this.shopDetails[index][1],
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
                            this.shopDetails[index][2],
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
                          Icon(Icons.alternate_email),
                          Text(
                            this.shopDetails[index][3],
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
                              String num = this.shopDetails[index][4];
                              String url = "tel:" + num;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              this.shopDetails[index][4],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              String num = "+972" +
                                  this.shopDetails[index][4].substring(1);
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
                                      this.shopDetails[index][4].substring(1),
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
                  SizedBox(
                    height: 30,
                  ),
                  for (int i = 0; i < this.orderDetails[index].length; i++) ...[
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
                          this.getOrderDetails(index, i, 1),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /*Icon(Icons.reorder),*/ Text("שם המוצר"),
                        SizedBox(width: 20),
                        Text(
                          this.getOrderDetails(index, i, 2),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /*Icon(Icons.attach_money)*/ Text("מחיר המוצר"),
                        SizedBox(width: 20),
                        Text(
                          this.getOrderDetails(index, i, 5),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /*Icon(Icons.add_shopping_cart),*/ Text("מספר הפריטים"),
                        SizedBox(width: 20),
                        Text(
                          this.getOrderDetails(index, i, 3),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /*Icon(Icons.account_circle)*/ Text("הערות"),
                        SizedBox(width: 20),
                        Text(
                          this.getOrderDetails(index, i, 4),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (this.getOrderDetails(index, i, 6) != '0') ...[
                          Text(
                            " משקל:",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 20),
                          Text(
                            this.getOrderDetails(index, i, 6),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            " ק'ג",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                        SizedBox(width: 20),
                        if (this.getOrderDetails(index, i, 7) != '0') ...[
                          Text(
                            this.getOrderDetails(index, i, 7),
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
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
