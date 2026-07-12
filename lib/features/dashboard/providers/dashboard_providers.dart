import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
}

/// Provides aggregated dashboard statistics with currency conversion
@riverpod
Future<DashboardStats> dashboardStats(
  Ref ref, {
  String currency = 'EUR',
}) async {
  final subscriptions = await ref.watch(activeSubscriptionsProvider.future);
  return _calculateStats(subscriptions, currency);
}

DashboardStats _calculateStats(
  List<Subscription> subscriptions,
  String displayCurrency,
) {
  double totalMonthly = 0;
  final Map<SubscriptionCategory, double> byCategory = {};

  for (final sub in subscriptions) {
    // Convert monthly cost to display currency; free trials don't cost
    // anything yet, so they contribute nothing to the totals.
    final monthly = sub.billableMonthlyCostIn(displayCurrency);
    totalMonthly += monthly;
    if (monthly > 0) {
      byCategory[sub.category] = (byCategory[sub.category] ?? 0) + monthly;
    }
  }

  return DashboardStats(
    totalMonthlySpend: totalMonthly,
    totalYearlySpend: totalMonthly * 12,
    activeCount: subscriptions.length,
    spendByCategory: byCategory,
    displayCurrency: displayCurrency,
  );
}
