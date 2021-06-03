import 'package:equatable/equatable.dart';

class ShopDetails extends Equatable {
  final String address;
  final String category;
  final List<String> categoryLevel1;
  final List<String> categoryLevel2;
  final List<String> categoryLevel3;
  final String creatorID;
  final String creditCards;
  final String email;
  final String paypal;
  final String phone;
  final String sendReceipt;
  final String shopFullName;
  final String shopID;

  ShopDetails(
      {this.address,
      this.category,
      this.categoryLevel1,
      this.categoryLevel2,
      this.categoryLevel3,
      this.creatorID,
      this.creditCards,
      this.email,
      this.paypal,
      this.phone,
      this.sendReceipt,
      this.shopFullName,
      this.shopID});
  @override
  List<Object> get props => [
        address,
        category,
        categoryLevel1,
        categoryLevel2,
        categoryLevel3,
        creatorID,
        creditCards,
        email,
        paypal,
        phone,
        sendReceipt,
        shopFullName,
        shopID
      ];

  factory ShopDetails.fromJson(Map<String, dynamic> json) {
    return ShopDetails(
        address: json['address'],
        category: json['category'],
        categoryLevel1: json['categoryLevel1'],
        categoryLevel2: json['categoryLevel2'],
        categoryLevel3: json['categoryLevel3'],
        creatorID: json['creatorID'],
        creditCards: json['creditCards'],
        email: json['email'],
        paypal: json['paypal'],
        phone: json['phone'],
        sendReceipt: json['sendReceipt'],
        shopFullName: json['shopFullName'],
        shopID: json['shopID']);
  }

  Map<String, dynamic> toJson() {
    return {
      'address': this.address,
      'category': this.category,
      'categoryLevel1': this.categoryLevel1,
      'categoryLevel2': this.categoryLevel2,
      'categoryLevel3': this.categoryLevel3,
      'creatorID': this.creatorID,
      'creditCards': this.creditCards,
      'email': this.email,
      'paypal': this.paypal,
      'phone': this.phone,
      'sendReceipt': this.sendReceipt,
      'shopFullName': this.shopFullName,
      'shopID': this.shopID
    };
  }
}
