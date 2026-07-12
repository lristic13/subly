import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../../subscriptions/domain/models/subscription_category.dart';
import '../../domain/models/catalog_item.dart';
import '../../providers/catalog_providers.dart';
import '../widgets/catalog_list_tile.dart';

/// Screen for browsing and searching the subscription catalog
class CatalogSearchScreen extends ConsumerStatefulWidget {
  const CatalogSearchScreen({super.key});

  @override
  ConsumerState<CatalogSearchScreen> createState() =>
      _CatalogSearchScreenState();
}

class _CatalogSearchScreenState extends ConsumerState<CatalogSearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final currency = settings.valueOrNull?.currency ?? 'EUR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subscription'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search services...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Add Custom button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _addCustom(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Custom Subscription'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Catalog list
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildCategoryList(currency)
                : _buildSearchResults(currency),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(String currency) {
    final catalogByCategoryAsync = ref.watch(catalogByCategoryProvider);

    return catalogByCategoryAsync.when(
      data: (catalogByCategory) {
        return ListView.builder(
          itemCount: catalogByCategory.length,
          itemBuilder: (context, index) {
            final entry = catalogByCategory.entries.elementAt(index);
            final category = entry.key;
            final items = entry.value;

            return _CategorySection(
              category: category,
              items: items,
              currency: currency,
              onItemTap: (item) => _selectItem(context, item, currency),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSearchResults(String currency) {
    final searchResultsAsync = ref.watch(catalogSearchProvider(_searchQuery));

    return searchResultsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search or add a custom subscription.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return CatalogListTile(
              item: item,
              currency: currency,
              onTap: () => _selectItem(context, item, currency),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  void _selectItem(BuildContext context, CatalogItem item, String currency) {
    // Navigate to add screen with pre-filled data from catalog item
    context.push(
      '/subscriptions/add/from-catalog',
      extra: {
        'catalogItem': item,
        'currency': currency,
      },
    );
  }

  void _addCustom(BuildContext context) {
    context.push('/subscriptions/add/custom');
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.items,
    required this.currency,
    required this.onItemTap,
  });

  final SubscriptionCategory category;
  final List<CatalogItem> items;
  final String currency;
  final void Function(CatalogItem) onItemTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(
                category.icon,
                size: 20,
                color: category.color,
              ),
              const SizedBox(width: 8),
              Text(
                category.displayName,
                style: AppTypography.titleSmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${items.length})',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ...items.map(
          (item) => CatalogListTile(
            item: item,
            currency: currency,
            onTap: () => onItemTap(item),
          ),
        ),
      ],
    );
  }
}
