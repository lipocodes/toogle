import 'dart:math';

import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Domain/entities/delivery_details.dart';
import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Domain/repositories_api/repository_api.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements RepositoryAPI {
  Firestore firestore = Firestore.instance;
  RepositoryImpl();

  @override
  Future<Either<ServerException, List<DocumentSnapshot>>> retrieveUserDetails(
      {@required String acctEmail}) async {
    try {
      final QuerySnapshot result = await Firestore.instance
          .collection(usersData)
          .where("userEmail", isEqualTo: acctEmail)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;
      if (snapshot == null) {
        return left(ServerException("Can't retrieve user details!"));
      } else {
        return right(snapshot);
      }
    } catch (e) {
      return left(ServerException("Can't retrieve user details!"));
    }
  }

  @override
  Future<bool> updateUserDetails(Map<String, dynamic> map) async {
    try {
      final QuerySnapshot result = await firestore
          .collection(usersData)
          .where('userEmail', isEqualTo: map["userEmail"])
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      String email = map['userEmail'];

      final QuerySnapshot result1 = await firestore
          .collection(usersData)
          .where('userEmail', isEqualTo: email)
          .getDocuments();
      final List<DocumentSnapshot> snapshot1 = result1.documents;
      if (snapshot1 == null) return false;

      await firestore
          .collection(usersData)
          .document(snapshot1[0].documentID)
          .updateData({
        'accountFullName': map["accountFullName"],
        'phoneNumber': map["phoneNumber"],
        'address': map["address"],
      });

      return true;
    } catch (e) {
      print("eeeeeeeeeeeeeee=" + e.toString());
      return false;
    }
  }

  Future<Either<ServerException, List<String>>> retrieveShopDetails(
      String shopID) async {
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
      return right(tempList);
    } catch (e) {
      return left(ServerException("Can't retrieve shop details!"));
    }
  }

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
        var querySnapshot;
        for (int i = 0; i < 1000; i++) {
          Random random = new Random();
          shopID = (random.nextInt(1000) + 100).toString();

          final QuerySnapshot result = await firestore
              .collection('shops')
              .where('shopID', isEqualTo: shopID)
              .getDocuments();
          try {
            List<String> categoryLevel1 =
                querySnapshot.docs[0].data()['categoryLevel1'];
          } catch (e) {
            isItNewShop = true;
            return false;
          }
          if (isItNewShop == true) break; //if no
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

  Future<bool> updateUserShopID(String userID, String shopID) async {
    try {
      await firestore
          .collection(usersData)
          .document(userID)
          .updateData({'shopID': shopID});
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<Either<ServerException, List<String>>> retrieveShopsOrders(
      String phone) async {
    try {
      String userEmail = await getStringDataLocally(key: "userEmail");

      final QuerySnapshot result = await firestore
          .collection('clientsData')
          .where('phone', isEqualTo: phone)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      List tempList = snapshot[0].data['shopsOrders'];
      List<String> shopsOrders = [];
      for (int i = 0; i < tempList.length; i++) {
        shopsOrders.add(tempList[i].toString());
      }

      return right(shopsOrders);
    } catch (e) {
      return left(ServerException("Can't retrieve order details!"));
    }
  }
}
