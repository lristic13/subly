import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/currency_utils.dart';
import '../../subscriptions/domain/models/subscription.dart';
import '../../subscriptions/domain/models/subscription_category.dart';
import '../../subscriptions/providers/subscriptions_providers.dart';

part 'dashboard_providers.g.dart';

/// Dashboard stats containing aggregated subscription data
class DashboardStats {
  final double totalMonthlySpend;
  final double totalYearlySpend;
  final int activeCount;
  final Map<SubscriptionCategory, double> spendByCategory;
  final String displayCurrency;

  const DashboardStats({
    required this.totalMonthlySpend,
    required this.totalYearlySpend,
    required this.activeCount,
    required this.spendByCategory,
    required this.displayCurrency,
  });

  /// Cost per day
  double get costPerDay => totalMonthlySpend / 30;

  /// Average cost per subscription
  double get averageCostPerSubscription =>
      activeCount > 0 ? totalMonthlySpend / activeCount : 0;
}

/// Provides aggregated dashboard statistics with currency conversion
@riverpod
Stream<DashboardStats> dashboardStats(Ref ref, {String currency = 'EUR'}) {
  final activeSubscriptions = ref.watch(activeSubscriptionsProvider);

  return activeSubscriptions.when(
    data: (subscriptions) =>
        Stream.value(_calculateStats(subscriptions, currency)),
    loading: () => const Stream.empty(),
    error: (e, _) => Stream.error(e),
  );
}

DashboardStats _calculateStats(
  List<Subscription> subscriptions,
  String displayCurrency,
) {
  double totalMonthly = 0;
  final Map<SubscriptionCategory, double> byCategory = {};

  for (final sub in subscriptions) {
    // Convert monthly cost to display currency
    final monthly = sub.monthlyCostIn(displayCurrency);
    totalMonthly += monthly;
    byCategory[sub.category] = (byCategory[sub.category] ?? 0) + monthly;
  }

  return DashboardStats(
    totalMonthlySpend: totalMonthly,
    totalYearlySpend: totalMonthly * 12,
    activeCount: subscriptions.length,
    spendByCategory: byCategory,
    displayCurrency: displayCurrency,
  );
}

/// Provides upcoming renewals (next 7 days)
@riverpod
Stream<List<Subscription>> dashboardUpcomingRenewals(Ref ref) {
  final upcomingAsync = ref.watch(upcomingRenewalsProvider(days: 7));
  return upcomingAsync.when(
    data: (data) => Stream.value(data),
    loading: () => const Stream.empty(),
    error: (e, _) => Stream.error(e),
  );
}

/// Insight types for the Subly character
enum InsightType {
  multipleSameCategory,
  spendingIncrease,
  upcomingRenewals,
  noSubscriptions,
  savingsTip,
  milestone,
}

/// A contextual insight for the user
class SublyInsight {
  final InsightType type;
  final String title;
  final String message;
  final SubscriptionCategory? relatedCategory;

  const SublyInsight({
    required this.type,
    required this.title,
    required this.message,
    this.relatedCategory,
  });
}

/// Provides contextual insights based on subscription data
@riverpod
Stream<SublyInsight?> dashboardInsight(Ref ref, {String currency = 'EUR'}) {
  final activeSubscriptions = ref.watch(activeSubscriptionsProvider);
  final upcomingRenewals = ref.watch(upcomingRenewalsProvider(days: 3));
  final symbol = CurrencyUtils.getSymbol(currency);

  return activeSubscriptions.when(
    data: (subscriptions) {
      if (subscriptions.isEmpty) {
        return Stream.value(const SublyInsight(
          type: InsightType.noSubscriptions,
          title: 'Welcome to Subly!',
          message:
              'Add your first subscription to start tracking your spending.',
        ));
      }

      // Check for multiple subscriptions in same category
      final categoryCount = <SubscriptionCategory, int>{};
      final categorySpend = <SubscriptionCategory, double>{};
      for (final sub in subscriptions) {
        categoryCount[sub.category] = (categoryCount[sub.category] ?? 0) + 1;
        categorySpend[sub.category] = (categorySpend[sub.category] ?? 0) +
            sub.monthlyCostIn(currency);
      }

      // Find category with most subscriptions (at least 3)
      for (final entry in categoryCount.entries) {
        if (entry.value >= 3) {
          final spend = categorySpend[entry.key] ?? 0;
          return Stream.value(SublyInsight(
            type: InsightType.multipleSameCategory,
            title: 'Multiple ${entry.key.displayName} subscriptions',
            message:
                'You have ${entry.value} ${entry.key.displayName.toLowerCase()} subscriptions totaling $symbol${spend.toStringAsFixed(2)}/mo. Need all of them?',
            relatedCategory: entry.key,
          ));
        }
      }

      // Check for upcoming renewals
      return upcomingRenewals.when(
        data: (upcoming) {
          if (upcoming.isNotEmpty) {
            final total = upcoming.fold<double>(
              0,
              (sum, s) => sum + s.priceIn(currency),
            );
            return Stream.value(SublyInsight(
              type: InsightType.upcomingRenewals,
              title:
                  '${upcoming.length} renewal${upcoming.length > 1 ? 's' : ''} coming up',
              message:
                  '$symbol${total.toStringAsFixed(2)} due in the next 3 days. Make sure you\'re ready!',
            ));
          }

          // Milestone messages based on total count
          if (subscriptions.length == 5) {
            return Stream.value(const SublyInsight(
              type: InsightType.milestone,
              title: 'Tracking 5 subscriptions!',
              message: 'Great job keeping track of your recurring expenses.',
            ));
          }

          if (subscriptions.length >= 10) {
            final totalMonthly = subscriptions.fold<double>(
              0,
              (sum, s) => sum + s.monthlyCostIn(currency),
            );
            return Stream.value(SublyInsight(
              type: InsightType.savingsTip,
              title: 'Review your subscriptions',
              message:
                  'With ${subscriptions.length} subscriptions at $symbol${totalMonthly.toStringAsFixed(2)}/mo, consider reviewing for unused services.',
            ));
          }

          return Stream.value(null);
        },
        loading: () => Stream.value(null),
        error: (_, _) => Stream.value(null),
      );
    },
    loading: () => const Stream.empty(),
    error: (e, _) => Stream.error(e),
  );
}
