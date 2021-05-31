import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DeliveryState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserDetails extends DeliveryState {}
