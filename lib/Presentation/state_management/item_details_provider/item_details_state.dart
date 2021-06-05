import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ItemDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class IncrementQuantity extends ItemDetailState {}

class DecrementQuantity extends ItemDetailState {}

class ChangedDropDownWeightKilos extends ItemDetailState {}

class ChangedDropDownWeightGrams extends ItemDetailState {}

class RetrievePrefs extends ItemDetailState {}

class OrderNow extends ItemDetailState {}

class IllegalWeight extends ItemDetailState {}
