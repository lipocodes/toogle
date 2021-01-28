import 'package:Toogle/tools/app_tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'app_data.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:Toogle/tools/app_data.dart';
import 'dart:io' as io;
import 'package:dio/dio.dart';

class FirebaseMethods /*implements AppMethods*/ {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  retrieveVisitedShopProducts(String visitedShopID) async {
    List<String> list = [];
    final QuerySnapshot result =
        await firestore.collection("products_" + visitedShopID).getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    for (int i = 0; i < snapshot.length; i++) {
      list.add(snapshot[i].data['productTitle'].toString());
    }
    return list;
  }

  Future<bool> loginUser({String email, String password}) async {
    FirebaseUser user;

    password = password.trim();
    try {
      logOutUser();
      user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      //DocumentSnapshot documentSnapshot =
      //await firestore.collection(usersData).document(user.uid).get();

      final QuerySnapshot result = await firestore
          .collection(usersData)
          .where('userID', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      String id = snapshot[0].data['address'].toString();

      writeDataLocally(
          key: "fullName", value: snapshot[0].data['accountFullName']);
      writeDataLocally(key: "userEmail", value: snapshot[0].data['userEmail']);
      writeDataLocally(key: "userID", value: snapshot[0].data['userID']);
      writeDataLocally(key: "address", value: snapshot[0].data['address']);
      writeDataLocally(
          key: "phoneNumber", value: snapshot[0].data['phoneNumber']);
      writeDataLocally(key: "shopID", value: snapshot[0].data['shopID']);
      writeDataLocally(key: "userID", value: snapshot[0].data['userID']);
      writeBoolDataLocally(key: "loggedIn", value: true);
    } on Exception catch (e) {
      print("eeeeeeeeeeee=" + e.toString());
      //return notComplete();
    }

    return user == null ? notComplete() : complete();
  }

  Future<String> createUserAccount({
    String fullName,
    String fullAddress,
    String phone,
    String email,
    String password,
  }) async {
    FirebaseUser user;
    try {
      user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await firestore.collection(usersData).document(user.uid).setData({
        userID: user.uid,
        address: fullAddress,
        phoneNumber: phone,
        accountFullName: fullName,
        userEmail: email,
        userPassword: password,
        shopID: "noShop",
      }).whenComplete(() {
        writeDataLocally(key: userID, value: user.uid);
        writeDataLocally(key: "fullName", value: fullName);
        writeDataLocally(key: "fullAddress", value: fullAddress);
        writeDataLocally(key: "userPhone", value: phone);
        writeDataLocally(key: "userEmail", value: email);
        writeDataLocally(key: "userPassword", value: password);
        writeDataLocally(key: "photoURL", value: photoURL);
        return complete();
      });
    } on PlatformException catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeee= " + e.toString());
      return "failed";
      //return "not complete";
    }
  }

  Future<bool> logOutUser() async {
    await auth.signOut();
    await clearDataLocally();
    return complete();
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }

  Future<String> addNewProduct({Map<String, dynamic> newProduct}) async {
    String documentID;
    String shopID = await getStringDataLocally(key: "shopID");
    try {
      String uniqueCode = newProduct['productId'];
      DocumentReference reference =
          Firestore.instance.document("products_" + shopID + "/" + uniqueCode);
      reference.setData(newProduct).then((documentRef) {
        documentID = uniqueCode;
      });
      return documentID;
    } on PlatformException catch (e) {
      return "addNewProduct failed!";
    }
  }

  Future<String> updateProduct(
      {Map<String, dynamic> newProduct, String productId}) async {
    String documentID;

    try {
      String shopID = await getStringDataLocally(key: "shopID");

      final QuerySnapshot result = await firestore
          .collection("products_" + shopID)
          .where('productId', isEqualTo: productId)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;
      documentID = snapshot[0].documentID;

      await firestore
          .collection("products_" + shopID)
          .document(documentID)
          .updateData(newProduct);
      return documentID;
    } on PlatformException catch (e) {
      return "addNewProduct failed!";
    }
  }

  Future updateUserOrders(
      List<String> newList, String clientId, String r, String orderID) async {
    String str1 = newList[4];
    String str2 = str1.substring(1).substring(0, str1.length - 2);

    // a list holding the multiple shopsOrders for this client
    List<String> list1 = str2.split(",");

    //we find which of this client's orders is the order that we need to change the status for
    for (int h = 0; h < list1.length; h++) {
      if (list1[h].contains(orderID)) {
        List<String> list2 = list1[h].split("^^^");

        list2[3] = r;
        String str3 = list2[0] +
            "^^^" +
            list2[1] +
            "^^^" +
            list2[2] +
            "^^^" +
            list2[3] +
            "^^^" +
            list2[4];

        list1[h] = str3;
      }
    }

    final QuerySnapshot result = await firestore
        .collection(usersData)
        .where('userID', isEqualTo: clientId)
        .getDocuments();

    final List<DocumentSnapshot> snapshot = result.documents;

    await firestore
        .collection(usersData)
        .document(snapshot[0].documentID)
        .updateData({'shopsOrders': list1});
  }

  Future updateUserDetails(
      String fullName, String phone, String email, String address) async {
    try {
      final QuerySnapshot result = await firestore
          .collection(usersData)
          .where('userEmail', isEqualTo: email)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      String id = snapshot[0].data['userID'].toString();

      final QuerySnapshot result1 = await firestore
          .collection(usersData)
          .where('userID', isEqualTo: id)
          .getDocuments();
      final List<DocumentSnapshot> snapshot1 = result.documents;

      await firestore
          .collection(usersData)
          .document(snapshot1[0].documentID)
          .updateData({
        'accountFullName': fullName,
        phoneNumber: phone,
        'address': address,
      });

      return true;
    } catch (e) {
      print("eeeeeeeeeeeeeee=" + e.toString());
      return false;
    }
  }

  retrieveUserDetails(String acctEmail) async {
    final QuerySnapshot result = await Firestore.instance
        .collection(usersData)
        .where("userEmail", isEqualTo: acctEmail)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    return snapshot;
  }

  retrieveProducts() async {
    String shopID = await getStringDataLocally(key: "shopID");

    final QuerySnapshot result = await Firestore.instance
        .collection("products_" + shopID)
        // .orderBy('productTitle')
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    return snapshot;
  }

  Future retrieveProductSettings() async {
    String shopID = await getStringDataLocally(key: "shopID");

    final QuerySnapshot result = await Firestore.instance
        .collection("products_" + shopID)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    return snapshot;
  }

  Future<List<String>> uploadProductImages(
      {String docID, List<File> imageList}) async {
    List<String> imagesUrl = new List();

    try {
      for (int s = 0; s < imageList.length; s++) {
        if (imageList[s].path.contains("http")) {
          imagesUrl.add(imageList[s].path);
          continue;
        }

        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child(appProducts)
            .child(docID)
            .child(docID + ".$s.jpg");
        StorageUploadTask uploadTask = storageReference.putFile(imageList[s]);
        await uploadTask.onComplete;
        print('File Uploaded');
        String downloadUrl = await storageReference.getDownloadURL();
        imagesUrl.add(downloadUrl);
      }

      return imagesUrl;
    } on PlatformException catch (e) {
      return imagesUrl;
    }
  }

  Future<bool> updateProductImages({String docID, List<String> data}) async {
    bool msg;
    String shopID = await getStringDataLocally(key: "shopID");

    final QuerySnapshot result = await firestore
        .collection("products_" + shopID)
        .where('productId', isEqualTo: docID)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    String documentID = snapshot[0].documentID;

    try {
      await firestore
          .collection('products_' + shopID)
          .document(documentID)
          .updateData({productImages: data}).whenComplete(() {
        msg = true;
      });

      return msg;
    } on PlatformException catch (e) {
      return false;
    }
  }

  removeProduct(int index, String productId) async {
    String shopID = await getStringDataLocally(key: "shopID");

    try {
      await firestore
          .collection("products_" + shopID)
          .document(productId)
          .delete();
    } catch (e) {}
  }

  addNewOrder(
      String paymentMethod,
      String orderID,
      List<String> itemClientId,
      List<String> itemId,
      List<String> itemName,
      List<String> itemQuantity,
      List<String> itemRemarks,
      List<String> itemPrice,
      //List<String> itemStatus,
      List<String> itemWeightKilos,
      List<String> itemWeightGrams) async {
    int timeNow = new DateTime.now().microsecondsSinceEpoch;
    String userEmail = await getStringDataLocally(key: "userEmail");

    String visitedShopID = await getStringDataLocally(key: "visitedShopID");

    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(now);

    QuerySnapshot result = await firestore
        .collection('usersData')
        .where('userEmail', isEqualTo: userEmail)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    String userID = snapshot[0]['userID'].toString();
    List shopsOrders = snapshot[0]['shopsOrders'];

    int len = 0;
    if (shopsOrders != null) len = shopsOrders.length;
    List<String> shopsOrderss = [];
    for (int k = 0; k < len; k++) {
      shopsOrderss.add(shopsOrders[k].toString());
    }

    shopsOrderss.add(visitedShopID +
        '^^^' +
        orderID +
        "^^^" +
        formatted +
        "^^^" +
        "בהמתנה לטיפול" +
        "^^^" +
        paymentMethod);

    String documentID = "";

    QuerySnapshot result1 = await firestore
        .collection('usersData')
        .where('userID', isEqualTo: userID)
        .getDocuments();
    snapshot.forEach((data) => documentID = data.documentID);

    await firestore
        .collection('usersData')
        .document(documentID)
        .updateData({'shopsOrders': shopsOrderss});

    await firestore
        .collection('orders_' + visitedShopID)
        .document(orderID)
        .setData({
      'creatorID': itemClientId[0],
      'paymentMethod': paymentMethod,
    });

    String str = "";
    for (int i = 0; i < itemId.length; i++) {
      String str = itemClientId[i] +
          "^^^" +
          itemId[i] +
          "^^^" +
          itemName[i] +
          "^^^" +
          itemQuantity[i] +
          "^^^" +
          itemRemarks[i] +
          "^^^" +
          itemPrice[i] +
          "^^^" +
          itemWeightKilos[i] +
          "^^^" +
          itemWeightGrams[i];

      await firestore
          .collection('orders_' + visitedShopID)
          .document(orderID)
          .updateData({i.toString(): str});
    }
    var dio = Dio();
    Response response = await dio.get(
        'https://shopping-il.com/mail_order_confirmation.php?email=' +
            userEmail +
            "&orderDetails=" +
            str);
  }

  Future retrieveOrders() async {
    String shopID = await getStringDataLocally(key: "shopID");

    QuerySnapshot result =
        await firestore.collection('orders_' + shopID).getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    List<List<String>> listAllOrders = [];
    for (int i = 0; i < snapshot.length; i++) {
      List<String> listSingleOrder = [];

      String order0 = snapshot[i]['0'].toString();
      if (order0 != "null") listSingleOrder.add(order0);

      String order1 = snapshot[i]['1'].toString();
      if (order1 != "null") listSingleOrder.add(order1);

      String order2 = snapshot[i]['2'].toString();
      if (order2 != "null") listSingleOrder.add(order2);

      String order3 = snapshot[i]['3'].toString();
      if (order3 != "null") listSingleOrder.add(order3);

      String order4 = snapshot[i]['4'].toString();
      if (order4 != "null") listSingleOrder.add(order4);

      String order5 = snapshot[i]['5'].toString();
      if (order5 != "null") listSingleOrder.add(order5);

      String order6 = snapshot[i]['6'].toString();
      if (order6 != "null") listSingleOrder.add(order6);

      String order7 = snapshot[i]['7'].toString();
      if (order7 != "null") listSingleOrder.add(order7);

      String order8 = snapshot[i]['8'].toString();
      if (order8 != "null") listSingleOrder.add(order8);

      String order9 = snapshot[i]['9'].toString();
      if (order9 != "null") listSingleOrder.add(order9);

      listAllOrders.add(listSingleOrder);
    }

    return listAllOrders;
  }

  retrieveClientDetails(String clientId) async {
    QuerySnapshot result = await firestore
        .collection(usersData)
        .where("userID", isEqualTo: clientId)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    List<String> listClientDetails = [];

    for (int i = 0; i < snapshot.length; i++) {
      listClientDetails.add(snapshot[i]['accountFullName'].toString());
      listClientDetails.add(snapshot[i]['userEmail'].toString());
      listClientDetails.add(snapshot[i]['phoneNumber'].toString());
      listClientDetails.add(snapshot[i]['address'].toString());
      listClientDetails.add(snapshot[i]['shopsOrders'].toString());
      listClientDetails.add(snapshot[i]['userID'].toString());
    }

    return listClientDetails;
  }

  updateItemStatus(String str, int index, int i) async {
    String shopID = await getStringDataLocally(key: "shopID");

    List<String> orderId = [];
    QuerySnapshot result =
        await firestore.collection('orders_' + shopID).getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    snapshot.forEach((data) => orderId.add(data.documentID));

    try {
      await firestore
          .collection('orders_' + shopID)
          .document(orderId[index])
          .updateData({i.toString(): str});
      return "success";
    } on PlatformException catch (e) {
      return "addNewProduct failed!";
    }
  }

  Future<String> removeOrder(int index, String email) async {
    String userEmail = await getStringDataLocally(key: "userEmail");
    String shopID = await getStringDataLocally(key: "shopID");

    List<String> orderId = [];
    List<String> clientId = [];
    QuerySnapshot result =
        await firestore.collection('orders_' + shopID).getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    snapshot.forEach((data) {
      orderId.add(data.documentID);
      String str = data['0'];
      int pos = str.indexOf("^^^");
      if (pos >= 0) {
        clientId.add(str.substring(0, pos));
      }
    });

    try {
      await firestore
          .collection('orders_' + shopID)
          .document(orderId[index])
          .delete();
    } on PlatformException catch (e) {}

    QuerySnapshot result1 = await firestore
        .collection('usersData')
        .where('userID', isEqualTo: clientId[index])
        .getDocuments();

    final List<DocumentSnapshot> snapshot1 = result1.documents;
    List shopsOrders = snapshot1[0]['shopsOrders'];

    List temp = [];
    for (int i = 0; i < shopsOrders.length; i++) {
      if (i != index) temp.add(shopsOrders[i]);
    }
    shopsOrders = temp;

    final QuerySnapshot result2 = await firestore
        .collection(usersData)
        .where('userID', isEqualTo: clientId[index])
        .getDocuments();

    final List<DocumentSnapshot> snapshot2 = result2.documents;

    try {
      await firestore
          .collection(usersData)
          .document(snapshot2[0].documentID)
          .updateData({'shopsOrders': shopsOrders});
    } on PlatformException catch (e) {
      print("eeeeeeeeeeeeeeee=" + e.message);
    }
  }

  Future<List<String>> retrieveShopsOrders() async {
    try {
      String userEmail = await getStringDataLocally(key: "userEmail");

      final QuerySnapshot result = await firestore
          .collection(usersData)
          .where('userEmail', isEqualTo: userEmail)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      List tempList = snapshot[0].data['shopsOrders'];
      List<String> shopsOrders = [];
      for (int i = 0; i < tempList.length; i++) {
        shopsOrders.add(tempList[i].toString());
      }

      return shopsOrders;
    } catch (e) {}
  }

  Future<List<String>> retrieveShopDetails(String shopID) async {
    try {
      final QuerySnapshot result = await firestore
          .collection('shops')
          .where('shopID', isEqualTo: shopID)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      List<String> tempList = [];
      tempList.add(snapshot[0].data['shopID']);
      tempList.add(snapshot[0].data['shopFullName']);
      tempList.add(snapshot[0].data['address']);
      tempList.add(snapshot[0].data['email']);
      tempList.add(snapshot[0].data['phone']);
      tempList.add(snapshot[0].data['category']);
      tempList.add(snapshot[0].data['categoryLevel1'].toString());
      tempList.add(snapshot[0].data['categoryLevel2'].toString());
      tempList.add(snapshot[0].data['categoryLevel3'].toString());
      tempList.add(snapshot[0].data['creditCards']);
      tempList.add(snapshot[0].data['paypal']);

      return tempList;
    } catch (e) {
      print("aaaaaaaaaaaaaaaaaaa= " + e.toString());
    }
  }

  Future<List<String>> retreiveOrderDetails(
      String shopID, String orderID) async {
    List<String> response = [];

    try {
      DocumentSnapshot documentSnapshot = await firestore
          .collection("orders_" + shopID)
          .document(orderID)
          .get();

      String str0 = documentSnapshot["0"].toString();
      if (str0 != "null") response.add(str0);

      String str1 = documentSnapshot["1"].toString();
      if (str1 != "null") response.add(str1);

      String str2 = documentSnapshot["2"].toString();
      if (str2 != "null") response.add(str2);

      String str3 = documentSnapshot["3"].toString();
      if (str3 != "null") response.add(str3);

      String str4 = documentSnapshot["4"].toString();
      if (str4 != "null") response.add(str4);

      String str5 = documentSnapshot["5"].toString();
      if (str5 != "null") response.add(str5);

      String str6 = documentSnapshot["6"].toString();
      if (str6 != "null") response.add(str6);

      String str7 = documentSnapshot["7"].toString();
      if (str7 != "null") response.add(str7);

      String str8 = documentSnapshot["8"].toString();
      if (str8 != "null") response.add(str8);

      String str9 = documentSnapshot["9"].toString();
      if (str9 != "null") response.add(str9);

      return response;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee= " + e.toString());
    }
  }

  //updating the shopID filed for the user who has created this shop
  updateUserShopId(String userID, String shopID) async {
    try {
      await firestore
          .collection(usersData)
          .document(userID)
          .updateData({'shopID': shopID});
    } on PlatformException catch (e) {
      return "addNewProduct failed!";
    }
  }

//when crteating/editing the shop: updating its details
  Future<bool> updateShopDetails(
    String shopID,
    String shopName,
    String address,
    String phone,
    String email,
    String creatorID,
    String paypal,
    String sendReceipt,
    String creditCards,
    String category,
    List<String> tempCategoryLevel1,
    List<String> tempCategoryLevel2,
    List<String> tempCategoryLevel3,
  ) async {
    bool isItNewShop = false;

    List<String> categoryLevel1 = tempCategoryLevel1;
    List<String> categoryLevel2 = tempCategoryLevel2;
    List<String> categoryLevel3 = tempCategoryLevel3;

    try {
      if (shopID != 'noShop') {
        await firestore.collection('shops').document(shopID).setData({
          'shopID': shopID,
          'shopFullName': shopName,
          'address': address,
          'phone': phone,
          'email': email,
          'category': category,
          'categoryLevel1': categoryLevel1,
          'categoryLevel2': categoryLevel2,
          'categoryLevel3': categoryLevel3,
          'creatorID': creatorID,
          'paypal': paypal,
          'sendReceipt': sendReceipt,
          'creditCards': creditCards,
        }, merge: true);
      } else {
        int timeNow = new DateTime.now().microsecondsSinceEpoch;
        shopID = timeNow.toString();

        final QuerySnapshot result = await firestore
            .collection('shops')
            .where('shopID', isEqualTo: shopID)
            .getDocuments();
        try {
          final List<DocumentSnapshot> snapshot = result.documents;
          String temp = snapshot[0].data['categoryLevel1'].toString();
        } catch (e) {
          isItNewShop = true;
        }

        await firestore.collection('shops').document(shopID).setData({
          'shopID': shopID,
          'shopFullName': shopName,
          'address': address,
          'phone': phone,
          'email': email,
          'category': category,
          'creatorID': creatorID,
          'paypal': paypal,
          'creditCards': creditCards,
          'categoryLevel1': categoryLevel1,
          'categoryLevel2': categoryLevel2,
          'categoryLevel3': categoryLevel3,
        }, merge: true);
      }

      writeDataLocally(key: "shopID", value: shopID);
      String userID = await getStringDataLocally(key: "userID");
      updateUserShopId(userID, shopID);
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  }

  retrieveShopList(bool isLoggedIn) async {
    List<String> detailsShops = [];

    if (isLoggedIn == false) return detailsShops;
    final QuerySnapshot result =
        await firestore.collection('shops').getDocuments();

    final List<DocumentSnapshot> snapshot = result.documents;

    for (int i = 0; i < snapshot.length; i++) {
      String temp = snapshot[i].data['shopID'].toString() +
          "^^^" +
          snapshot[i].data['shopFullName'].toString();
      detailsShops.add(temp);
    }

    return detailsShops;
  }

  Future<String> getPhoneVisitedShop(String visitedShopID) async {
    final QuerySnapshot result = await firestore
        .collection('shops')
        .where('shopID', isEqualTo: visitedShopID)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    return snapshot[0].data['phone'].toString();
  }

  Future<List<List>> getCategories(String visitedShopID) async {
    List<List> listCategories = [];
    final QuerySnapshot result = await firestore
        .collection('shops')
        .where('shopID', isEqualTo: visitedShopID)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    List categoryLevel1 = snapshot[0].data['categoryLevel1'];
    List categoryLevel2 = snapshot[0].data['categoryLevel2'];
    List categoryLevel3 = snapshot[0].data['categoryLevel3'];
    List visitorList = snapshot[0].data['visitorList'];

    listCategories.add(categoryLevel1);
    listCategories.add(categoryLevel2);
    listCategories.add(categoryLevel3);
    listCategories.add(visitorList);
    return listCategories;
  }

  //add this user to  visitorList of the shop he has just entered
  Future<bool> addVisitorToShopList(
      String visitedShopId, List<String> visitorList) async {
    await firestore
        .collection("shops")
        .document(visitedShopId)
        .updateData({'visitorList': visitorList});

    return true;
  }

  //retrieve the list of visitors for the given shop
  Future<List> retrieveVisitorListShop() async {
    String shopID = await getStringDataLocally(key: 'shopID');
    List<List> listCategories = [];
    final QuerySnapshot result = await firestore
        .collection('shops')
        .where('shopID', isEqualTo: shopID)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    List visitorList = snapshot[0].data['visitorList'];
    return visitorList;
  }
}
