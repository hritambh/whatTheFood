import 'package:freezed_annotation/freezed_annotation.dart';

part 'enriched_item.freezed.dart';
part 'enriched_item.g.dart';

enum DietaryType {
  @JsonValue('VEGAN')
  VEGAN,
  @JsonValue('VEG')
  VEG,
  @JsonValue('NON_VEG')
  NON_VEG
}

@freezed
abstract class EnrichedItem with _$EnrichedItem {
  const EnrichedItem._();
  
  const factory EnrichedItem({
    required String name,
    String? price,
    String? description,
    String? category,
    @Default([]) List<String> ingredients,
    @Default([]) List<String> allergens,
    @Default(DietaryType.NON_VEG) DietaryType dietaryType,
    String? aiDescription,
    String? imageUrl,
  }) = _EnrichedItem;

  factory EnrichedItem.fromJson(Map<String, dynamic> json) =>
      _$EnrichedItemFromJson(json);
}