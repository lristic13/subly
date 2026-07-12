// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      billingCycle: $enumDecode(_$BillingCycleEnumMap, json['billingCycle']),
      category: $enumDecode(_$SubscriptionCategoryEnumMap, json['category']),
      startDate: DateTime.parse(json['startDate'] as String),
      nextBillingDate: DateTime.parse(json['nextBillingDate'] as String),
      description: json['description'] as String?,
      domain: json['domain'] as String?,
      brandColor: json['brandColor'] as String?,
      catalogItemId: json['catalogItemId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      cancelledDate: json['cancelledDate'] == null
          ? null
          : DateTime.parse(json['cancelledDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
      'billingCycle': _$BillingCycleEnumMap[instance.billingCycle]!,
      'category': _$SubscriptionCategoryEnumMap[instance.category]!,
      'startDate': instance.startDate.toIso8601String(),
      'nextBillingDate': instance.nextBillingDate.toIso8601String(),
      'description': instance.description,
      'domain': instance.domain,
      'brandColor': instance.brandColor,
      'catalogItemId': instance.catalogItemId,
      'isActive': instance.isActive,
      'cancelledDate': instance.cancelledDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$BillingCycleEnumMap = {
  BillingCycle.weekly: 'weekly',
  BillingCycle.monthly: 'monthly',
  BillingCycle.yearly: 'yearly',
};

const _$SubscriptionCategoryEnumMap = {
  SubscriptionCategory.streaming: 'streaming',
  SubscriptionCategory.music: 'music',
  SubscriptionCategory.gaming: 'gaming',
  SubscriptionCategory.software: 'software',
  SubscriptionCategory.cloud: 'cloud',
  SubscriptionCategory.news: 'news',
  SubscriptionCategory.fitness: 'fitness',
  SubscriptionCategory.food: 'food',
  SubscriptionCategory.education: 'education',
  SubscriptionCategory.finance: 'finance',
  SubscriptionCategory.shopping: 'shopping',
  SubscriptionCategory.productivity: 'productivity',
  SubscriptionCategory.social: 'social',
  SubscriptionCategory.vpn: 'vpn',
  SubscriptionCategory.other: 'other',
};
