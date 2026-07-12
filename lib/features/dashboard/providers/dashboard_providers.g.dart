// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardStatsHash() => r'2d78ba45258b015a4989fa3d7d660a695003f9a6';

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
class DashboardStatsProvider extends AutoDisposeFutureProvider<DashboardStats> {
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
    FutureOr<DashboardStats> Function(DashboardStatsRef provider) create,
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
  AutoDisposeFutureProviderElement<DashboardStats> createElement() {
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
mixin DashboardStatsRef on AutoDisposeFutureProviderRef<DashboardStats> {
  /// The parameter `currency` of this provider.
  String get currency;
}

class _DashboardStatsProviderElement
    extends AutoDisposeFutureProviderElement<DashboardStats>
    with DashboardStatsRef {
  _DashboardStatsProviderElement(super.provider);

  @override
  String get currency => (origin as DashboardStatsProvider).currency;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
