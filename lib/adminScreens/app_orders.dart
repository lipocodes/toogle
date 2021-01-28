import 'package:Toogle/tools/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:Toogle/tools/app_tools.dart';
import 'package:Toogle/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Toogle/tools/app_tools.dart';

class AppOrders extends StatefulWidget {
  @override
  _AppOrdersState createState() => _AppOrdersState();
}

class _AppOrdersState extends State<AppOrders> {
  FirebaseMethods appMethod = new FirebaseMethods();
  List<List<String>> listAllOrders;
  List<String> listClientDetails;
  List<List<String>> listAllClients;
  int latestIndex = -1;
  int latestItem = -1;
  bool endOfOrder = false;
  List<String> tempList = [];
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DropdownMenuItem<String>> dropDownStatus;

  List<List<String>> itemsStatuses = [];
  List<String> itemStatus = [];
  List<String> statusList = new List();
  List<List<String>> itemStatuses = [];

  List<String> orderID = [];
  List<String> selectedStatus = [];
  List<String> dateOrders = [];
  String clientId = "";
  List<String> paymentMethods = [];

  getItemStatus(index, i) {
    List<String> list = this.listAllOrders[index];
    List<String> splitList = list[i].split("^^^");
    String itemStatus = splitList[5];
    print(itemStatus.toString());
  }

  retrieveOrders() async {
    // all the orders for this shop

    List<String> tempList = [];
    listAllOrders = await appMethod.retrieveOrders();

    listAllClients = [];
    for (int i = 0; i < listAllOrders.length; i++) {
      List<String> list = listAllOrders[i];

      var splitList = list[0].split("^^^");

      String clientId = splitList[0];

      this.statusList = [
        "בהמתנה לטיפול",
        "בטיפול",
        "נשלח ללקוח",
        "בוטל",
      ];

      listClientDetails = await appMethod.retrieveClientDetails(clientId);

      String temp1 = listClientDetails[4]
          .substring(1)
          .substring(0, listClientDetails[4].length - 2);

      List<String> temp2 = temp1.split(",");

      List<String> temp3 = temp2[i].split("^^^");

      this.orderID.add(temp3[1]);
    }

    for (int i = 0; i < listAllOrders.length; i++) {
      List<String> list = listAllOrders[i];
      var splitList = list[0].split("^^^");

      String clientId = splitList[0];

      this.statusList = [
        "בהמתנה לטיפול",
        "בטיפול",
        "נשלח ללקוח",
        "בוטל",
      ];

      //retrieve this client's details from DB
      listClientDetails = await appMethod.retrieveClientDetails(clientId);

      String temp1 = listClientDetails[4]
          .substring(1)
          .substring(0, listClientDetails[4].length - 2);

      List<String> temp2 = temp1.split(",");
      List<String> temp3 = temp2[i].split("^^^");

      this.orderID.add(temp3[1]);
      String dateCreation = temp3[2];
      String statusOrder = temp3[3];
      this.paymentMethods.add(temp3[4]);
      this.dateOrders.add(dateCreation);

      if (statusOrder == "בהמתנה לטיפול") {
        this.selectedStatus.add("בהמתנה לטיפול");
      } else if (statusOrder == "בטיפול") {
        this.selectedStatus.add("בטיפול");
      } else if (statusOrder == "נשלח ללקוח") {
        this.selectedStatus.add("נשלח ללקוח");
      } else if (statusOrder == "בוטל") {
        this.selectedStatus.add("בוטל");
      }

      listAllClients.add(listClientDetails);
    }

    setState(() {});
  }

  List<String> retrieveOrderDetails(int index, int i) {
    List<String> list = listAllOrders[index];

    var splitList = list[i].split("^^^");

    List<String> response = [
      splitList[0],
      splitList[1],
      splitList[2],
      splitList[3],
      splitList[4],
      splitList[5],
      splitList[6],
      splitList[7]
    ];

    return response;
  }

  void changedDropDownOrderStatus(r, index) async {
    List<String> t = this.listAllClients[index];

    String shopOrder = t[4];
    this.clientId = t[5];
    List<String> temp = shopOrder.split("^^^");

    List<String> newList = [];
    newList = t;

    this.selectedStatus[index] = r.toString();

    if (r == "בהמתנה לטיפול")
      r = 'בהמתנה לטיפול';
    else if (r == "בטיפול")
      r = "בטיפול";
    else if (r == "נשלח ללקוח")
      r = "נשלח ללקוח";
    else
      r = "בוטל";
    await appMethod.updateUserOrders(
        newList, this.clientId, r, this.orderID[index]);

    setState(() {});
  }

  removeOrder(int index) async {
    String email = await getStringDataLocally(key: userEmail);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("למחוק הזמנה"),
      onPressed: () async {
        displayProgressDialog(context);
        await appMethod.removeOrder(index, email).then((value) {
          closeProgressDialog(context);
          retrieveOrders();
        });
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("ביטול"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("מחיקת הזמנה"),
      content: Text("למחוק את ההזמנה?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.selectedStatus = [];
    retrieveOrders();
  }

  @override
  Widget build(BuildContext context) {
    if (this.listAllOrders == null || this.statusList == null)
      return Container();

    if (this.dropDownStatus == null) {
      this.dropDownStatus = buildAndGetDropDownItems(this.statusList);
    }
    this.dropDownStatus = buildAndGetDropDownItems(statusList);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: new Text(
            "הזמנות",
          ),
          centerTitle: false,
        ),
        body: ListView.separated(
          reverse: true,
          separatorBuilder: (context, index) => Divider(
            color: Colors.transparent,
          ),
          itemCount: this.listAllOrders.length,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "פרטי הלקוח",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          FlatButton(
                            child: Text('X',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w900)),
                            onPressed: () {
                              removeOrder(index);
                            },
                          ),
                        ],
                      ),
                      productsDropDown(
                          textTitle: "Item Status",
                          selectedItem: this.selectedStatus[index],
                          dropDownItems: this.dropDownStatus,
                          changedDropDownItems: (r) {
                            changedDropDownOrderStatus(r, index);
                          }),
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
                          Icon(Icons.payment),
                          if (this.paymentMethods[index] == "Phone")
                            Text("טלפון",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red)),
                          if (this.paymentMethods[index] == "Paypal")
                            Text("פייפאל",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red)),
                          if (this.paymentMethods[index] == "CreditCards")
                            Text("כרטיס אשראי",
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
                          Icon(Icons.person),
                          Text(this.listAllClients[index][0],
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
                            this.listAllClients[index][1],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          String num = this.listAllClients[index][2];
                          String url = "tel:" + num;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            Text(
                              this.listAllClients[index][2],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String num = "+972" +
                                    this.listAllClients[index][2].substring(1);
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
                                        this
                                            .listAllClients[index][2]
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
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.home),
                          Text(
                            this.listAllClients[index][3],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  for (int i = 0; i < listAllOrders[index].length; i++) ...[
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
                    Row(
                      children: [
                        //Icon(Icons.shopping_cart),
                        Text(
                          "קוד:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 20),
                        Text(
                          retrieveOrderDetails(index, i)[1],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //Icon(Icons.reorder),
                        Text(
                          "שם:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 20),
                        Text(
                          retrieveOrderDetails(index, i)[2],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //Icon(Icons.add_shopping_cart),
                        Text(
                          "מחיר המוצר",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 20),

                        Text(
                          retrieveOrderDetails(index, i)[5] + ' ש"ח',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //Icon(Icons.attach_money),
                        Text(
                          "מספר פריטים",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 20),
                        Text(
                          retrieveOrderDetails(index, i)[3],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //Icon(Icons.attach_money),
                        Text(
                          "הערות",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 20),
                        Text(
                          retrieveOrderDetails(index, i)[4],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("משקל:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        SizedBox(width: 20),
                        Text(
                          retrieveOrderDetails(index, i)[6],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent),
                        ),
                        Text(" ק'ג",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueAccent)),
                        SizedBox(width: 10),
                        Text(
                          "  ו " + retrieveOrderDetails(index, i)[7],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent),
                        ),
                        SizedBox(width: 10),
                        Text("גרם",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueAccent)),
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
