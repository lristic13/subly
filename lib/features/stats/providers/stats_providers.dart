import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../subscriptions/domain/models/subscription.dart';
import '../../subscriptions/domain/models/subscription_category.dart';
import '../../subscriptions/providers/subscriptions_providers.dart';

part 'stats_providers.g.dart';

/// Monthly spending data point for charts
class MonthlySpendPoint {
  final DateTime month;
  final double amount;

  const MonthlySpendPoint({
    required this.month,
    required this.amount,
  });
}

/// Category statistics
class CategoryStats {
  final SubscriptionCategory category;
  final double monthlySpend;
  final double yearlySpend;
  final int subscriptionCount;
  final double percentageOfTotal;

  const CategoryStats({
    required this.category,
    required this.monthlySpend,
    required this.yearlySpend,
    required this.subscriptionCount,
    required this.percentageOfTotal,
  });
}

/// Overall statistics summary
class StatsSummary {
  final double totalMonthlySpend;
  final double totalYearlySpend;
  final int totalSubscriptions;
  final double averagePerSubscription;
  final double costPerDay;
  final double costPerWeek;
  final SubscriptionCategory? topCategory;
  final double? topCategorySpend;
  final Subscription? mostExpensive;
  final Subscription? cheapest;
  final String displayCurrency;

  const StatsSummary({
    required this.totalMonthlySpend,
    required this.totalYearlySpend,
    required this.totalSubscriptions,
    required this.averagePerSubscription,
    required this.costPerDay,
    required this.costPerWeek,
    required this.displayCurrency,
    this.topCategory,
    this.topCategorySpend,
    this.mostExpensive,
    this.cheapest,
  });
}

/// Provides overall statistics summary with currency conversion
@riverpod
Stream<StatsSummary> statsSummary(Ref ref, {String currency = 'EUR'}) {
  final subscriptionsAsync = ref.watch(activeSubscriptionsProvider);

  return subscriptionsAsync.when(
    data: (subscriptions) {
      if (subscriptions.isEmpty) {
        return Stream.value(StatsSummary(
          totalMonthlySpend: 0,
          totalYearlySpend: 0,
          totalSubscriptions: 0,
          averagePerSubscription: 0,
          costPerDay: 0,
          costPerWeek: 0,
          displayCurrency: currency,
        ));
      }

      double totalMonthly = 0;
      final categorySpend = <SubscriptionCategory, double>{};
      Subscription? mostExpensive;
      Subscription? cheapest;
      double mostExpensiveAmount = 0;
      double cheapestAmount = double.infinity;

      for (final sub in subscriptions) {
        final monthly = sub.monthlyCostIn(currency);
        totalMonthly += monthly;
        categorySpend[sub.category] =
            (categorySpend[sub.category] ?? 0) + monthly;

        if (monthly > mostExpensiveAmount) {
          mostExpensive = sub;
          mostExpensiveAmount = monthly;
        }
        if (monthly < cheapestAmount) {
          cheapest = sub;
          cheapestAmount = monthly;
        }
      }

      // Find top category
      SubscriptionCategory? topCategory;
      double topCategorySpend = 0;
      for (final entry in categorySpend.entries) {
        if (entry.value > topCategorySpend) {
          topCategory = entry.key;
          topCategorySpend = entry.value;
        }
      }

      return Stream.value(StatsSummary(
        totalMonthlySpend: totalMonthly,
        totalYearlySpend: totalMonthly * 12,
        totalSubscriptions: subscriptions.length,
        averagePerSubscription: totalMonthly / subscriptions.length,
        costPerDay: totalMonthly / 30,
        costPerWeek: totalMonthly / 4.33,
        topCategory: topCategory,
        topCategorySpend: topCategorySpend,
        mostExpensive: mostExpensive,
        cheapest: cheapest,
        displayCurrency: currency,
      ));
    },
    loading: () => const Stream.empty(),
    error: (e, _) => Stream.error(e),
  );
}

/// Provides category-wise statistics with currency conversion
@riverpod
Stream<List<CategoryStats>> categoryStats(Ref ref, {String currency = 'EUR'}) {
  final subscriptionsAsync = ref.watch(activeSubscriptionsProvider);

  return subscriptionsAsync.when(
    data: (subscriptions) {
      if (subscriptions.isEmpty) {
        return Stream.value([]);
      }

      final categoryData = <SubscriptionCategory, _CategoryData>{};
      double totalMonthly = 0;

      for (final sub in subscriptions) {
        final monthly = sub.monthlyCostIn(currency);
        totalMonthly += monthly;

        final existing = categoryData[sub.category];
        if (existing != null) {
          categoryData[sub.category] = _CategoryData(
            monthlySpend: existing.monthlySpend + monthly,
            count: existing.count + 1,
          );
        } else {
          categoryData[sub.category] = _CategoryData(
            monthlySpend: monthly,
            count: 1,
          );
        }
      }

      final stats = categoryData.entries.map((entry) {
        return CategoryStats(
          category: entry.key,
          monthlySpend: entry.value.monthlySpend,
          yearlySpend: entry.value.monthlySpend * 12,
          subscriptionCount: entry.value.count,
          percentageOfTotal: totalMonthly > 0
              ? (entry.value.monthlySpend / totalMonthly) * 100
              : 0,
        );
      }).toList();

      // Sort by monthly spend descending
      stats.sort((a, b) => b.monthlySpend.compareTo(a.monthlySpend));

      return Stream.value(stats);
    },
    loading: () => const Stream.empty(),
    error: (e, _) => Stream.error(e),
  );
}

class _CategoryData {
  final double monthlySpend;
  final int count;

  const _CategoryData({
    required this.monthlySpend,
    required this.count,
  });
}

/// Provides projected spending for future months with currency conversion
@riverpod
Stream<List<MonthlySpendPoint>> projectedSpending(
  Ref ref, {
  String currency = 'EUR',
}) {
  final subscriptionsAsync = ref.watch(activeSubscriptionsProvider);

  return subscriptionsAsync.when(
    data: (subscriptions) {
      if (subscriptions.isEmpty) {
        return Stream.value([]);
      }

      final now = DateTime.now();
      final points = <MonthlySpendPoint>[];

      // Generate 6 months of projected spending
      for (int i = 0; i < 6; i++) {
        final month = DateTime(now.year, now.month + i, 1);
        double monthTotal = 0;

        for (final sub in subscriptions) {
          monthTotal += sub.monthlyCostIn(currency);
        }

        points.add(MonthlySpendPoint(
          month: month,
          amount: monthTotal,
        ));
      }

      return Stream.value(points);
    },
    loading: () => const Stream.empty(),
    error: (e, _) => Stream.error(e),
  );
}

/// Provides billing cycle distribution
@riverpod
Stream<Map<String, int>> billingCycleDistribution(Ref ref) {
  final subscriptionsAsync = ref.watch(activeSubscriptionsProvider);

  return subscriptionsAsync.when(
    data: (subscriptions) {
      final distribution = <String, int>{};

      for (final sub in subscriptions) {
        final cycle = sub.billingCycle.displayName;
        distribution[cycle] = (distribution[cycle] ?? 0) + 1;
      }

      return Stream.value(distribution);
    },
    loading: () => const Stream.empty(),
    error: (e, _) => Stream.error(e),
  );
}
