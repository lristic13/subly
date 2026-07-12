import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers/shared_providers.dart';
import '../domain/models/subscription.dart';
import '../domain/models/subscription_category.dart';

part 'subscriptions_providers.g.dart';

/// Watch all active subscriptions
@riverpod
Stream<List<Subscription>> activeSubscriptions(Ref ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.watchAllActive();
}

/// Watch all cancelled subscriptions
@riverpod
Stream<List<Subscription>> cancelledSubscriptions(Ref ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.watchAllCancelled();
}

/// Watch a single subscription by ID
@riverpod
Stream<Subscription?> subscriptionById(Ref ref, String id) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.watchById(id);
}

/// Watch subscriptions with upcoming renewals
@riverpod
Stream<List<Subscription>> upcomingRenewals(Ref ref, {int days = 7}) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.watchUpcomingRenewals(days: days);
}

/// Watch total monthly spend
@riverpod
Stream<double> totalMonthlySpend(Ref ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.watchTotalMonthlySpend();
}

/// Watch spend by category
@riverpod
Stream<Map<SubscriptionCategory, double>> spendByCategory(Ref ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.watchSpendByCategory();
}

/// Watch count of active subscriptions
@riverpod
Stream<int> activeSubscriptionCount(Ref ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.watchActiveCount();
}
