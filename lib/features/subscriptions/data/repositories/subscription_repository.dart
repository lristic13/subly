import '../../../../core/database/daos/subscriptions_dao.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../domain/models/subscription.dart';
import '../../domain/models/subscription_category.dart';

/// Repository for managing subscriptions
/// Abstracts the data source (Drift DAO) from the presentation layer
class SubscriptionRepository {
  final SubscriptionsDao _dao;

  /// Whether renewal reminders should be scheduled — wired to the
  /// "Renewal reminders" setting.
  final bool remindersEnabled;

  SubscriptionRepository(this._dao, {this.remindersEnabled = true});

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
    if (remindersEnabled && subscription.isActive) {
      await NotificationService.scheduleRenewalReminder(subscription);
    }
  }

  /// Update an existing subscription
  Future<void> updateSubscription(Subscription subscription) async {
    await _dao.updateSubscription(subscription);
    // Reschedule notification with updated info
    await NotificationService.cancelRenewalReminder(subscription.id);
    if (remindersEnabled && subscription.isActive) {
      await NotificationService.scheduleRenewalReminder(subscription);
    }
  }

  /// Delete a subscription permanently
  Future<void> deleteSubscription(String id) async {
    await _dao.deleteSubscription(id);
    await NotificationService.cancelRenewalReminder(id);
  }

  /// Cancel a subscription (soft delete)
  Future<void> cancelSubscription(String id, DateTime cancelledDate) async {
    await _dao.cancelSubscription(id, cancelledDate);
    await NotificationService.cancelRenewalReminder(id);
  }

  /// Reactivate a cancelled subscription
  Future<void> reactivateSubscription(String id) async {
    await _dao.reactivateSubscription(id);
    if (remindersEnabled) {
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

  /// Startup maintenance: roll every overdue billing date forward to its
  /// next future occurrence (billing dates otherwise go stale — nothing
  /// else advances them), then rebuild the pending-notification schedule.
  Future<void> runStartupMaintenance() async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    for (final subscription in await _dao.getOverdueActive()) {
      var next = subscription.nextBillingDate;
      while (next.isBefore(startOfToday)) {
        next = subscription.billingCycle.nextBillingDate(next);
      }
      await _dao.advanceNextBillingDate(subscription.id, next);
    }

    await rescheduleAllReminders();
  }

  /// Rebuild the notification schedule from scratch for all active
  /// subscriptions, honoring the reminders setting.
  Future<void> rescheduleAllReminders() async {
    if (!remindersEnabled) {
      await NotificationService.cancelAll();
      return;
    }
    final active = await _dao.watchAllActive().first;
    await NotificationService.rescheduleAllReminders(active);
  }
}
