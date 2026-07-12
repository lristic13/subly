import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../subscriptions/domain/models/billing_cycle.dart';
import '../../../subscriptions/domain/models/subscription_category.dart';

part 'catalog_item.freezed.dart';
part 'catalog_item.g.dart';

/// A catalog item representing a popular subscription service
@freezed
class CatalogItem with _$CatalogItem {
  const factory CatalogItem({
    /// Unique identifier for the catalog item
    required String id,

    /// Name of the service
    required String name,

    /// Domain for Logo.dev lookup (e.g., 'netflix.com')
    required String domain,

    /// Hex color for brand identity (e.g., '#E50914')
    required String brandColor,

    /// Default price in USD
    required double defaultPriceUsd,

    /// Default price in EUR
    required double defaultPriceEur,

    /// Category of the service
    required SubscriptionCategory category,

    /// Default billing cycle
    required BillingCycle defaultCycle,
  }) = _CatalogItem;

  const CatalogItem._();

  /// Creates a CatalogItem from JSON
  factory CatalogItem.fromJson(Map<String, dynamic> json) =>
      _$CatalogItemFromJson(json);

  /// Get the default price for a given currency
  double defaultPriceForCurrency(String currency) {
    return currency.toUpperCase() == 'EUR' ? defaultPriceEur : defaultPriceUsd;
  }
}
