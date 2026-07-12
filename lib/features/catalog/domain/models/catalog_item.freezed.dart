// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CatalogItem _$CatalogItemFromJson(Map<String, dynamic> json) {
  return _CatalogItem.fromJson(json);
}

/// @nodoc
mixin _$CatalogItem {
  /// Unique identifier for the catalog item
  String get id => throw _privateConstructorUsedError;

  /// Name of the service
  String get name => throw _privateConstructorUsedError;

  /// Domain for Logo.dev lookup (e.g., 'netflix.com')
  String get domain => throw _privateConstructorUsedError;

  /// Hex color for brand identity (e.g., '#E50914')
  String get brandColor => throw _privateConstructorUsedError;

  /// Default price in USD
  double get defaultPriceUsd => throw _privateConstructorUsedError;

  /// Default price in EUR
  double get defaultPriceEur => throw _privateConstructorUsedError;

  /// Category of the service
  SubscriptionCategory get category => throw _privateConstructorUsedError;

  /// Default billing cycle
  BillingCycle get defaultCycle => throw _privateConstructorUsedError;

  /// Serializes this CatalogItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogItemCopyWith<CatalogItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogItemCopyWith<$Res> {
  factory $CatalogItemCopyWith(
    CatalogItem value,
    $Res Function(CatalogItem) then,
  ) = _$CatalogItemCopyWithImpl<$Res, CatalogItem>;
  @useResult
  $Res call({
    String id,
    String name,
    String domain,
    String brandColor,
    double defaultPriceUsd,
    double defaultPriceEur,
    SubscriptionCategory category,
    BillingCycle defaultCycle,
  });
}

/// @nodoc
class _$CatalogItemCopyWithImpl<$Res, $Val extends CatalogItem>
    implements $CatalogItemCopyWith<$Res> {
  _$CatalogItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? domain = null,
    Object? brandColor = null,
    Object? defaultPriceUsd = null,
    Object? defaultPriceEur = null,
    Object? category = null,
    Object? defaultCycle = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            domain: null == domain
                ? _value.domain
                : domain // ignore: cast_nullable_to_non_nullable
                      as String,
            brandColor: null == brandColor
                ? _value.brandColor
                : brandColor // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultPriceUsd: null == defaultPriceUsd
                ? _value.defaultPriceUsd
                : defaultPriceUsd // ignore: cast_nullable_to_non_nullable
                      as double,
            defaultPriceEur: null == defaultPriceEur
                ? _value.defaultPriceEur
                : defaultPriceEur // ignore: cast_nullable_to_non_nullable
                      as double,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as SubscriptionCategory,
            defaultCycle: null == defaultCycle
                ? _value.defaultCycle
                : defaultCycle // ignore: cast_nullable_to_non_nullable
                      as BillingCycle,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogItemImplCopyWith<$Res>
    implements $CatalogItemCopyWith<$Res> {
  factory _$$CatalogItemImplCopyWith(
    _$CatalogItemImpl value,
    $Res Function(_$CatalogItemImpl) then,
  ) = __$$CatalogItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String domain,
    String brandColor,
    double defaultPriceUsd,
    double defaultPriceEur,
    SubscriptionCategory category,
    BillingCycle defaultCycle,
  });
}

/// @nodoc
class __$$CatalogItemImplCopyWithImpl<$Res>
    extends _$CatalogItemCopyWithImpl<$Res, _$CatalogItemImpl>
    implements _$$CatalogItemImplCopyWith<$Res> {
  __$$CatalogItemImplCopyWithImpl(
    _$CatalogItemImpl _value,
    $Res Function(_$CatalogItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? domain = null,
    Object? brandColor = null,
    Object? defaultPriceUsd = null,
    Object? defaultPriceEur = null,
    Object? category = null,
    Object? defaultCycle = null,
  }) {
    return _then(
      _$CatalogItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        domain: null == domain
            ? _value.domain
            : domain // ignore: cast_nullable_to_non_nullable
                  as String,
        brandColor: null == brandColor
            ? _value.brandColor
            : brandColor // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultPriceUsd: null == defaultPriceUsd
            ? _value.defaultPriceUsd
            : defaultPriceUsd // ignore: cast_nullable_to_non_nullable
                  as double,
        defaultPriceEur: null == defaultPriceEur
            ? _value.defaultPriceEur
            : defaultPriceEur // ignore: cast_nullable_to_non_nullable
                  as double,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as SubscriptionCategory,
        defaultCycle: null == defaultCycle
            ? _value.defaultCycle
            : defaultCycle // ignore: cast_nullable_to_non_nullable
                  as BillingCycle,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogItemImpl extends _CatalogItem {
  const _$CatalogItemImpl({
    required this.id,
    required this.name,
    required this.domain,
    required this.brandColor,
    required this.defaultPriceUsd,
    required this.defaultPriceEur,
    required this.category,
    required this.defaultCycle,
  }) : super._();

  factory _$CatalogItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogItemImplFromJson(json);

  /// Unique identifier for the catalog item
  @override
  final String id;

  /// Name of the service
  @override
  final String name;

  /// Domain for Logo.dev lookup (e.g., 'netflix.com')
  @override
  final String domain;

  /// Hex color for brand identity (e.g., '#E50914')
  @override
  final String brandColor;

  /// Default price in USD
  @override
  final double defaultPriceUsd;

  /// Default price in EUR
  @override
  final double defaultPriceEur;

  /// Category of the service
  @override
  final SubscriptionCategory category;

  /// Default billing cycle
  @override
  final BillingCycle defaultCycle;

  @override
  String toString() {
    return 'CatalogItem(id: $id, name: $name, domain: $domain, brandColor: $brandColor, defaultPriceUsd: $defaultPriceUsd, defaultPriceEur: $defaultPriceEur, category: $category, defaultCycle: $defaultCycle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.brandColor, brandColor) ||
                other.brandColor == brandColor) &&
            (identical(other.defaultPriceUsd, defaultPriceUsd) ||
                other.defaultPriceUsd == defaultPriceUsd) &&
            (identical(other.defaultPriceEur, defaultPriceEur) ||
                other.defaultPriceEur == defaultPriceEur) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.defaultCycle, defaultCycle) ||
                other.defaultCycle == defaultCycle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    domain,
    brandColor,
    defaultPriceUsd,
    defaultPriceEur,
    category,
    defaultCycle,
  );

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogItemImplCopyWith<_$CatalogItemImpl> get copyWith =>
      __$$CatalogItemImplCopyWithImpl<_$CatalogItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogItemImplToJson(this);
  }
}

abstract class _CatalogItem extends CatalogItem {
  const factory _CatalogItem({
    required final String id,
    required final String name,
    required final String domain,
    required final String brandColor,
    required final double defaultPriceUsd,
    required final double defaultPriceEur,
    required final SubscriptionCategory category,
    required final BillingCycle defaultCycle,
  }) = _$CatalogItemImpl;
  const _CatalogItem._() : super._();

  factory _CatalogItem.fromJson(Map<String, dynamic> json) =
      _$CatalogItemImpl.fromJson;

  /// Unique identifier for the catalog item
  @override
  String get id;

  /// Name of the service
  @override
  String get name;

  /// Domain for Logo.dev lookup (e.g., 'netflix.com')
  @override
  String get domain;

  /// Hex color for brand identity (e.g., '#E50914')
  @override
  String get brandColor;

  /// Default price in USD
  @override
  double get defaultPriceUsd;

  /// Default price in EUR
  @override
  double get defaultPriceEur;

  /// Category of the service
  @override
  SubscriptionCategory get category;

  /// Default billing cycle
  @override
  BillingCycle get defaultCycle;

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogItemImplCopyWith<_$CatalogItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
