import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/logo_image.dart';
import '../../domain/models/catalog_item.dart';

/// List tile widget for displaying a catalog item
class CatalogListTile extends StatelessWidget {
  const CatalogListTile({
    super.key,
    required this.item,
    required this.currency,
    this.onTap,
  });

  final CatalogItem item;
  final String currency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final price = currency == 'EUR' ? item.defaultPriceEur : item.defaultPriceUsd;
    final currencyFormat = NumberFormat.currency(
      symbol: currency == 'EUR' ? '\u20AC' : '\$',
      decimalDigits: 2,
    );

    return ListTile(
      onTap: onTap,
      leading: LogoImage(
        name: item.name,
        domain: item.domain,
        brandColor: item.brandColor,
        size: 44,
      ),
      title: Text(
        item.name,
        style: AppTypography.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: item.category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.category.displayName,
              style: AppTypography.labelSmall.copyWith(
                color: item.category.color,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            currencyFormat.format(price),
            style: AppTypography.titleSmall.copyWith(
              color: isDark ? AppColors.primaryLight : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '/ ${item.defaultCycle.name}',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
