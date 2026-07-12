import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../subscriptions/domain/models/subscription_category.dart';
import '../data/catalog_data.dart';
import '../domain/models/catalog_item.dart';

part 'catalog_providers.g.dart';

/// Provides the CatalogData instance
@Riverpod(keepAlive: true)
CatalogData catalogData(Ref ref) {
  return CatalogData();
}

/// Provides all catalog items
@riverpod
Future<List<CatalogItem>> catalogItems(Ref ref) async {
  final catalogData = ref.watch(catalogDataProvider);
  return catalogData.loadCatalog();
}

/// Provides catalog items filtered by search query
@riverpod
Future<List<CatalogItem>> catalogSearch(Ref ref, String query) async {
  final catalogData = ref.watch(catalogDataProvider);
  return catalogData.search(query);
}

/// Category display priority (lower = shown first)
const _categoryPriority = <SubscriptionCategory, int>{
  SubscriptionCategory.streaming: 0,
  SubscriptionCategory.music: 1,
  SubscriptionCategory.food: 2,
  SubscriptionCategory.cloud: 3,
  // All other categories get priority 100 and are sorted alphabetically
};

int _getCategoryPriority(SubscriptionCategory category) {
  return _categoryPriority[category] ?? 100;
}

/// Provides catalog items grouped by category
@riverpod
Future<Map<SubscriptionCategory, List<CatalogItem>>> catalogByCategory(
  Ref ref,
) async {
  final items = await ref.watch(catalogItemsProvider.future);

  final Map<SubscriptionCategory, List<CatalogItem>> grouped = {};
  for (final item in items) {
    grouped.putIfAbsent(item.category, () => []).add(item);
  }

  // Sort categories by priority, then alphabetically for same priority
  final sortedEntries = grouped.entries.toList()
    ..sort((a, b) {
      final priorityA = _getCategoryPriority(a.key);
      final priorityB = _getCategoryPriority(b.key);
      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }
      return a.key.displayName.compareTo(b.key.displayName);
    });

  return Map.fromEntries(sortedEntries);
}

/// Provides a single catalog item by ID
@riverpod
Future<CatalogItem?> catalogItemById(Ref ref, String id) async {
  final catalogData = ref.watch(catalogDataProvider);
  return catalogData.getById(id);
}
