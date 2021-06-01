import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CreateEditShopState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddedToCategory1 extends CreateEditShopState {}

class AddedToCategory2 extends CreateEditShopState {}

class AddedToCategory3 extends CreateEditShopState {}

class RemoveFromCategory1 extends CreateEditShopState {}

class RemoveFromCategory2 extends CreateEditShopState {}

class RemoveFromCategory3 extends CreateEditShopState {}

class RetrieveSubcategories extends CreateEditShopState {}

class ChangedDropDownCategory1 extends CreateEditShopState {}

class ChangedDropDownCategory2 extends CreateEditShopState {}

class ChangedDropDownCategory3 extends CreateEditShopState {}

class RetrieveShopDetails extends CreateEditShopState {}

class UpdateShopDetails extends CreateEditShopState {}

class ChangedDropDownCategory extends CreateEditShopState {}
