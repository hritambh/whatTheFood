// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enriched_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnrichedItem _$EnrichedItemFromJson(Map<String, dynamic> json) =>
    _EnrichedItem(
      name: json['name'] as String,
      price: json['price'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergens:
          (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryType:
          $enumDecodeNullable(_$DietaryTypeEnumMap, json['dietaryType']) ??
          DietaryType.NON_VEG,
      aiDescription: json['aiDescription'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$EnrichedItemToJson(_EnrichedItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'ingredients': instance.ingredients,
      'allergens': instance.allergens,
      'dietaryType': _$DietaryTypeEnumMap[instance.dietaryType]!,
      'aiDescription': instance.aiDescription,
      'imageUrl': instance.imageUrl,
    };

const _$DietaryTypeEnumMap = {
  DietaryType.VEGAN: 'VEGAN',
  DietaryType.VEG: 'VEG',
  DietaryType.NON_VEG: 'NON_VEG',
};
