import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Domain/entities/delivery_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class RepositoryAPI {
  Future<Either<ServerException, List<DocumentSnapshot>>> retrieveUserDetails(
      {@required String acctEmail});
  Future updateUserDetails(Map<String, dynamic> map);
}
