import 'package:Toogle/Core/constants/app_data.dart';
import 'package:Toogle/Domain/entities/delivery_details.dart';
import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Domain/repositories_api/repository_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future updateUserDetails(Map<String, dynamic> map) async {
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
}
