import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/subscriptions/domain/models/subscription.dart';
import '../utils/currency_utils.dart';

/// Service for managing local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database and set the device's local zone so
    // scheduled reminders fire at local wall-clock time.
    tz.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Keep the timezone package default (UTC) if detection fails —
      // reminders shift by the UTC offset but still fire.
    }

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions on iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Create Android notification channel
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'renewal_reminders',
            'Renewal Reminders',
            description: 'Notifications for upcoming subscription renewals',
            importance: Importance.high,
          ),
        );

    _initialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to subscription detail
    // The payload contains the subscription ID
  }

  /// Stable 31-bit notification id derived from the subscription UUID.
  /// FNV-1a rather than String.hashCode, which isn't guaranteed stable
  /// across Dart versions — a changed hash would orphan scheduled
  /// notifications after an SDK upgrade.
  static int notificationId(String subscriptionId) {
    var hash = 0x811c9dc5;
    for (final unit in subscriptionId.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash & 0x7FFFFFFF;
  }

  /// Schedule a renewal reminder for a subscription
  static Future<void> scheduleRenewalReminder(Subscription subscription) async {
    if (!_initialized) await initialize();

    // Schedule notification for 1 day before
    final reminderDate = subscription.nextBillingDate.subtract(const Duration(days: 1));

    // Don't schedule if the reminder date is in the past
    if (reminderDate.isBefore(DateTime.now())) return;

    // Schedule at 9 AM on the reminder day
    final scheduledDate = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9,
      0,
    );

    // Don't schedule if it's in the past
    if (scheduledDate.isBefore(DateTime.now())) return;

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    final symbol = CurrencyUtils.getSymbol(subscription.currency);
    final amount = '$symbol${subscription.price.toStringAsFixed(2)}';
    final isTrialConversion = subscription.trialEndDate != null &&
        !subscription.trialEndDate!.isBefore(reminderDate);

    await _plugin.zonedSchedule(
      notificationId(subscription.id),
      isTrialConversion ? 'Trial Ending Tomorrow' : 'Renewal Tomorrow',
      isTrialConversion
          ? '${subscription.name}\'s free trial ends tomorrow — you\'ll be charged $amount'
          : '${subscription.name} will renew tomorrow for $amount',
      tzScheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'renewal_reminders',
          'Renewal Reminders',
          channelDescription: 'Notifications for upcoming subscription renewals',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: subscription.id,
    );
  }

  /// Cancel a scheduled reminder for a subscription
  static Future<void> cancelRenewalReminder(String subscriptionId) async {
    if (!_initialized) await initialize();
    await _plugin.cancel(notificationId(subscriptionId));
  }

  /// Cancel every pending reminder (used when reminders are turned off)
  static Future<void> cancelAll() async {
    if (!_initialized) await initialize();
    await _plugin.cancelAll();
  }

  /// Reschedule all reminders (call on app start)
  static Future<void> rescheduleAllReminders(
    List<Subscription> subscriptions,
  ) async {
    if (!_initialized) await initialize();

    // Cancel all existing notifications first
    await _plugin.cancelAll();

    // Schedule new ones for active subscriptions
    for (final subscription in subscriptions) {
      await scheduleRenewalReminder(subscription);
    }
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (!_initialized) await initialize();

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      return await androidPlugin.areNotificationsEnabled() ?? false;
    }

    // For iOS, we assume enabled if initialized
    return true;
  }
}
