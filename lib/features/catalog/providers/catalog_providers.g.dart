// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$catalogDataHash() => r'1d808dcaccb1a1cf866462b6e0364bbfade1bb9e';

/// Provides the CatalogData instance
///
/// Copied from [catalogData].
@ProviderFor(catalogData)
final catalogDataProvider = Provider<CatalogData>.internal(
  catalogData,
  name: r'catalogDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$catalogDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatalogDataRef = ProviderRef<CatalogData>;
String _$catalogItemsHash() => r'fe63c06008d6f6516d1cd22c386492e8b0fa1ade';

/// Provides all catalog items
///
/// Copied from [catalogItems].
@ProviderFor(catalogItems)
final catalogItemsProvider =
    AutoDisposeFutureProvider<List<CatalogItem>>.internal(
      catalogItems,
      name: r'catalogItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$catalogItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatalogItemsRef = AutoDisposeFutureProviderRef<List<CatalogItem>>;
String _$catalogSearchHash() => r'9f91801a7203130938d12cf8f151135dbbf864ff';

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

/// Provides catalog items filtered by search query
///
/// Copied from [catalogSearch].
@ProviderFor(catalogSearch)
const catalogSearchProvider = CatalogSearchFamily();

/// Provides catalog items filtered by search query
///
/// Copied from [catalogSearch].
class CatalogSearchFamily extends Family<AsyncValue<List<CatalogItem>>> {
  /// Provides catalog items filtered by search query
  ///
  /// Copied from [catalogSearch].
  const CatalogSearchFamily();

  /// Provides catalog items filtered by search query
  ///
  /// Copied from [catalogSearch].
  CatalogSearchProvider call(String query) {
    return CatalogSearchProvider(query);
  }

  @override
  CatalogSearchProvider getProviderOverride(
    covariant CatalogSearchProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'catalogSearchProvider';
}

/// Provides catalog items filtered by search query
///
/// Copied from [catalogSearch].
class CatalogSearchProvider
    extends AutoDisposeFutureProvider<List<CatalogItem>> {
  /// Provides catalog items filtered by search query
  ///
  /// Copied from [catalogSearch].
  CatalogSearchProvider(String query)
    : this._internal(
        (ref) => catalogSearch(ref as CatalogSearchRef, query),
        from: catalogSearchProvider,
        name: r'catalogSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$catalogSearchHash,
        dependencies: CatalogSearchFamily._dependencies,
        allTransitiveDependencies:
            CatalogSearchFamily._allTransitiveDependencies,
        query: query,
      );

  CatalogSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<CatalogItem>> Function(CatalogSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CatalogSearchProvider._internal(
        (ref) => create(ref as CatalogSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CatalogItem>> createElement() {
    return _CatalogSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CatalogSearchRef on AutoDisposeFutureProviderRef<List<CatalogItem>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _CatalogSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<CatalogItem>>
    with CatalogSearchRef {
  _CatalogSearchProviderElement(super.provider);

  @override
  String get query => (origin as CatalogSearchProvider).query;
}

String _$catalogByCategoryHash() => r'3b2f7c49a8107fb1ff73f03172e578f53ce2c4b3';

/// Provides catalog items grouped by category
///
/// Copied from [catalogByCategory].
@ProviderFor(catalogByCategory)
final catalogByCategoryProvider =
    AutoDisposeFutureProvider<
      Map<SubscriptionCategory, List<CatalogItem>>
    >.internal(
      catalogByCategory,
      name: r'catalogByCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$catalogByCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatalogByCategoryRef =
    AutoDisposeFutureProviderRef<Map<SubscriptionCategory, List<CatalogItem>>>;
String _$catalogItemByIdHash() => r'07d29d451a7b697ec7be0db6b3f5a08f5e86e7ef';

/// Provides a single catalog item by ID
///
/// Copied from [catalogItemById].
@ProviderFor(catalogItemById)
const catalogItemByIdProvider = CatalogItemByIdFamily();

/// Provides a single catalog item by ID
///
/// Copied from [catalogItemById].
class CatalogItemByIdFamily extends Family<AsyncValue<CatalogItem?>> {
  /// Provides a single catalog item by ID
  ///
  /// Copied from [catalogItemById].
  const CatalogItemByIdFamily();

  /// Provides a single catalog item by ID
  ///
  /// Copied from [catalogItemById].
  CatalogItemByIdProvider call(String id) {
    return CatalogItemByIdProvider(id);
  }

  @override
  CatalogItemByIdProvider getProviderOverride(
    covariant CatalogItemByIdProvider provider,
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
  String? get name => r'catalogItemByIdProvider';
}

/// Provides a single catalog item by ID
///
/// Copied from [catalogItemById].
class CatalogItemByIdProvider extends AutoDisposeFutureProvider<CatalogItem?> {
  /// Provides a single catalog item by ID
  ///
  /// Copied from [catalogItemById].
  CatalogItemByIdProvider(String id)
    : this._internal(
        (ref) => catalogItemById(ref as CatalogItemByIdRef, id),
        from: catalogItemByIdProvider,
        name: r'catalogItemByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$catalogItemByIdHash,
        dependencies: CatalogItemByIdFamily._dependencies,
        allTransitiveDependencies:
            CatalogItemByIdFamily._allTransitiveDependencies,
        id: id,
      );

  CatalogItemByIdProvider._internal(
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
    FutureOr<CatalogItem?> Function(CatalogItemByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CatalogItemByIdProvider._internal(
        (ref) => create(ref as CatalogItemByIdRef),
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
  AutoDisposeFutureProviderElement<CatalogItem?> createElement() {
    return _CatalogItemByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogItemByIdProvider && other.id == id;
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
mixin CatalogItemByIdRef on AutoDisposeFutureProviderRef<CatalogItem?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CatalogItemByIdProviderElement
    extends AutoDisposeFutureProviderElement<CatalogItem?>
    with CatalogItemByIdRef {
  _CatalogItemByIdProviderElement(super.provider);

  @override
  String get id => (origin as CatalogItemByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
