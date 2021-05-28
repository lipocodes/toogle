import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NewUserState extends Equatable {
  @override
  List<Object> get props => [];
}

class State1 extends NewUserState {}

class NewStateError extends NewUserState {
  final String message;
  NewStateError({@required this.message});
  @override
  List<Object> get props => [message];
}
