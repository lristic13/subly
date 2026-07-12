import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/subscriptions_dao.dart';
import '../../core/services/exchange_rate_service.dart';
import '../../core/utils/currency_utils.dart';
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

/// Provides the SubscriptionRepository
@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  final dao = ref.watch(subscriptionsDaoProvider);
  return SubscriptionRepository(dao);
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
