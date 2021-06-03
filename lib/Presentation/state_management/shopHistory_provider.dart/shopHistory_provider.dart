import 'package:Toogle/Core/exceptions.dart';
import 'package:Toogle/Presentation/state_management/shopHistory_provider.dart/shopHistory_state.dart';
import 'package:Toogle/Presentation/state_management/user_provider/user_state.dart';
import 'package:flutter/material.dart';

class ShopHistoryProvider extends ChangeNotifier {
  ShopHistoryState _state; //an object of one of the possible states
  ShopHistoryState get state =>
      _state; //a class can access _state only by a getter
  void changeState(ShopHistoryState newFactState) {
    _state = newFactState;
    notifyListeners(); //make all the Widgets which listen to this Provider know about the new state.

    // call the usecase to get the response
    /* Either<ServerException, Fact> failOrFact = await _getRandomFactUsecase(
      params: Params(language: language),
    );*/
    // check either the usecase return exception or result
    /*failOrFact.fold(
      (exception) {
        // if an exception was handled, just return error message
        _state = NewUserError(message: exception.toString());
        notifyListeners();
      },
      (fact) {
        // if a Fact object was returned, make a new state based on it
        addFact(fact);
        _state = NewFactLoaded(result: fact);
        notifyListeners();
      },
    );*/
  }
}
