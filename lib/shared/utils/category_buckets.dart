import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../features/subscriptions/domain/models/subscription_category.dart';

/// A slice of the spend breakdown rendered with the accent shades
/// (segmented bar on Home, progress rows on Insights).
class CategoryBucket {
  const CategoryBucket({
    required this.label,
    required this.amount,
    required this.fraction,
    required this.color,
  });

  final String label;
  final double amount;
  final double fraction;
  final Color color;
}

/// Collapses per-category spend into at most four buckets: the top three
/// categories by amount plus an aggregated "Other", colored with the four
/// accent shades in descending order.
List<CategoryBucket> buildCategoryBuckets(
  Map<SubscriptionCategory, double> spendByCategory,
) {
  final total = spendByCategory.values.fold<double>(0, (a, b) => a + b);
  if (total <= 0) return const [];

  final entries = spendByCategory.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final buckets = <CategoryBucket>[];
  double otherAmount = 0;
  for (var i = 0; i < entries.length; i++) {
    if (i < 3) {
      buckets.add(CategoryBucket(
        label: entries[i].key.displayName,
        amount: entries[i].value,
        fraction: entries[i].value / total,
        color: AppColors.chartShades[i],
      ));
    } else {
      otherAmount += entries[i].value;
    }
  }
  if (otherAmount > 0) {
    buckets.add(CategoryBucket(
      label: 'Other',
      amount: otherAmount,
      fraction: otherAmount / total,
      color: AppColors.chartShades[3],
    ));
  }
  return buckets;
}
