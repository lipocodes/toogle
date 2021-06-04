import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

///
/// DeliveryDetails is the entity that contains the data to present in the presentation layer
///
class OrderHistoryDetails extends Equatable {
  final String fullName;
  final String location;
  final String phone;
  final List<dynamic> shopsOrders;

  OrderHistoryDetails({
    @required this.fullName,
    @required this.location,
    @required this.phone,
    @required this.shopsOrders,
  });

  @override
  List<Object> get props => [fullName, location, phone, shopsOrders];

  factory OrderHistoryDetails.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDetails(
        fullName: json['fullName'],
        location: json['location'],
        phone: json['phone'],
        shopsOrders: json['shopsOrders']);
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': this.fullName,
      'location': this.location,
      'phone': this.phone,
      'shopOrders': this.shopsOrders
    };
  }
}
