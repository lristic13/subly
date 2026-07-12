import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/currency_utils.dart';
import 'billing_cycle.dart';
import 'subscription_category.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

/// A subscription model representing a recurring expense
@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    /// Unique identifier (UUID)
    required String id,

    /// Name of the subscription service
    required String name,

    /// Price per billing cycle
    required double price,

    /// Currency code ('EUR' or 'USD')
    required String currency,

    /// How often the subscription is billed
    required BillingCycle billingCycle,

    /// Category of the subscription
    required SubscriptionCategory category,

    /// Date when the subscription started
    required DateTime startDate,

    /// Next billing date
    required DateTime nextBillingDate,

    /// Optional description or notes
    String? description,

    /// Domain for Logo.dev lookup (e.g., 'netflix.com')
    String? domain,

    /// Hex color for letter avatar fallback (e.g., '#E50914')
    String? brandColor,

    /// Reference to catalog item if created from catalog
    String? catalogItemId,

    /// End of the free trial period; null when there is no trial.
    /// The subscription costs nothing until this date — the first charge
    /// is expected when the trial ends.
    DateTime? trialEndDate,

    /// Whether the subscription is currently active
    @Default(true) bool isActive,

    /// Date when the subscription was cancelled (if cancelled)
    DateTime? cancelledDate,

    /// Timestamp when the record was created
    DateTime? createdAt,

    /// Timestamp when the record was last updated
    DateTime? updatedAt,
  }) = _Subscription;

  const Subscription._();

  /// Creates a Subscription from JSON
  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  /// Whether the free trial is still running.
  bool get isInTrial =>
      trialEndDate != null && trialEndDate!.isAfter(DateTime.now());

  /// Monthly cost that actually hits the wallet right now — zero while the
  /// free trial is running.
  double billableMonthlyCostIn(String displayCurrency) =>
      isInTrial ? 0 : monthlyCostIn(displayCurrency);

  /// Get the monthly cost of this subscription (in original currency)
  double get monthlyCost => billingCycle.toMonthly(price);

  /// Get the yearly cost of this subscription (in original currency)
  double get yearlyCost => billingCycle.toYearly(price);

  /// Get the price converted to a display currency
  double priceIn(String displayCurrency) =>
      CurrencyUtils.convert(price, currency, displayCurrency);

  /// Get the monthly cost converted to a display currency
  double monthlyCostIn(String displayCurrency) =>
      CurrencyUtils.convert(monthlyCost, currency, displayCurrency);

  /// Get the yearly cost converted to a display currency
  double yearlyCostIn(String displayCurrency) =>
      CurrencyUtils.convert(yearlyCost, currency, displayCurrency);

  /// Get days until next billing
  int get daysUntilNextBilling {
    final now = DateTime.now();
    final difference = nextBillingDate.difference(now);
    return difference.inDays;
  }

  /// Check if renewal is upcoming (within 7 days)
  bool get isRenewalUpcoming => daysUntilNextBilling <= 7 && daysUntilNextBilling >= 0;
}
