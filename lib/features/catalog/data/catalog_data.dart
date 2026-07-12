import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models/catalog_item.dart';

/// Loads and parses the catalog JSON from assets
class CatalogData {
  static const String _catalogAssetPath = 'assets/catalog/catalog.json';

  List<CatalogItem>? _cachedItems;

  /// Load all catalog items from the JSON asset
  Future<List<CatalogItem>> loadCatalog() async {
    if (_cachedItems != null) {
      return _cachedItems!;
    }

    final jsonString = await rootBundle.loadString(_catalogAssetPath);
    final List<dynamic> jsonList = json.decode(jsonString);

    _cachedItems = jsonList
        .map((json) => CatalogItem.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedItems!;
  }

  /// Search catalog items by name (case-insensitive)
  Future<List<CatalogItem>> search(String query) async {
    final items = await loadCatalog();
    if (query.isEmpty) {
      return items;
    }

    final lowerQuery = query.toLowerCase();
    return items
        .where((item) => item.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get catalog items by category
  Future<List<CatalogItem>> getByCategory(String category) async {
    final items = await loadCatalog();
    return items.where((item) => item.category.name == category).toList();
  }

  /// Get a single catalog item by ID
  Future<CatalogItem?> getById(String id) async {
    final items = await loadCatalog();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Clear the cache (useful for testing or refreshing)
  void clearCache() {
    _cachedItems = null;
  }
}
