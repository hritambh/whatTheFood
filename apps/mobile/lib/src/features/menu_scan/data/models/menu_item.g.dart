// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => _MenuItem(
  name: json['name'] as String,
  price: json['price'] as String?,
  description: json['description'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$MenuItemToJson(_MenuItem instance) => <String, dynamic>{
  'name': instance.name,
  'price': instance.price,
  'description': instance.description,
  'category': instance.category,
};
