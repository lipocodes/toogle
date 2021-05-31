import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Data/repositories_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

///
/// DeliveryDetails is the entity that contains the data to present in the presentation layer
///
class DeliveryDetails extends Equatable {
  final String accountFullName;
  final String phoneNumber;
  final String userEmail;
  final String address;

  DeliveryDetails({
    @required this.accountFullName,
    @required this.phoneNumber,
    @required this.userEmail,
    @required this.address,
  });

  @override
  List<Object> get props => [accountFullName, phoneNumber, userEmail, address];

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryDetails(
        accountFullName: json['accountFullName'],
        phoneNumber: json['phoneNumber'],
        userEmail: json['userEmail'],
        address: json["address"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'accountFullName': this.accountFullName,
      'phoneNumber': this.phoneNumber,
      'userEmail': this.userEmail,
      'address': this.address
    };
  }
}
