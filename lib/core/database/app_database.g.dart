// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubscriptionsTableTable extends SubscriptionsTable
    with TableInfo<$SubscriptionsTableTable, SubscriptionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BillingCycle, String>
  billingCycle =
      GeneratedColumn<String>(
        'billing_cycle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BillingCycle>(
        $SubscriptionsTableTable.$converterbillingCycle,
      );
  @override
  late final GeneratedColumnWithTypeConverter<SubscriptionCategory, String>
  category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SubscriptionCategory>(
        $SubscriptionsTableTable.$convertercategory,
      );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextBillingDateMeta = const VerificationMeta(
    'nextBillingDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextBillingDate =
      GeneratedColumn<DateTime>(
        'next_billing_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandColorMeta = const VerificationMeta(
    'brandColor',
  );
  @override
  late final GeneratedColumn<String> brandColor = GeneratedColumn<String>(
    'brand_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catalogItemIdMeta = const VerificationMeta(
    'catalogItemId',
  );
  @override
  late final GeneratedColumn<String> catalogItemId = GeneratedColumn<String>(
    'catalog_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialEndDateMeta = const VerificationMeta(
    'trialEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> trialEndDate = GeneratedColumn<DateTime>(
    'trial_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _cancelledDateMeta = const VerificationMeta(
    'cancelledDate',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledDate =
      GeneratedColumn<DateTime>(
        'cancelled_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
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
    trialEndDate,
    isActive,
    cancelledDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_billing_date')) {
      context.handle(
        _nextBillingDateMeta,
        nextBillingDate.isAcceptableOrUnknown(
          data['next_billing_date']!,
          _nextBillingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextBillingDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    }
    if (data.containsKey('brand_color')) {
      context.handle(
        _brandColorMeta,
        brandColor.isAcceptableOrUnknown(data['brand_color']!, _brandColorMeta),
      );
    }
    if (data.containsKey('catalog_item_id')) {
      context.handle(
        _catalogItemIdMeta,
        catalogItemId.isAcceptableOrUnknown(
          data['catalog_item_id']!,
          _catalogItemIdMeta,
        ),
      );
    }
    if (data.containsKey('trial_end_date')) {
      context.handle(
        _trialEndDateMeta,
        trialEndDate.isAcceptableOrUnknown(
          data['trial_end_date']!,
          _trialEndDateMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('cancelled_date')) {
      context.handle(
        _cancelledDateMeta,
        cancelledDate.isAcceptableOrUnknown(
          data['cancelled_date']!,
          _cancelledDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      billingCycle: $SubscriptionsTableTable.$converterbillingCycle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}billing_cycle'],
        )!,
      ),
      category: $SubscriptionsTableTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextBillingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_billing_date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      domain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}domain'],
      ),
      brandColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_color'],
      ),
      catalogItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_item_id'],
      ),
      trialEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trial_end_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      cancelledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubscriptionsTableTable createAlias(String alias) {
    return $SubscriptionsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BillingCycle, String, String>
  $converterbillingCycle = const EnumNameConverter<BillingCycle>(
    BillingCycle.values,
  );
  static JsonTypeConverter2<SubscriptionCategory, String, String>
  $convertercategory = const EnumNameConverter<SubscriptionCategory>(
    SubscriptionCategory.values,
  );
}

class SubscriptionsTableData extends DataClass
    implements Insertable<SubscriptionsTableData> {
  /// Unique identifier (UUID)
  final String id;

  /// Name of the subscription service
  final String name;

  /// Price per billing cycle
  final double price;

  /// Currency code ('EUR' or 'USD')
  final String currency;

  /// Billing cycle enum
  final BillingCycle billingCycle;

  /// Category enum
  final SubscriptionCategory category;

  /// Date when the subscription started
  final DateTime startDate;

  /// Next billing date
  final DateTime nextBillingDate;

  /// Optional description or notes
  final String? description;

  /// Domain for Logo.dev lookup
  final String? domain;

  /// Hex color for letter avatar fallback
  final String? brandColor;

  /// Reference to catalog item if created from catalog
  final String? catalogItemId;

  /// End of the free trial period; null when the subscription has no trial.
  /// Until this date the subscription costs nothing; the first charge is
  /// expected at trial end.
  final DateTime? trialEndDate;

  /// Whether the subscription is currently active
  final bool isActive;

  /// Date when the subscription was cancelled
  final DateTime? cancelledDate;

  /// Timestamp when the record was created
  final DateTime createdAt;

  /// Timestamp when the record was last updated
  final DateTime updatedAt;
  const SubscriptionsTableData({
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
    this.trialEndDate,
    required this.isActive,
    this.cancelledDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['currency'] = Variable<String>(currency);
    {
      map['billing_cycle'] = Variable<String>(
        $SubscriptionsTableTable.$converterbillingCycle.toSql(billingCycle),
      );
    }
    {
      map['category'] = Variable<String>(
        $SubscriptionsTableTable.$convertercategory.toSql(category),
      );
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['next_billing_date'] = Variable<DateTime>(nextBillingDate);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || domain != null) {
      map['domain'] = Variable<String>(domain);
    }
    if (!nullToAbsent || brandColor != null) {
      map['brand_color'] = Variable<String>(brandColor);
    }
    if (!nullToAbsent || catalogItemId != null) {
      map['catalog_item_id'] = Variable<String>(catalogItemId);
    }
    if (!nullToAbsent || trialEndDate != null) {
      map['trial_end_date'] = Variable<DateTime>(trialEndDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || cancelledDate != null) {
      map['cancelled_date'] = Variable<DateTime>(cancelledDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubscriptionsTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsTableCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      currency: Value(currency),
      billingCycle: Value(billingCycle),
      category: Value(category),
      startDate: Value(startDate),
      nextBillingDate: Value(nextBillingDate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      domain: domain == null && nullToAbsent
          ? const Value.absent()
          : Value(domain),
      brandColor: brandColor == null && nullToAbsent
          ? const Value.absent()
          : Value(brandColor),
      catalogItemId: catalogItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogItemId),
      trialEndDate: trialEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(trialEndDate),
      isActive: Value(isActive),
      cancelledDate: cancelledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubscriptionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      billingCycle: $SubscriptionsTableTable.$converterbillingCycle.fromJson(
        serializer.fromJson<String>(json['billingCycle']),
      ),
      category: $SubscriptionsTableTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextBillingDate: serializer.fromJson<DateTime>(json['nextBillingDate']),
      description: serializer.fromJson<String?>(json['description']),
      domain: serializer.fromJson<String?>(json['domain']),
      brandColor: serializer.fromJson<String?>(json['brandColor']),
      catalogItemId: serializer.fromJson<String?>(json['catalogItemId']),
      trialEndDate: serializer.fromJson<DateTime?>(json['trialEndDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      cancelledDate: serializer.fromJson<DateTime?>(json['cancelledDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'currency': serializer.toJson<String>(currency),
      'billingCycle': serializer.toJson<String>(
        $SubscriptionsTableTable.$converterbillingCycle.toJson(billingCycle),
      ),
      'category': serializer.toJson<String>(
        $SubscriptionsTableTable.$convertercategory.toJson(category),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextBillingDate': serializer.toJson<DateTime>(nextBillingDate),
      'description': serializer.toJson<String?>(description),
      'domain': serializer.toJson<String?>(domain),
      'brandColor': serializer.toJson<String?>(brandColor),
      'catalogItemId': serializer.toJson<String?>(catalogItemId),
      'trialEndDate': serializer.toJson<DateTime?>(trialEndDate),
      'isActive': serializer.toJson<bool>(isActive),
      'cancelledDate': serializer.toJson<DateTime?>(cancelledDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubscriptionsTableData copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    BillingCycle? billingCycle,
    SubscriptionCategory? category,
    DateTime? startDate,
    DateTime? nextBillingDate,
    Value<String?> description = const Value.absent(),
    Value<String?> domain = const Value.absent(),
    Value<String?> brandColor = const Value.absent(),
    Value<String?> catalogItemId = const Value.absent(),
    Value<DateTime?> trialEndDate = const Value.absent(),
    bool? isActive,
    Value<DateTime?> cancelledDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SubscriptionsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    billingCycle: billingCycle ?? this.billingCycle,
    category: category ?? this.category,
    startDate: startDate ?? this.startDate,
    nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    description: description.present ? description.value : this.description,
    domain: domain.present ? domain.value : this.domain,
    brandColor: brandColor.present ? brandColor.value : this.brandColor,
    catalogItemId: catalogItemId.present
        ? catalogItemId.value
        : this.catalogItemId,
    trialEndDate: trialEndDate.present ? trialEndDate.value : this.trialEndDate,
    isActive: isActive ?? this.isActive,
    cancelledDate: cancelledDate.present
        ? cancelledDate.value
        : this.cancelledDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubscriptionsTableData copyWithCompanion(SubscriptionsTableCompanion data) {
    return SubscriptionsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      category: data.category.present ? data.category.value : this.category,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextBillingDate: data.nextBillingDate.present
          ? data.nextBillingDate.value
          : this.nextBillingDate,
      description: data.description.present
          ? data.description.value
          : this.description,
      domain: data.domain.present ? data.domain.value : this.domain,
      brandColor: data.brandColor.present
          ? data.brandColor.value
          : this.brandColor,
      catalogItemId: data.catalogItemId.present
          ? data.catalogItemId.value
          : this.catalogItemId,
      trialEndDate: data.trialEndDate.present
          ? data.trialEndDate.value
          : this.trialEndDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      cancelledDate: data.cancelledDate.present
          ? data.cancelledDate.value
          : this.cancelledDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('category: $category, ')
          ..write('startDate: $startDate, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('description: $description, ')
          ..write('domain: $domain, ')
          ..write('brandColor: $brandColor, ')
          ..write('catalogItemId: $catalogItemId, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('isActive: $isActive, ')
          ..write('cancelledDate: $cancelledDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
    trialEndDate,
    isActive,
    cancelledDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.billingCycle == this.billingCycle &&
          other.category == this.category &&
          other.startDate == this.startDate &&
          other.nextBillingDate == this.nextBillingDate &&
          other.description == this.description &&
          other.domain == this.domain &&
          other.brandColor == this.brandColor &&
          other.catalogItemId == this.catalogItemId &&
          other.trialEndDate == this.trialEndDate &&
          other.isActive == this.isActive &&
          other.cancelledDate == this.cancelledDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionsTableCompanion
    extends UpdateCompanion<SubscriptionsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String> currency;
  final Value<BillingCycle> billingCycle;
  final Value<SubscriptionCategory> category;
  final Value<DateTime> startDate;
  final Value<DateTime> nextBillingDate;
  final Value<String?> description;
  final Value<String?> domain;
  final Value<String?> brandColor;
  final Value<String?> catalogItemId;
  final Value<DateTime?> trialEndDate;
  final Value<bool> isActive;
  final Value<DateTime?> cancelledDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubscriptionsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.category = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.description = const Value.absent(),
    this.domain = const Value.absent(),
    this.brandColor = const Value.absent(),
    this.catalogItemId = const Value.absent(),
    this.trialEndDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.cancelledDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsTableCompanion.insert({
    required String id,
    required String name,
    required double price,
    required String currency,
    required BillingCycle billingCycle,
    required SubscriptionCategory category,
    required DateTime startDate,
    required DateTime nextBillingDate,
    this.description = const Value.absent(),
    this.domain = const Value.absent(),
    this.brandColor = const Value.absent(),
    this.catalogItemId = const Value.absent(),
    this.trialEndDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.cancelledDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       price = Value(price),
       currency = Value(currency),
       billingCycle = Value(billingCycle),
       category = Value(category),
       startDate = Value(startDate),
       nextBillingDate = Value(nextBillingDate);
  static Insertable<SubscriptionsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? billingCycle,
    Expression<String>? category,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextBillingDate,
    Expression<String>? description,
    Expression<String>? domain,
    Expression<String>? brandColor,
    Expression<String>? catalogItemId,
    Expression<DateTime>? trialEndDate,
    Expression<bool>? isActive,
    Expression<DateTime>? cancelledDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (category != null) 'category': category,
      if (startDate != null) 'start_date': startDate,
      if (nextBillingDate != null) 'next_billing_date': nextBillingDate,
      if (description != null) 'description': description,
      if (domain != null) 'domain': domain,
      if (brandColor != null) 'brand_color': brandColor,
      if (catalogItemId != null) 'catalog_item_id': catalogItemId,
      if (trialEndDate != null) 'trial_end_date': trialEndDate,
      if (isActive != null) 'is_active': isActive,
      if (cancelledDate != null) 'cancelled_date': cancelledDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? price,
    Value<String>? currency,
    Value<BillingCycle>? billingCycle,
    Value<SubscriptionCategory>? category,
    Value<DateTime>? startDate,
    Value<DateTime>? nextBillingDate,
    Value<String?>? description,
    Value<String?>? domain,
    Value<String?>? brandColor,
    Value<String?>? catalogItemId,
    Value<DateTime?>? trialEndDate,
    Value<bool>? isActive,
    Value<DateTime?>? cancelledDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubscriptionsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      description: description ?? this.description,
      domain: domain ?? this.domain,
      brandColor: brandColor ?? this.brandColor,
      catalogItemId: catalogItemId ?? this.catalogItemId,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      isActive: isActive ?? this.isActive,
      cancelledDate: cancelledDate ?? this.cancelledDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(
        $SubscriptionsTableTable.$converterbillingCycle.toSql(
          billingCycle.value,
        ),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $SubscriptionsTableTable.$convertercategory.toSql(category.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextBillingDate.present) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (brandColor.present) {
      map['brand_color'] = Variable<String>(brandColor.value);
    }
    if (catalogItemId.present) {
      map['catalog_item_id'] = Variable<String>(catalogItemId.value);
    }
    if (trialEndDate.present) {
      map['trial_end_date'] = Variable<DateTime>(trialEndDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (cancelledDate.present) {
      map['cancelled_date'] = Variable<DateTime>(cancelledDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('category: $category, ')
          ..write('startDate: $startDate, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('description: $description, ')
          ..write('domain: $domain, ')
          ..write('brandColor: $brandColor, ')
          ..write('catalogItemId: $catalogItemId, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('isActive: $isActive, ')
          ..write('cancelledDate: $cancelledDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubscriptionsTableTable subscriptionsTable =
      $SubscriptionsTableTable(this);
  late final SubscriptionsDao subscriptionsDao = SubscriptionsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [subscriptionsTable];
}

typedef $$SubscriptionsTableTableCreateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      required String id,
      required String name,
      required double price,
      required String currency,
      required BillingCycle billingCycle,
      required SubscriptionCategory category,
      required DateTime startDate,
      required DateTime nextBillingDate,
      Value<String?> description,
      Value<String?> domain,
      Value<String?> brandColor,
      Value<String?> catalogItemId,
      Value<DateTime?> trialEndDate,
      Value<bool> isActive,
      Value<DateTime?> cancelledDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SubscriptionsTableTableUpdateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> price,
      Value<String> currency,
      Value<BillingCycle> billingCycle,
      Value<SubscriptionCategory> category,
      Value<DateTime> startDate,
      Value<DateTime> nextBillingDate,
      Value<String?> description,
      Value<String?> domain,
      Value<String?> brandColor,
      Value<String?> catalogItemId,
      Value<DateTime?> trialEndDate,
      Value<bool> isActive,
      Value<DateTime?> cancelledDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SubscriptionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BillingCycle, BillingCycle, String>
  get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    SubscriptionCategory,
    SubscriptionCategory,
    String
  >
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandColor => $composableBuilder(
    column: $table.brandColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledDate => $composableBuilder(
    column: $table.cancelledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubscriptionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandColor => $composableBuilder(
    column: $table.brandColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledDate => $composableBuilder(
    column: $table.cancelledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BillingCycle, String> get billingCycle =>
      $composableBuilder(
        column: $table.billingCycle,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SubscriptionCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);

  GeneratedColumn<String> get brandColor => $composableBuilder(
    column: $table.brandColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledDate => $composableBuilder(
    column: $table.cancelledDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubscriptionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData,
          $$SubscriptionsTableTableFilterComposer,
          $$SubscriptionsTableTableOrderingComposer,
          $$SubscriptionsTableTableAnnotationComposer,
          $$SubscriptionsTableTableCreateCompanionBuilder,
          $$SubscriptionsTableTableUpdateCompanionBuilder,
          (
            SubscriptionsTableData,
            BaseReferences<
              _$AppDatabase,
              $SubscriptionsTableTable,
              SubscriptionsTableData
            >,
          ),
          SubscriptionsTableData,
          PrefetchHooks Function()
        > {
  $$SubscriptionsTableTableTableManager(
    _$AppDatabase db,
    $SubscriptionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<BillingCycle> billingCycle = const Value.absent(),
                Value<SubscriptionCategory> category = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> nextBillingDate = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> domain = const Value.absent(),
                Value<String?> brandColor = const Value.absent(),
                Value<String?> catalogItemId = const Value.absent(),
                Value<DateTime?> trialEndDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> cancelledDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsTableCompanion(
                id: id,
                name: name,
                price: price,
                currency: currency,
                billingCycle: billingCycle,
                category: category,
                startDate: startDate,
                nextBillingDate: nextBillingDate,
                description: description,
                domain: domain,
                brandColor: brandColor,
                catalogItemId: catalogItemId,
                trialEndDate: trialEndDate,
                isActive: isActive,
                cancelledDate: cancelledDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required double price,
                required String currency,
                required BillingCycle billingCycle,
                required SubscriptionCategory category,
                required DateTime startDate,
                required DateTime nextBillingDate,
                Value<String?> description = const Value.absent(),
                Value<String?> domain = const Value.absent(),
                Value<String?> brandColor = const Value.absent(),
                Value<String?> catalogItemId = const Value.absent(),
                Value<DateTime?> trialEndDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> cancelledDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsTableCompanion.insert(
                id: id,
                name: name,
                price: price,
                currency: currency,
                billingCycle: billingCycle,
                category: category,
                startDate: startDate,
                nextBillingDate: nextBillingDate,
                description: description,
                domain: domain,
                brandColor: brandColor,
                catalogItemId: catalogItemId,
                trialEndDate: trialEndDate,
                isActive: isActive,
                cancelledDate: cancelledDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubscriptionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTableTable,
      SubscriptionsTableData,
      $$SubscriptionsTableTableFilterComposer,
      $$SubscriptionsTableTableOrderingComposer,
      $$SubscriptionsTableTableAnnotationComposer,
      $$SubscriptionsTableTableCreateCompanionBuilder,
      $$SubscriptionsTableTableUpdateCompanionBuilder,
      (
        SubscriptionsTableData,
        BaseReferences<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData
        >,
      ),
      SubscriptionsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(_db, _db.subscriptionsTable);
}
