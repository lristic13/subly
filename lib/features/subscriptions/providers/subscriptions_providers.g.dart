// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeSubscriptionsHash() =>
    r'cbbed40de81bdfec8712ca93d2baa13c977eb974';

/// Watch all active subscriptions
///
/// Copied from [activeSubscriptions].
@ProviderFor(activeSubscriptions)
final activeSubscriptionsProvider =
    AutoDisposeStreamProvider<List<Subscription>>.internal(
      activeSubscriptions,
      name: r'activeSubscriptionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeSubscriptionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveSubscriptionsRef =
    AutoDisposeStreamProviderRef<List<Subscription>>;
String _$cancelledSubscriptionsHash() =>
    r'40aad672f74084b4c332b98efcc86d5e4b3af6a3';

/// Watch all cancelled subscriptions
///
/// Copied from [cancelledSubscriptions].
@ProviderFor(cancelledSubscriptions)
final cancelledSubscriptionsProvider =
    AutoDisposeStreamProvider<List<Subscription>>.internal(
      cancelledSubscriptions,
      name: r'cancelledSubscriptionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cancelledSubscriptionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CancelledSubscriptionsRef =
    AutoDisposeStreamProviderRef<List<Subscription>>;
String _$subscriptionByIdHash() => r'c45d004440806dbb69aa9a7c8bea339cfc11d172';

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

/// Watch a single subscription by ID
///
/// Copied from [subscriptionById].
@ProviderFor(subscriptionById)
const subscriptionByIdProvider = SubscriptionByIdFamily();

/// Watch a single subscription by ID
///
/// Copied from [subscriptionById].
class SubscriptionByIdFamily extends Family<AsyncValue<Subscription?>> {
  /// Watch a single subscription by ID
  ///
  /// Copied from [subscriptionById].
  const SubscriptionByIdFamily();

  /// Watch a single subscription by ID
  ///
  /// Copied from [subscriptionById].
  SubscriptionByIdProvider call(String id) {
    return SubscriptionByIdProvider(id);
  }

  @override
  SubscriptionByIdProvider getProviderOverride(
    covariant SubscriptionByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subscriptionByIdProvider';
}

/// Watch a single subscription by ID
///
/// Copied from [subscriptionById].
class SubscriptionByIdProvider
    extends AutoDisposeStreamProvider<Subscription?> {
  /// Watch a single subscription by ID
  ///
  /// Copied from [subscriptionById].
  SubscriptionByIdProvider(String id)
    : this._internal(
        (ref) => subscriptionById(ref as SubscriptionByIdRef, id),
        from: subscriptionByIdProvider,
        name: r'subscriptionByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subscriptionByIdHash,
        dependencies: SubscriptionByIdFamily._dependencies,
        allTransitiveDependencies:
            SubscriptionByIdFamily._allTransitiveDependencies,
        id: id,
      );

  SubscriptionByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Subscription?> Function(SubscriptionByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubscriptionByIdProvider._internal(
        (ref) => create(ref as SubscriptionByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Subscription?> createElement() {
    return _SubscriptionByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubscriptionByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubscriptionByIdRef on AutoDisposeStreamProviderRef<Subscription?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SubscriptionByIdProviderElement
    extends AutoDisposeStreamProviderElement<Subscription?>
    with SubscriptionByIdRef {
  _SubscriptionByIdProviderElement(super.provider);

  @override
  String get id => (origin as SubscriptionByIdProvider).id;
}

String _$upcomingRenewalsHash() => r'746076e8a050e323c028b05518808ebfdc52f25e';

/// Watch subscriptions with upcoming renewals
///
/// Copied from [upcomingRenewals].
@ProviderFor(upcomingRenewals)
const upcomingRenewalsProvider = UpcomingRenewalsFamily();

/// Watch subscriptions with upcoming renewals
///
/// Copied from [upcomingRenewals].
class UpcomingRenewalsFamily extends Family<AsyncValue<List<Subscription>>> {
  /// Watch subscriptions with upcoming renewals
  ///
  /// Copied from [upcomingRenewals].
  const UpcomingRenewalsFamily();

  /// Watch subscriptions with upcoming renewals
  ///
  /// Copied from [upcomingRenewals].
  UpcomingRenewalsProvider call({int days = 7}) {
    return UpcomingRenewalsProvider(days: days);
  }

  @override
  UpcomingRenewalsProvider getProviderOverride(
    covariant UpcomingRenewalsProvider provider,
  ) {
    return call(days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'upcomingRenewalsProvider';
}

/// Watch subscriptions with upcoming renewals
///
/// Copied from [upcomingRenewals].
class UpcomingRenewalsProvider
    extends AutoDisposeStreamProvider<List<Subscription>> {
  /// Watch subscriptions with upcoming renewals
  ///
  /// Copied from [upcomingRenewals].
  UpcomingRenewalsProvider({int days = 7})
    : this._internal(
        (ref) => upcomingRenewals(ref as UpcomingRenewalsRef, days: days),
        from: upcomingRenewalsProvider,
        name: r'upcomingRenewalsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$upcomingRenewalsHash,
        dependencies: UpcomingRenewalsFamily._dependencies,
        allTransitiveDependencies:
            UpcomingRenewalsFamily._allTransitiveDependencies,
        days: days,
      );

  UpcomingRenewalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    Stream<List<Subscription>> Function(UpcomingRenewalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpcomingRenewalsProvider._internal(
        (ref) => create(ref as UpcomingRenewalsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Subscription>> createElement() {
    return _UpcomingRenewalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingRenewalsProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpcomingRenewalsRef on AutoDisposeStreamProviderRef<List<Subscription>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _UpcomingRenewalsProviderElement
    extends AutoDisposeStreamProviderElement<List<Subscription>>
    with UpcomingRenewalsRef {
  _UpcomingRenewalsProviderElement(super.provider);

  @override
  int get days => (origin as UpcomingRenewalsProvider).days;
}

String _$totalMonthlySpendHash() => r'797dd16c58089f9c453850df50186933aa3b2a2f';

/// Watch total monthly spend
///
/// Copied from [totalMonthlySpend].
@ProviderFor(totalMonthlySpend)
final totalMonthlySpendProvider = AutoDisposeStreamProvider<double>.internal(
  totalMonthlySpend,
  name: r'totalMonthlySpendProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalMonthlySpendHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalMonthlySpendRef = AutoDisposeStreamProviderRef<double>;
String _$spendByCategoryHash() => r'f4fff603c390146a34a931cf2c220ce88f757b2c';

/// Watch spend by category
///
/// Copied from [spendByCategory].
@ProviderFor(spendByCategory)
final spendByCategoryProvider =
    AutoDisposeStreamProvider<Map<SubscriptionCategory, double>>.internal(
      spendByCategory,
      name: r'spendByCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$spendByCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SpendByCategoryRef =
    AutoDisposeStreamProviderRef<Map<SubscriptionCategory, double>>;
String _$activeSubscriptionCountHash() =>
    r'c331d36af7bdba856077c952cf8f0fac2bbdbf93';

/// Watch count of active subscriptions
///
/// Copied from [activeSubscriptionCount].
@ProviderFor(activeSubscriptionCount)
final activeSubscriptionCountProvider = AutoDisposeStreamProvider<int>.internal(
  activeSubscriptionCount,
  name: r'activeSubscriptionCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeSubscriptionCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveSubscriptionCountRef = AutoDisposeStreamProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
