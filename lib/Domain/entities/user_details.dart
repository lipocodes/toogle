import 'package:equatable/equatable.dart';

class UserDetails extends Equatable {
  final String accountFullName;
  final String address;
  final String password;
  final String phoneNumber;
  final String shopID;
  final String userEmail;
  final String userID;

  UserDetails(
      {this.accountFullName,
      this.address,
      this.password,
      this.phoneNumber,
      this.shopID,
      this.userEmail,
      this.userID});
  @override
  List<Object> get props => [accountFullName, phoneNumber, userEmail, address];

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        accountFullName: json['accountFullName'],
        address: json['address'],
        phoneNumber: json['phoneNumber'],
        shopID: json["shopID"],
        userEmail: json["userEmail"],
        userID: json["userID"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'accountFullName': this.accountFullName,
      'address': this.address,
      'phoneNumber': this.phoneNumber,
      'shopID': this.shopID,
      'userEmail': this.userEmail,
      'userID': this.userID
    };
  }
}
