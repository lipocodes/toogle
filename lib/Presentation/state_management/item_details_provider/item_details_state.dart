import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ItemDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class MessageSubmitted extends ItemDetailState {}

class MessageFailed extends ItemDetailState {}
