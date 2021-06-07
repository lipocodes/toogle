import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class Event1 extends CartState {}
