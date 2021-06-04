import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

///
/// DeliveryDetails is the entity that contains the data to present in the presentation layer
///
class OrderHistoryDetails extends Equatable {
  final String fullName;
  final String location;
  final String phone;
  final List<String> shopOrders;

  OrderHistoryDetails({
    @required this.fullName,
    @required this.location,
    @required this.phone,
    @required this.shopOrders,
  });

  @override
  List<Object> get props => [fullName, location, phone, shopOrders];

  factory OrderHistoryDetails.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDetails(
        fullName: json['fullName'],
        location: json['location'],
        phone: json['phone'],
        shopOrders: json["shopOrders"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': this.fullName,
      'location': this.location,
      'phone': this.phone,
      'shopOrders': this.shopOrders
    };
  }
}
