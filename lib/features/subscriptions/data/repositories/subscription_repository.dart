import '../../../../core/database/daos/subscriptions_dao.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../domain/models/subscription.dart';
import '../../domain/models/subscription_category.dart';

/// Repository for managing subscriptions
/// Abstracts the data source (Drift DAO) from the presentation layer
class SubscriptionRepository {
  final SubscriptionsDao _dao;
  final bool _notificationsEnabled;

  SubscriptionRepository(this._dao, {bool notificationsEnabled = true})
      : _notificationsEnabled = notificationsEnabled;

  /// Watch all active subscriptions
  Stream<List<Subscription>> watchAllActive() => _dao.watchAllActive();

  /// Watch all cancelled subscriptions
  Stream<List<Subscription>> watchAllCancelled() => _dao.watchAllCancelled();

  /// Get a single subscription by ID
  Future<Subscription?> getById(String id) => _dao.getById(id);

  /// Watch a single subscription by ID
  Stream<Subscription?> watchById(String id) => _dao.watchById(id);

  /// Create a new subscription
  Future<void> addSubscription(Subscription subscription) async {
    await _dao.insertSubscription(subscription);
    if (_notificationsEnabled) {
      await NotificationService.scheduleRenewalReminder(subscription);
    }
  }

  /// Update an existing subscription
  Future<void> updateSubscription(Subscription subscription) async {
    await _dao.updateSubscription(subscription);
    if (_notificationsEnabled) {
      // Reschedule notification with updated info
      await NotificationService.cancelRenewalReminder(subscription.id);
      if (subscription.isActive) {
        await NotificationService.scheduleRenewalReminder(subscription);
      }
    }
  }

  /// Delete a subscription permanently
  Future<void> deleteSubscription(String id) async {
    await _dao.deleteSubscription(id);
    if (_notificationsEnabled) {
      await NotificationService.cancelRenewalReminder(id);
    }
  }

  /// Cancel a subscription (soft delete)
  Future<void> cancelSubscription(String id, DateTime cancelledDate) async {
    await _dao.cancelSubscription(id, cancelledDate);
    if (_notificationsEnabled) {
      await NotificationService.cancelRenewalReminder(id);
    }
  }

  /// Reactivate a cancelled subscription
  Future<void> reactivateSubscription(String id) async {
    await _dao.reactivateSubscription(id);
    if (_notificationsEnabled) {
      final subscription = await _dao.getById(id);
      if (subscription != null) {
        await NotificationService.scheduleRenewalReminder(subscription);
      }
    }
  }

  /// Watch subscriptions renewing within N days
  Stream<List<Subscription>> watchUpcomingRenewals({int days = 7}) =>
      _dao.watchUpcomingRenewals(days);

  /// Watch spend by category
  Stream<Map<SubscriptionCategory, double>> watchSpendByCategory() =>
      _dao.watchSpendByCategory();

  /// Watch total monthly spend
  Stream<double> watchTotalMonthlySpend() => _dao.watchTotalMonthlySpend();

  /// Watch count of active subscriptions
  Stream<int> watchActiveCount() => _dao.watchActiveCount();

  /// Advance the next billing date for a subscription
  Future<void> advanceNextBillingDate(String id, DateTime newDate) =>
      _dao.advanceNextBillingDate(id, newDate);

  /// Renew a subscription (advance billing date and reschedule notification)
  Future<void> renewSubscription(String id, DateTime newBillingDate) async {
    await _dao.advanceNextBillingDate(id, newBillingDate);
    if (_notificationsEnabled) {
      // Reschedule notification for the new billing date
      await NotificationService.cancelRenewalReminder(id);
      final subscription = await _dao.getById(id);
      if (subscription != null) {
        await NotificationService.scheduleRenewalReminder(subscription);
      }
    }
  }
}
