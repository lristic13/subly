// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'3a45fd58ddfbdc9ee2377249534ba8231737b935';

/// Provides the database instance
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$subscriptionsDaoHash() => r'fdbf9145e67447f3f6a3dc6c0c862d4ed7f0cb94';

/// Provides the SubscriptionsDao
///
/// Copied from [subscriptionsDao].
@ProviderFor(subscriptionsDao)
final subscriptionsDaoProvider = Provider<SubscriptionsDao>.internal(
  subscriptionsDao,
  name: r'subscriptionsDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionsDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionsDaoRef = ProviderRef<SubscriptionsDao>;
String _$subscriptionRepositoryHash() =>
    r'cf426a6117e45209b0ffd54d8c8d8087329ca6bc';

/// Provides the SubscriptionRepository. Rebuilds when the renewal-reminders
/// setting changes so scheduling honors the toggle.
///
/// Copied from [subscriptionRepository].
@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider =
    Provider<SubscriptionRepository>.internal(
      subscriptionRepository,
      name: r'subscriptionRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionRepositoryRef = ProviderRef<SubscriptionRepository>;
String _$subscriptionMaintenanceHash() =>
    r'af5b2c02b999a57ed32ee08d3eb022b957aa776f';

/// Startup maintenance: advances overdue billing dates and rebuilds the
/// notification schedule. Watched once from the app root; re-runs when the
/// repository rebuilds (e.g. the reminders toggle changes), which keeps the
/// pending notifications in sync with the setting.
///
/// Copied from [subscriptionMaintenance].
@ProviderFor(subscriptionMaintenance)
final subscriptionMaintenanceProvider = FutureProvider<void>.internal(
  subscriptionMaintenance,
  name: r'subscriptionMaintenanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionMaintenanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionMaintenanceRef = FutureProviderRef<void>;
String _$exchangeRateServiceHash() =>
    r'6c928f500ff9c96dd5bafcf031b4e32063f3c38a';

/// Provides the ExchangeRateService
///
/// Copied from [exchangeRateService].
@ProviderFor(exchangeRateService)
final exchangeRateServiceProvider = Provider<ExchangeRateService>.internal(
  exchangeRateService,
  name: r'exchangeRateServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exchangeRateServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExchangeRateServiceRef = ProviderRef<ExchangeRateService>;
String _$exchangeRatesHash() => r'cf89291a516855b1c0643135b7e872cb3586fdea';

/// Provides the current exchange rates (cached)
///
/// Copied from [exchangeRates].
@ProviderFor(exchangeRates)
final exchangeRatesProvider = FutureProvider<ExchangeRates>.internal(
  exchangeRates,
  name: r'exchangeRatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exchangeRatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExchangeRatesRef = FutureProviderRef<ExchangeRates>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
