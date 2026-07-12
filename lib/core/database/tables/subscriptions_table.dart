import 'package:drift/drift.dart';

import '../../../features/subscriptions/domain/models/billing_cycle.dart';
import '../../../features/subscriptions/domain/models/subscription_category.dart';

/// Drift table definition for subscriptions
class SubscriptionsTable extends Table {
  @override
  String get tableName => 'subscriptions';

  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// Name of the subscription service
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Price per billing cycle
  RealColumn get price => real()();

  /// Currency code ('EUR' or 'USD')
  TextColumn get currency => text().withLength(min: 3, max: 3)();

  /// Billing cycle enum
  TextColumn get billingCycle => textEnum<BillingCycle>()();

  /// Category enum
  TextColumn get category => textEnum<SubscriptionCategory>()();

  /// Date when the subscription started
  DateTimeColumn get startDate => dateTime()();

  /// Next billing date
  DateTimeColumn get nextBillingDate => dateTime()();

  /// Optional description or notes
  TextColumn get description => text().nullable()();

  /// Domain for Logo.dev lookup
  TextColumn get domain => text().nullable()();

  /// Hex color for letter avatar fallback
  TextColumn get brandColor => text().nullable()();

  /// Reference to catalog item if created from catalog
  TextColumn get catalogItemId => text().nullable()();

  /// End of the free trial period; null when the subscription has no trial.
  /// Until this date the subscription costs nothing; the first charge is
  /// expected at trial end.
  DateTimeColumn get trialEndDate => dateTime().nullable()();

  /// Whether the subscription is currently active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Date when the subscription was cancelled
  DateTimeColumn get cancelledDate => dateTime().nullable()();

  /// Timestamp when the record was created
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the record was last updated
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
