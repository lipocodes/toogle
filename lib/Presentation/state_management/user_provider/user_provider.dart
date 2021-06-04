import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Presentation/state_management/user_provider/user_state.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  NewUserState _state; //an object of one of the possible states
  NewUserState get state => _state; //a class can access _state only by a getter
  void changeState(NewUserState newFactState) {
    _state = newFactState;
    notifyListeners(); //make all the Widgets which listen to this Provider know about the new state.
  }
}
