import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ContactState extends Equatable {
  @override
  List<Object> get props => [];
}

class MessageSubmitted extends ContactState {}

class MessageFailed extends ContactState {}
