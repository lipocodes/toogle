import 'package:Toogle/Presentation/state_management/contact_provider/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailProvider extends ChangeNotifier {
  ContactState _state;
  ContactState get state => _state;

  void changeState(ContactState contactState) {
    _state = contactState;
    notifyListeners();
  }
}
