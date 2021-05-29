import 'package:Toogle/Presentation/state_management/contact_provider/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactProvider extends ChangeNotifier {
  final valueName = TextEditingController();
  final valuePhone = TextEditingController();
  final valueEmail = TextEditingController();
  final valueText = TextEditingController();

  ContactState _state;
  ContactState get state => _state;

  void changeState(ContactState contactState) {
    _state = contactState;
    notifyListeners();
  }

  sendEmail(BuildContext context) async {
    int pos = valueEmail.text.indexOf('@');
    String emailUser = valueEmail.text.substring(0, pos);
    String emailSupplier =
        valueEmail.text.substring(pos + 1, valueEmail.text.length - 4);

    String str = "Name: " +
        valueName.text +
        "    Phone: " +
        valuePhone.text +
        "    Email: " +
        emailUser +
        "  " +
        emailSupplier +
        "  Content: " +
        valueText.text;

    final String _email = 'mailto:' +
        'toogle.app@gmail.com' +
        '?subject=' +
        "User has just sent a message" +
        '&body=' +
        str;
    try {
      await launch(_email);
      changeState(MessageSubmitted());
      notifyListeners();
    } catch (e) {
      print('eeeeeeeeeeeeeeeeeeeeeeee ' + e.toString());
      changeState(MessageFailed());
      notifyListeners();
    } finally {
      Navigator.of(context).pop();
    }
  }
}
