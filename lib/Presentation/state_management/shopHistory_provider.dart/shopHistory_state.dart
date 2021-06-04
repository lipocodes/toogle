import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ShopHistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderDetailsRetrieved extends ShopHistoryState {
  final List<String> orderList;
  OrderDetailsRetrieved({@required this.orderList});
  List<Object> get props => [orderList];
}

class OrderDetailsError extends ShopHistoryState {}
