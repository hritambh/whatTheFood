// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enriched_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnrichedItem {

 String get name; String? get price; String? get description; String? get category; List<String> get ingredients; List<String> get allergens; DietaryType get dietaryType; String? get aiDescription; String? get imageUrl;
/// Create a copy of EnrichedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrichedItemCopyWith<EnrichedItem> get copyWith => _$EnrichedItemCopyWithImpl<EnrichedItem>(this as EnrichedItem, _$identity);

  /// Serializes this EnrichedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrichedItem&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&const DeepCollectionEquality().equals(other.allergens, allergens)&&(identical(other.dietaryType, dietaryType) || other.dietaryType == dietaryType)&&(identical(other.aiDescription, aiDescription) || other.aiDescription == aiDescription)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,description,category,const DeepCollectionEquality().hash(ingredients),const DeepCollectionEquality().hash(allergens),dietaryType,aiDescription,imageUrl);

@override
String toString() {
  return 'EnrichedItem(name: $name, price: $price, description: $description, category: $category, ingredients: $ingredients, allergens: $allergens, dietaryType: $dietaryType, aiDescription: $aiDescription, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $EnrichedItemCopyWith<$Res>  {
  factory $EnrichedItemCopyWith(EnrichedItem value, $Res Function(EnrichedItem) _then) = _$EnrichedItemCopyWithImpl;
@useResult
$Res call({
 String name, String? price, String? description, String? category, List<String> ingredients, List<String> allergens, DietaryType dietaryType, String? aiDescription, String? imageUrl
});




}
/// @nodoc
class _$EnrichedItemCopyWithImpl<$Res>
    implements $EnrichedItemCopyWith<$Res> {
  _$EnrichedItemCopyWithImpl(this._self, this._then);

  final EnrichedItem _self;
  final $Res Function(EnrichedItem) _then;

/// Create a copy of EnrichedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? price = freezed,Object? description = freezed,Object? category = freezed,Object? ingredients = null,Object? allergens = null,Object? dietaryType = null,Object? aiDescription = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,allergens: null == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>,dietaryType: null == dietaryType ? _self.dietaryType : dietaryType // ignore: cast_nullable_to_non_nullable
as DietaryType,aiDescription: freezed == aiDescription ? _self.aiDescription : aiDescription // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnrichedItem].
extension EnrichedItemPatterns on EnrichedItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrichedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrichedItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrichedItem value)  $default,){
final _that = this;
switch (_that) {
case _EnrichedItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrichedItem value)?  $default,){
final _that = this;
switch (_that) {
case _EnrichedItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? price,  String? description,  String? category,  List<String> ingredients,  List<String> allergens,  DietaryType dietaryType,  String? aiDescription,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrichedItem() when $default != null:
return $default(_that.name,_that.price,_that.description,_that.category,_that.ingredients,_that.allergens,_that.dietaryType,_that.aiDescription,_that.imageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? price,  String? description,  String? category,  List<String> ingredients,  List<String> allergens,  DietaryType dietaryType,  String? aiDescription,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _EnrichedItem():
return $default(_that.name,_that.price,_that.description,_that.category,_that.ingredients,_that.allergens,_that.dietaryType,_that.aiDescription,_that.imageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? price,  String? description,  String? category,  List<String> ingredients,  List<String> allergens,  DietaryType dietaryType,  String? aiDescription,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _EnrichedItem() when $default != null:
return $default(_that.name,_that.price,_that.description,_that.category,_that.ingredients,_that.allergens,_that.dietaryType,_that.aiDescription,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnrichedItem extends EnrichedItem {
  const _EnrichedItem({required this.name, this.price, this.description, this.category, final  List<String> ingredients = const [], final  List<String> allergens = const [], this.dietaryType = DietaryType.NON_VEG, this.aiDescription, this.imageUrl}): _ingredients = ingredients,_allergens = allergens,super._();
  factory _EnrichedItem.fromJson(Map<String, dynamic> json) => _$EnrichedItemFromJson(json);

@override final  String name;
@override final  String? price;
@override final  String? description;
@override final  String? category;
 final  List<String> _ingredients;
@override@JsonKey() List<String> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

 final  List<String> _allergens;
@override@JsonKey() List<String> get allergens {
  if (_allergens is EqualUnmodifiableListView) return _allergens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergens);
}

@override@JsonKey() final  DietaryType dietaryType;
@override final  String? aiDescription;
@override final  String? imageUrl;

/// Create a copy of EnrichedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrichedItemCopyWith<_EnrichedItem> get copyWith => __$EnrichedItemCopyWithImpl<_EnrichedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnrichedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrichedItem&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&const DeepCollectionEquality().equals(other._allergens, _allergens)&&(identical(other.dietaryType, dietaryType) || other.dietaryType == dietaryType)&&(identical(other.aiDescription, aiDescription) || other.aiDescription == aiDescription)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,description,category,const DeepCollectionEquality().hash(_ingredients),const DeepCollectionEquality().hash(_allergens),dietaryType,aiDescription,imageUrl);

@override
String toString() {
  return 'EnrichedItem(name: $name, price: $price, description: $description, category: $category, ingredients: $ingredients, allergens: $allergens, dietaryType: $dietaryType, aiDescription: $aiDescription, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$EnrichedItemCopyWith<$Res> implements $EnrichedItemCopyWith<$Res> {
  factory _$EnrichedItemCopyWith(_EnrichedItem value, $Res Function(_EnrichedItem) _then) = __$EnrichedItemCopyWithImpl;
@override @useResult
$Res call({
 String name, String? price, String? description, String? category, List<String> ingredients, List<String> allergens, DietaryType dietaryType, String? aiDescription, String? imageUrl
});




}
/// @nodoc
class __$EnrichedItemCopyWithImpl<$Res>
    implements _$EnrichedItemCopyWith<$Res> {
  __$EnrichedItemCopyWithImpl(this._self, this._then);

  final _EnrichedItem _self;
  final $Res Function(_EnrichedItem) _then;

/// Create a copy of EnrichedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? price = freezed,Object? description = freezed,Object? category = freezed,Object? ingredients = null,Object? allergens = null,Object? dietaryType = null,Object? aiDescription = freezed,Object? imageUrl = freezed,}) {
  return _then(_EnrichedItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,allergens: null == allergens ? _self._allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>,dietaryType: null == dietaryType ? _self.dietaryType : dietaryType // ignore: cast_nullable_to_non_nullable
as DietaryType,aiDescription: freezed == aiDescription ? _self.aiDescription : aiDescription // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
