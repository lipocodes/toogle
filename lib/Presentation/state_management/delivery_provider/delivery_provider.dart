import 'package:Toogle/Presentation/state_management/contact_provider/contact_state.dart';
import 'package:Toogle/Presentation/widgets/app_tools.dart';
import 'package:Toogle/tools/firebase_methods.dart';
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
  ContactState _state;
  ContactState get state => _state;

  void changeState(ContactState contactState) {
    _state = contactState;
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
    bool result = await firebaseMethods.updateUserDetails(
        controllerFullName.text,
        controllerPhone.text,
        controllerEmail.text,
        controllerAddress.text);
    closeProgressDialog(context);
    if (result == true) {
      showSnackBar("Update Successful!", scaffoldKey);
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pop(context);
      });
    } else
      showSnackBar("Update failed.  Please try later!", scaffoldKey);
  }

  retrieveUserDetails() async {
    controllerFullName.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";
    controllerAddress.text = "";

    var snapshot = await firebaseMethods.retrieveUserDetails(acctEmail);
    controllerFullName.text = snapshot[0].data['accountFullName'].toString();
    controllerPhone.text = snapshot[0].data['phoneNumber'].toString();
    controllerEmail.text = snapshot[0].data['userEmail'].toString();
    controllerAddress.text = snapshot[0].data['address'].toString();
  }
}
