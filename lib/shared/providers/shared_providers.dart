import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/subscriptions_dao.dart';
import '../../core/services/exchange_rate_service.dart';
import '../../core/utils/currency_utils.dart';
import '../../features/settings/providers/settings_providers.dart';
import '../../features/subscriptions/data/repositories/subscription_repository.dart';

part 'shared_providers.g.dart';

/// Provides the database instance
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
}

/// Provides the SubscriptionsDao
@Riverpod(keepAlive: true)
SubscriptionsDao subscriptionsDao(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.subscriptionsDao;
}

/// Provides the SubscriptionRepository. Rebuilds when the renewal-reminders
/// setting changes so scheduling honors the toggle.
@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  final dao = ref.watch(subscriptionsDaoProvider);
  final remindersEnabled = ref.watch(
    settingsProvider.select((s) => s.valueOrNull?.renewalReminders ?? true),
  );
  return SubscriptionRepository(dao, remindersEnabled: remindersEnabled);
}

/// Startup maintenance: advances overdue billing dates and rebuilds the
/// notification schedule. Watched once from the app root; re-runs when the
/// repository rebuilds (e.g. the reminders toggle changes), which keeps the
/// pending notifications in sync with the setting.
@Riverpod(keepAlive: true)
Future<void> subscriptionMaintenance(Ref ref) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  await repository.runStartupMaintenance();
}

/// Provides the ExchangeRateService
@Riverpod(keepAlive: true)
ExchangeRateService exchangeRateService(Ref ref) {
  final service = ExchangeRateService();
  ref.onDispose(() => service.dispose());
  return service;
}

/// Provides the current exchange rates (cached)
@Riverpod(keepAlive: true)
Future<ExchangeRates> exchangeRates(Ref ref) async {
  final service = ref.watch(exchangeRateServiceProvider);

  try {
    final rates = await service.fetchLatestRates();
    // Sync rates to CurrencyUtils for static access
    _syncRatesToCurrencyUtils(rates);
    return rates;
  } catch (e) {
    // Return fallback rates if API fails
    final fallback = ExchangeRates.fallback();
    _syncRatesToCurrencyUtils(fallback);
    return fallback;
  }
}

/// Syncs exchange rates to CurrencyUtils for static access
void _syncRatesToCurrencyUtils(ExchangeRates rates) {
  // Import is at top of file, CurrencyUtils.setRates is called here
  // This allows the Subscription model methods to use live rates
  CurrencyUtils.setRates(rates);
}
