import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MyHomePageState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLoggedInState extends MyHomePageState {}

class NewStateError extends MyHomePageState {
  final String message;
  NewStateError({@required this.message});
  @override
  List<Object> get props => [message];
}
