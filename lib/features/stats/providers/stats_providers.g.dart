// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statsSummaryHash() => r'7ec387a49a31b784b32aa9313d8d38ff3cb3ef0a';

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

/// Provides overall statistics summary with currency conversion
///
/// Copied from [statsSummary].
@ProviderFor(statsSummary)
const statsSummaryProvider = StatsSummaryFamily();

/// Provides overall statistics summary with currency conversion
///
/// Copied from [statsSummary].
class StatsSummaryFamily extends Family<AsyncValue<StatsSummary>> {
  /// Provides overall statistics summary with currency conversion
  ///
  /// Copied from [statsSummary].
  const StatsSummaryFamily();

  /// Provides overall statistics summary with currency conversion
  ///
  /// Copied from [statsSummary].
  StatsSummaryProvider call({String currency = 'EUR'}) {
    return StatsSummaryProvider(currency: currency);
  }

  @override
  StatsSummaryProvider getProviderOverride(
    covariant StatsSummaryProvider provider,
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
  String? get name => r'statsSummaryProvider';
}

/// Provides overall statistics summary with currency conversion
///
/// Copied from [statsSummary].
class StatsSummaryProvider extends AutoDisposeStreamProvider<StatsSummary> {
  /// Provides overall statistics summary with currency conversion
  ///
  /// Copied from [statsSummary].
  StatsSummaryProvider({String currency = 'EUR'})
    : this._internal(
        (ref) => statsSummary(ref as StatsSummaryRef, currency: currency),
        from: statsSummaryProvider,
        name: r'statsSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$statsSummaryHash,
        dependencies: StatsSummaryFamily._dependencies,
        allTransitiveDependencies:
            StatsSummaryFamily._allTransitiveDependencies,
        currency: currency,
      );

  StatsSummaryProvider._internal(
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
    Stream<StatsSummary> Function(StatsSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StatsSummaryProvider._internal(
        (ref) => create(ref as StatsSummaryRef),
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
  AutoDisposeStreamProviderElement<StatsSummary> createElement() {
    return _StatsSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StatsSummaryProvider && other.currency == currency;
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
mixin StatsSummaryRef on AutoDisposeStreamProviderRef<StatsSummary> {
  /// The parameter `currency` of this provider.
  String get currency;
}

class _StatsSummaryProviderElement
    extends AutoDisposeStreamProviderElement<StatsSummary>
    with StatsSummaryRef {
  _StatsSummaryProviderElement(super.provider);

  @override
  String get currency => (origin as StatsSummaryProvider).currency;
}

String _$categoryStatsHash() => r'a7e0c2b5cd3fb366db5af4b268ebb9d27ded9644';

/// Provides category-wise statistics with currency conversion
///
/// Copied from [categoryStats].
@ProviderFor(categoryStats)
const categoryStatsProvider = CategoryStatsFamily();

/// Provides category-wise statistics with currency conversion
///
/// Copied from [categoryStats].
class CategoryStatsFamily extends Family<AsyncValue<List<CategoryStats>>> {
  /// Provides category-wise statistics with currency conversion
  ///
  /// Copied from [categoryStats].
  const CategoryStatsFamily();

  /// Provides category-wise statistics with currency conversion
  ///
  /// Copied from [categoryStats].
  CategoryStatsProvider call({String currency = 'EUR'}) {
    return CategoryStatsProvider(currency: currency);
  }

  @override
  CategoryStatsProvider getProviderOverride(
    covariant CategoryStatsProvider provider,
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
  String? get name => r'categoryStatsProvider';
}

/// Provides category-wise statistics with currency conversion
///
/// Copied from [categoryStats].
class CategoryStatsProvider
    extends AutoDisposeStreamProvider<List<CategoryStats>> {
  /// Provides category-wise statistics with currency conversion
  ///
  /// Copied from [categoryStats].
  CategoryStatsProvider({String currency = 'EUR'})
    : this._internal(
        (ref) => categoryStats(ref as CategoryStatsRef, currency: currency),
        from: categoryStatsProvider,
        name: r'categoryStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryStatsHash,
        dependencies: CategoryStatsFamily._dependencies,
        allTransitiveDependencies:
            CategoryStatsFamily._allTransitiveDependencies,
        currency: currency,
      );

  CategoryStatsProvider._internal(
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
    Stream<List<CategoryStats>> Function(CategoryStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryStatsProvider._internal(
        (ref) => create(ref as CategoryStatsRef),
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
  AutoDisposeStreamProviderElement<List<CategoryStats>> createElement() {
    return _CategoryStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryStatsProvider && other.currency == currency;
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
mixin CategoryStatsRef on AutoDisposeStreamProviderRef<List<CategoryStats>> {
  /// The parameter `currency` of this provider.
  String get currency;
}

class _CategoryStatsProviderElement
    extends AutoDisposeStreamProviderElement<List<CategoryStats>>
    with CategoryStatsRef {
  _CategoryStatsProviderElement(super.provider);

  @override
  String get currency => (origin as CategoryStatsProvider).currency;
}

String _$projectedSpendingHash() => r'4cb7f862749ae0960c3658407d262c2802e5ef24';

/// Provides projected spending for future months with currency conversion
///
/// Copied from [projectedSpending].
@ProviderFor(projectedSpending)
const projectedSpendingProvider = ProjectedSpendingFamily();

/// Provides projected spending for future months with currency conversion
///
/// Copied from [projectedSpending].
class ProjectedSpendingFamily
    extends Family<AsyncValue<List<MonthlySpendPoint>>> {
  /// Provides projected spending for future months with currency conversion
  ///
  /// Copied from [projectedSpending].
  const ProjectedSpendingFamily();

  /// Provides projected spending for future months with currency conversion
  ///
  /// Copied from [projectedSpending].
  ProjectedSpendingProvider call({String currency = 'EUR'}) {
    return ProjectedSpendingProvider(currency: currency);
  }

  @override
  ProjectedSpendingProvider getProviderOverride(
    covariant ProjectedSpendingProvider provider,
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
  String? get name => r'projectedSpendingProvider';
}

/// Provides projected spending for future months with currency conversion
///
/// Copied from [projectedSpending].
class ProjectedSpendingProvider
    extends AutoDisposeStreamProvider<List<MonthlySpendPoint>> {
  /// Provides projected spending for future months with currency conversion
  ///
  /// Copied from [projectedSpending].
  ProjectedSpendingProvider({String currency = 'EUR'})
    : this._internal(
        (ref) =>
            projectedSpending(ref as ProjectedSpendingRef, currency: currency),
        from: projectedSpendingProvider,
        name: r'projectedSpendingProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$projectedSpendingHash,
        dependencies: ProjectedSpendingFamily._dependencies,
        allTransitiveDependencies:
            ProjectedSpendingFamily._allTransitiveDependencies,
        currency: currency,
      );

  ProjectedSpendingProvider._internal(
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
    Stream<List<MonthlySpendPoint>> Function(ProjectedSpendingRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectedSpendingProvider._internal(
        (ref) => create(ref as ProjectedSpendingRef),
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
  AutoDisposeStreamProviderElement<List<MonthlySpendPoint>> createElement() {
    return _ProjectedSpendingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectedSpendingProvider && other.currency == currency;
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
mixin ProjectedSpendingRef
    on AutoDisposeStreamProviderRef<List<MonthlySpendPoint>> {
  /// The parameter `currency` of this provider.
  String get currency;
}

class _ProjectedSpendingProviderElement
    extends AutoDisposeStreamProviderElement<List<MonthlySpendPoint>>
    with ProjectedSpendingRef {
  _ProjectedSpendingProviderElement(super.provider);

  @override
  String get currency => (origin as ProjectedSpendingProvider).currency;
}

String _$billingCycleDistributionHash() =>
    r'db9b3c04ef7d0ecec85cf8298e00c61f8b324ade';

/// Provides billing cycle distribution
///
/// Copied from [billingCycleDistribution].
@ProviderFor(billingCycleDistribution)
final billingCycleDistributionProvider =
    AutoDisposeStreamProvider<Map<String, int>>.internal(
      billingCycleDistribution,
      name: r'billingCycleDistributionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$billingCycleDistributionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillingCycleDistributionRef =
    AutoDisposeStreamProviderRef<Map<String, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
