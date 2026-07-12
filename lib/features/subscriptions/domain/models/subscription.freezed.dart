// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  /// Unique identifier (UUID)
  String get id => throw _privateConstructorUsedError;

  /// Name of the subscription service
  String get name => throw _privateConstructorUsedError;

  /// Price per billing cycle
  double get price => throw _privateConstructorUsedError;

  /// Currency code ('EUR' or 'USD')
  String get currency => throw _privateConstructorUsedError;

  /// How often the subscription is billed
  BillingCycle get billingCycle => throw _privateConstructorUsedError;

  /// Category of the subscription
  SubscriptionCategory get category => throw _privateConstructorUsedError;

  /// Date when the subscription started
  DateTime get startDate => throw _privateConstructorUsedError;

  /// Next billing date
  DateTime get nextBillingDate => throw _privateConstructorUsedError;

  /// Optional description or notes
  String? get description => throw _privateConstructorUsedError;

  /// Domain for Logo.dev lookup (e.g., 'netflix.com')
  String? get domain => throw _privateConstructorUsedError;

  /// Hex color for letter avatar fallback (e.g., '#E50914')
  String? get brandColor => throw _privateConstructorUsedError;

  /// Reference to catalog item if created from catalog
  String? get catalogItemId => throw _privateConstructorUsedError;

  /// Whether the subscription is currently active
  bool get isActive => throw _privateConstructorUsedError;

  /// Date when the subscription was cancelled (if cancelled)
  DateTime? get cancelledDate => throw _privateConstructorUsedError;

  /// Timestamp when the record was created
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when the record was last updated
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
    Subscription value,
    $Res Function(Subscription) then,
  ) = _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    String currency,
    BillingCycle billingCycle,
    SubscriptionCategory category,
    DateTime startDate,
    DateTime nextBillingDate,
    String? description,
    String? domain,
    String? brandColor,
    String? catalogItemId,
    bool isActive,
    DateTime? cancelledDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? billingCycle = null,
    Object? category = null,
    Object? startDate = null,
    Object? nextBillingDate = null,
    Object? description = freezed,
    Object? domain = freezed,
    Object? brandColor = freezed,
    Object? catalogItemId = freezed,
    Object? isActive = null,
    Object? cancelledDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            billingCycle: null == billingCycle
                ? _value.billingCycle
                : billingCycle // ignore: cast_nullable_to_non_nullable
                      as BillingCycle,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as SubscriptionCategory,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            nextBillingDate: null == nextBillingDate
                ? _value.nextBillingDate
                : nextBillingDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            domain: freezed == domain
                ? _value.domain
                : domain // ignore: cast_nullable_to_non_nullable
                      as String?,
            brandColor: freezed == brandColor
                ? _value.brandColor
                : brandColor // ignore: cast_nullable_to_non_nullable
                      as String?,
            catalogItemId: freezed == catalogItemId
                ? _value.catalogItemId
                : catalogItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            cancelledDate: freezed == cancelledDate
                ? _value.cancelledDate
                : cancelledDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
    _$SubscriptionImpl value,
    $Res Function(_$SubscriptionImpl) then,
  ) = __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    String currency,
    BillingCycle billingCycle,
    SubscriptionCategory category,
    DateTime startDate,
    DateTime nextBillingDate,
    String? description,
    String? domain,
    String? brandColor,
    String? catalogItemId,
    bool isActive,
    DateTime? cancelledDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
    _$SubscriptionImpl _value,
    $Res Function(_$SubscriptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? billingCycle = null,
    Object? category = null,
    Object? startDate = null,
    Object? nextBillingDate = null,
    Object? description = freezed,
    Object? domain = freezed,
    Object? brandColor = freezed,
    Object? catalogItemId = freezed,
    Object? isActive = null,
    Object? cancelledDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$SubscriptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        billingCycle: null == billingCycle
            ? _value.billingCycle
            : billingCycle // ignore: cast_nullable_to_non_nullable
                  as BillingCycle,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as SubscriptionCategory,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        nextBillingDate: null == nextBillingDate
            ? _value.nextBillingDate
            : nextBillingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        domain: freezed == domain
            ? _value.domain
            : domain // ignore: cast_nullable_to_non_nullable
                  as String?,
        brandColor: freezed == brandColor
            ? _value.brandColor
            : brandColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        catalogItemId: freezed == catalogItemId
            ? _value.catalogItemId
            : catalogItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        cancelledDate: freezed == cancelledDate
            ? _value.cancelledDate
            : cancelledDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl extends _Subscription {
  const _$SubscriptionImpl({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.category,
    required this.startDate,
    required this.nextBillingDate,
    this.description,
    this.domain,
    this.brandColor,
    this.catalogItemId,
    this.isActive = true,
    this.cancelledDate,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  /// Unique identifier (UUID)
  @override
  final String id;

  /// Name of the subscription service
  @override
  final String name;

  /// Price per billing cycle
  @override
  final double price;

  /// Currency code ('EUR' or 'USD')
  @override
  final String currency;

  /// How often the subscription is billed
  @override
  final BillingCycle billingCycle;

  /// Category of the subscription
  @override
  final SubscriptionCategory category;

  /// Date when the subscription started
  @override
  final DateTime startDate;

  /// Next billing date
  @override
  final DateTime nextBillingDate;

  /// Optional description or notes
  @override
  final String? description;

  /// Domain for Logo.dev lookup (e.g., 'netflix.com')
  @override
  final String? domain;

  /// Hex color for letter avatar fallback (e.g., '#E50914')
  @override
  final String? brandColor;

  /// Reference to catalog item if created from catalog
  @override
  final String? catalogItemId;

  /// Whether the subscription is currently active
  @override
  @JsonKey()
  final bool isActive;

  /// Date when the subscription was cancelled (if cancelled)
  @override
  final DateTime? cancelledDate;

  /// Timestamp when the record was created
  @override
  final DateTime? createdAt;

  /// Timestamp when the record was last updated
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Subscription(id: $id, name: $name, price: $price, currency: $currency, billingCycle: $billingCycle, category: $category, startDate: $startDate, nextBillingDate: $nextBillingDate, description: $description, domain: $domain, brandColor: $brandColor, catalogItemId: $catalogItemId, isActive: $isActive, cancelledDate: $cancelledDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.billingCycle, billingCycle) ||
                other.billingCycle == billingCycle) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.nextBillingDate, nextBillingDate) ||
                other.nextBillingDate == nextBillingDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.brandColor, brandColor) ||
                other.brandColor == brandColor) &&
            (identical(other.catalogItemId, catalogItemId) ||
                other.catalogItemId == catalogItemId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.cancelledDate, cancelledDate) ||
                other.cancelledDate == cancelledDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    currency,
    billingCycle,
    category,
    startDate,
    nextBillingDate,
    description,
    domain,
    brandColor,
    catalogItemId,
    isActive,
    cancelledDate,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(this);
  }
}

abstract class _Subscription extends Subscription {
  const factory _Subscription({
    required final String id,
    required final String name,
    required final double price,
    required final String currency,
    required final BillingCycle billingCycle,
    required final SubscriptionCategory category,
    required final DateTime startDate,
    required final DateTime nextBillingDate,
    final String? description,
    final String? domain,
    final String? brandColor,
    final String? catalogItemId,
    final bool isActive,
    final DateTime? cancelledDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$SubscriptionImpl;
  const _Subscription._() : super._();

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  /// Unique identifier (UUID)
  @override
  String get id;

  /// Name of the subscription service
  @override
  String get name;

  /// Price per billing cycle
  @override
  double get price;

  /// Currency code ('EUR' or 'USD')
  @override
  String get currency;

  /// How often the subscription is billed
  @override
  BillingCycle get billingCycle;

  /// Category of the subscription
  @override
  SubscriptionCategory get category;

  /// Date when the subscription started
  @override
  DateTime get startDate;

  /// Next billing date
  @override
  DateTime get nextBillingDate;

  /// Optional description or notes
  @override
  String? get description;

  /// Domain for Logo.dev lookup (e.g., 'netflix.com')
  @override
  String? get domain;

  /// Hex color for letter avatar fallback (e.g., '#E50914')
  @override
  String? get brandColor;

  /// Reference to catalog item if created from catalog
  @override
  String? get catalogItemId;

  /// Whether the subscription is currently active
  @override
  bool get isActive;

  /// Date when the subscription was cancelled (if cancelled)
  @override
  DateTime? get cancelledDate;

  /// Timestamp when the record was created
  @override
  DateTime? get createdAt;

  /// Timestamp when the record was last updated
  @override
  DateTime? get updatedAt;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
