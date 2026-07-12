import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/subscriptions/domain/models/subscription.dart';

part 'notification_service.g.dart';

/// Service for managing local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/New_York'));

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

    await _plugin.zonedSchedule(
      subscription.id.hashCode,
      'Renewal Tomorrow',
      '${subscription.name} will renew tomorrow for \$${subscription.price.toStringAsFixed(2)}',
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
    await _plugin.cancel(subscriptionId.hashCode);
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

  /// Get all pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_initialized) await initialize();
    return _plugin.pendingNotificationRequests();
  }
}

/// Provider for notification service initialization
@riverpod
Future<void> notificationInit(Ref ref) async {
  await NotificationService.initialize();
}
