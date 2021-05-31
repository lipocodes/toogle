import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Data/repositories_impl.dart';
import 'package:Toogle/Domain/entities/delivery_details.dart';
import 'package:Toogle/Presentation/state_management/contact_provider/contact_state.dart';
import 'package:Toogle/Presentation/state_management/delivery_provider/delivery_state.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryProvider extends ChangeNotifier {
  TextEditingController controllerFullName = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerAddress = new TextEditingController();
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String userEmail = "";
  String acctEmail;
  DeliveryState _state;
  DeliveryState get state => _state;

  void changeState(DeliveryState deliveryState) {
    _state = deliveryState;
    notifyListeners();
  }

  updateUserDetails(BuildContext context) async {
    if (controllerFullName.text.length == 0) {
      showSnackBar("חסר שם", scaffoldKey);
      return;
    } else if (controllerPhone.text.length == 0) {
      showSnackBar("חסר טלפון", scaffoldKey);
      return;
    } else if (controllerAddress.text.length == 0) {
      showSnackBar("חסרה כתובת מלאה", scaffoldKey);
      return;
    }

    displayProgressDialog(context);

    DeliveryDetails deliveryDetails = DeliveryDetails(
        accountFullName: controllerFullName.text,
        phoneNumber: controllerPhone.text,
        userEmail: controllerEmail.text,
        address: controllerAddress.text);

    Map<String, dynamic> map = deliveryDetails.toJson();

    bool result = await RepositoryImpl().updateUserDetails(map);
    closeProgressDialog(context);
    if (result == true) {
      showSnackBar("Update Successful!", scaffoldKey);
      changeState(UserUpdated());
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pop(context);
      });
    } else {
      changeState(UserUpdateFailed());
    }
  }

  retrieveUserDetails(String acctEmail) async {
    Either<ServerException, List<DocumentSnapshot>> failOrSnapshot =
        await RepositoryImpl().retrieveUserDetails(acctEmail: acctEmail);
    failOrSnapshot.fold((exception) {
      print("retrieveUserDetails() Exception: " + exception.toString());
    }, (snapshot) {
      DeliveryDetails deliveryDetails =
          DeliveryDetails.fromJson(snapshot[0].data);

      controllerFullName.text = deliveryDetails.accountFullName;
      controllerPhone.text = deliveryDetails.phoneNumber;
      controllerEmail.text = deliveryDetails.userEmail;
      controllerAddress.text = deliveryDetails.address;
      //changeState(UserDetails());
    });
  }
}
