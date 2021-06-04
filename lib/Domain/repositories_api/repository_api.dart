import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Domain/entities/delivery_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class RepositoryAPI {
  Future<Either<ServerException, List<DocumentSnapshot>>> retrieveUserDetails(
      {@required String acctEmail});
  Future<bool> updateUserDetails(Map<String, dynamic> map);
  Future<Either<ServerException, List<String>>> retrieveShopDetails(
      String shopID);
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
  );
  Future<bool> updateUserShopID(String userID, String shopID);
  Future<Either<ServerException, List<String>>> retrieveShopsOrders(
      String phone);
}
