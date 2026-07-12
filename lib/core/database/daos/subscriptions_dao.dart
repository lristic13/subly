import 'package:drift/drift.dart';

import '../../../features/subscriptions/domain/models/subscription.dart';
import '../../../features/subscriptions/domain/models/subscription_category.dart';
import '../app_database.dart';
import '../tables/subscriptions_table.dart';

part 'subscriptions_dao.g.dart';

/// Data Access Object for subscriptions table
@DriftAccessor(tables: [SubscriptionsTable])
class SubscriptionsDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionsDaoMixin {
  SubscriptionsDao(super.db);

  /// Convert a database row to a domain Subscription model
  Subscription _rowToSubscription(SubscriptionsTableData row) {
    return Subscription(
      id: row.id,
      name: row.name,
      price: row.price,
      currency: row.currency,
      billingCycle: row.billingCycle,
      category: row.category,
      startDate: row.startDate,
      nextBillingDate: row.nextBillingDate,
      description: row.description,
      domain: row.domain,
      brandColor: row.brandColor,
      catalogItemId: row.catalogItemId,
      isActive: row.isActive,
      cancelledDate: row.cancelledDate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// Watch all active subscriptions
  Stream<List<Subscription>> watchAllActive() {
    final query = select(subscriptionsTable)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.nextBillingDate)]);

    return query.watch().map((rows) => rows.map(_rowToSubscription).toList());
  }

  /// Watch all cancelled subscriptions
  Stream<List<Subscription>> watchAllCancelled() {
    final query = select(subscriptionsTable)
      ..where((t) => t.isActive.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.cancelledDate)]);

    return query.watch().map((rows) => rows.map(_rowToSubscription).toList());
  }

  /// Get a single subscription by ID
  Future<Subscription?> getById(String id) async {
    final query = select(subscriptionsTable)
      ..where((t) => t.id.equals(id));

    final row = await query.getSingleOrNull();
    return row == null ? null : _rowToSubscription(row);
  }

  /// Watch a single subscription by ID
  Stream<Subscription?> watchById(String id) {
    final query = select(subscriptionsTable)
      ..where((t) => t.id.equals(id));

    return query.watchSingleOrNull().map(
          (row) => row == null ? null : _rowToSubscription(row),
        );
  }

  /// Insert a new subscription
  Future<void> insertSubscription(Subscription subscription) {
    return into(subscriptionsTable).insert(
      SubscriptionsTableCompanion.insert(
        id: subscription.id,
        name: subscription.name,
        price: subscription.price,
        currency: subscription.currency,
        billingCycle: subscription.billingCycle,
        category: subscription.category,
        startDate: subscription.startDate,
        nextBillingDate: subscription.nextBillingDate,
        description: Value(subscription.description),
        domain: Value(subscription.domain),
        brandColor: Value(subscription.brandColor),
        catalogItemId: Value(subscription.catalogItemId),
        isActive: Value(subscription.isActive),
        cancelledDate: Value(subscription.cancelledDate),
      ),
    );
  }

  /// Update an existing subscription
  Future<void> updateSubscription(Subscription subscription) {
    return (update(subscriptionsTable)
          ..where((t) => t.id.equals(subscription.id)))
        .write(
      SubscriptionsTableCompanion(
        name: Value(subscription.name),
        price: Value(subscription.price),
        currency: Value(subscription.currency),
        billingCycle: Value(subscription.billingCycle),
        category: Value(subscription.category),
        startDate: Value(subscription.startDate),
        nextBillingDate: Value(subscription.nextBillingDate),
        description: Value(subscription.description),
        domain: Value(subscription.domain),
        brandColor: Value(subscription.brandColor),
        catalogItemId: Value(subscription.catalogItemId),
        isActive: Value(subscription.isActive),
        cancelledDate: Value(subscription.cancelledDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a subscription (hard delete)
  Future<void> deleteSubscription(String id) {
    return (delete(subscriptionsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Cancel a subscription (soft delete)
  Future<void> cancelSubscription(String id, DateTime cancelledDate) {
    return (update(subscriptionsTable)..where((t) => t.id.equals(id))).write(
      SubscriptionsTableCompanion(
        isActive: const Value(false),
        cancelledDate: Value(cancelledDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Reactivate a cancelled subscription
  Future<void> reactivateSubscription(String id) {
    return (update(subscriptionsTable)..where((t) => t.id.equals(id))).write(
      SubscriptionsTableCompanion(
        isActive: const Value(true),
        cancelledDate: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Watch subscriptions renewing within N days
  Stream<List<Subscription>> watchUpcomingRenewals(int days) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    final query = select(subscriptionsTable)
      ..where((t) => t.isActive.equals(true))
      ..where((t) => t.nextBillingDate.isBetweenValues(now, endDate))
      ..orderBy([(t) => OrderingTerm.asc(t.nextBillingDate)]);

    return query.watch().map((rows) => rows.map(_rowToSubscription).toList());
  }

  /// Watch spend by category (returns Map of category to total monthly spend)
  Stream<Map<SubscriptionCategory, double>> watchSpendByCategory() {
    return watchAllActive().map((subscriptions) {
      final Map<SubscriptionCategory, double> result = {};
      for (final sub in subscriptions) {
        final category = sub.category;
        final monthlyCost = sub.monthlyCost;
        result[category] = (result[category] ?? 0) + monthlyCost;
      }
      return result;
    });
  }

  /// Watch total monthly spend for all active subscriptions
  Stream<double> watchTotalMonthlySpend() {
    return watchAllActive().map((subscriptions) {
      return subscriptions.fold<double>(
        0,
        (total, sub) => total + sub.monthlyCost,
      );
    });
  }

  /// Watch count of active subscriptions
  Stream<int> watchActiveCount() {
    return watchAllActive().map((subscriptions) => subscriptions.length);
  }

  /// Update the next billing date for a subscription
  Future<void> advanceNextBillingDate(String id, DateTime newDate) {
    return (update(subscriptionsTable)..where((t) => t.id.equals(id))).write(
      SubscriptionsTableCompanion(
        nextBillingDate: Value(newDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
