// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogItemImpl _$$CatalogItemImplFromJson(Map<String, dynamic> json) =>
    _$CatalogItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      domain: json['domain'] as String,
      brandColor: json['brandColor'] as String,
      defaultPriceUsd: (json['defaultPriceUsd'] as num).toDouble(),
      defaultPriceEur: (json['defaultPriceEur'] as num).toDouble(),
      category: $enumDecode(_$SubscriptionCategoryEnumMap, json['category']),
      defaultCycle: $enumDecode(_$BillingCycleEnumMap, json['defaultCycle']),
    );

Map<String, dynamic> _$$CatalogItemImplToJson(_$CatalogItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'domain': instance.domain,
      'brandColor': instance.brandColor,
      'defaultPriceUsd': instance.defaultPriceUsd,
      'defaultPriceEur': instance.defaultPriceEur,
      'category': _$SubscriptionCategoryEnumMap[instance.category]!,
      'defaultCycle': _$BillingCycleEnumMap[instance.defaultCycle]!,
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

const _$BillingCycleEnumMap = {
  BillingCycle.weekly: 'weekly',
  BillingCycle.monthly: 'monthly',
  BillingCycle.yearly: 'yearly',
};
