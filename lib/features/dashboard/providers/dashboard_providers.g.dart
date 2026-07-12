// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardStatsHash() => r'ffa2e8900d12f570228ae261e22b04f6fc4bc7d6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provides aggregated dashboard statistics with currency conversion
///
/// Copied from [dashboardStats].
@ProviderFor(dashboardStats)
const dashboardStatsProvider = DashboardStatsFamily();

/// Provides aggregated dashboard statistics with currency conversion
///
/// Copied from [dashboardStats].
class DashboardStatsFamily extends Family<AsyncValue<DashboardStats>> {
  /// Provides aggregated dashboard statistics with currency conversion
  ///
  /// Copied from [dashboardStats].
  const DashboardStatsFamily();

  /// Provides aggregated dashboard statistics with currency conversion
  ///
  /// Copied from [dashboardStats].
  DashboardStatsProvider call({String currency = 'EUR'}) {
    return DashboardStatsProvider(currency: currency);
  }

  @override
  DashboardStatsProvider getProviderOverride(
    covariant DashboardStatsProvider provider,
  ) {
    return call(currency: provider.currency);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardStatsProvider';
}

/// Provides aggregated dashboard statistics with currency conversion
///
/// Copied from [dashboardStats].
class DashboardStatsProvider extends AutoDisposeStreamProvider<DashboardStats> {
  /// Provides aggregated dashboard statistics with currency conversion
  ///
  /// Copied from [dashboardStats].
  DashboardStatsProvider({String currency = 'EUR'})
    : this._internal(
        (ref) => dashboardStats(ref as DashboardStatsRef, currency: currency),
        from: dashboardStatsProvider,
        name: r'dashboardStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dashboardStatsHash,
        dependencies: DashboardStatsFamily._dependencies,
        allTransitiveDependencies:
            DashboardStatsFamily._allTransitiveDependencies,
        currency: currency,
      );

  DashboardStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currency,
  }) : super.internal();

  final String currency;

  @override
  Override overrideWith(
    Stream<DashboardStats> Function(DashboardStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardStatsProvider._internal(
        (ref) => create(ref as DashboardStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currency: currency,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<DashboardStats> createElement() {
    return _DashboardStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardStatsProvider && other.currency == currency;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currency.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardStatsRef on AutoDisposeStreamProviderRef<DashboardStats> {
  /// The parameter `currency` of this provider.
  String get currency;
}

class _DashboardStatsProviderElement
    extends AutoDisposeStreamProviderElement<DashboardStats>
    with DashboardStatsRef {
  _DashboardStatsProviderElement(super.provider);

  @override
  String get currency => (origin as DashboardStatsProvider).currency;
}

String _$dashboardUpcomingRenewalsHash() =>
    r'34d113495b4898737e267f8235b3f1d9e208615d';

/// Provides upcoming renewals (next 7 days)
///
/// Copied from [dashboardUpcomingRenewals].
@ProviderFor(dashboardUpcomingRenewals)
final dashboardUpcomingRenewalsProvider =
    AutoDisposeStreamProvider<List<Subscription>>.internal(
      dashboardUpcomingRenewals,
      name: r'dashboardUpcomingRenewalsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardUpcomingRenewalsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardUpcomingRenewalsRef =
    AutoDisposeStreamProviderRef<List<Subscription>>;
String _$dashboardInsightHash() => r'764c65e32fa4fca9fdfb86c2dd4397d606af2a3e';

/// Provides contextual insights based on subscription data
///
/// Copied from [dashboardInsight].
@ProviderFor(dashboardInsight)
const dashboardInsightProvider = DashboardInsightFamily();

/// Provides contextual insights based on subscription data
///
/// Copied from [dashboardInsight].
class DashboardInsightFamily extends Family<AsyncValue<SublyInsight?>> {
  /// Provides contextual insights based on subscription data
  ///
  /// Copied from [dashboardInsight].
  const DashboardInsightFamily();

  /// Provides contextual insights based on subscription data
  ///
  /// Copied from [dashboardInsight].
  DashboardInsightProvider call({String currency = 'EUR'}) {
    return DashboardInsightProvider(currency: currency);
  }

  @override
  DashboardInsightProvider getProviderOverride(
    covariant DashboardInsightProvider provider,
  ) {
    return call(currency: provider.currency);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardInsightProvider';
}

/// Provides contextual insights based on subscription data
///
/// Copied from [dashboardInsight].
class DashboardInsightProvider
    extends AutoDisposeStreamProvider<SublyInsight?> {
  /// Provides contextual insights based on subscription data
  ///
  /// Copied from [dashboardInsight].
  DashboardInsightProvider({String currency = 'EUR'})
    : this._internal(
        (ref) =>
            dashboardInsight(ref as DashboardInsightRef, currency: currency),
        from: dashboardInsightProvider,
        name: r'dashboardInsightProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dashboardInsightHash,
        dependencies: DashboardInsightFamily._dependencies,
        allTransitiveDependencies:
            DashboardInsightFamily._allTransitiveDependencies,
        currency: currency,
      );

  DashboardInsightProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currency,
  }) : super.internal();

  final String currency;

  @override
  Override overrideWith(
    Stream<SublyInsight?> Function(DashboardInsightRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardInsightProvider._internal(
        (ref) => create(ref as DashboardInsightRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currency: currency,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<SublyInsight?> createElement() {
    return _DashboardInsightProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardInsightProvider && other.currency == currency;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currency.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardInsightRef on AutoDisposeStreamProviderRef<SublyInsight?> {
  /// The parameter `currency` of this provider.
  String get currency;
}

class _DashboardInsightProviderElement
    extends AutoDisposeStreamProviderElement<SublyInsight?>
    with DashboardInsightRef {
  _DashboardInsightProviderElement(super.provider);

  @override
  String get currency => (origin as DashboardInsightProvider).currency;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
