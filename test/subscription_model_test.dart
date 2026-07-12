import 'package:flutter_test/flutter_test.dart';
import 'package:subly/features/subscriptions/domain/models/billing_cycle.dart';
import 'package:subly/features/subscriptions/domain/models/subscription.dart';
import 'package:subly/features/subscriptions/domain/models/subscription_category.dart';

Subscription _sub({
  double price = 12,
  BillingCycle cycle = BillingCycle.monthly,
  DateTime? trialEndDate,
}) {
  return Subscription(
    id: 'test-id',
    name: 'Test',
    price: price,
    currency: 'EUR',
    billingCycle: cycle,
    category: SubscriptionCategory.streaming,
    startDate: DateTime(2026, 1, 1),
    nextBillingDate: DateTime(2026, 8, 1),
    trialEndDate: trialEndDate,
  );
}

void main() {
  test('monthly and yearly cost derive from the billing cycle', () {
    expect(_sub(price: 12).monthlyCost, 12);
    expect(_sub(price: 12).yearlyCost, 144);
    expect(_sub(price: 120, cycle: BillingCycle.yearly).monthlyCost, 10);
  });

  group('free trials', () {
    test('isInTrial only while the end date is in the future', () {
      final future = DateTime.now().add(const Duration(days: 5));
      final past = DateTime.now().subtract(const Duration(days: 5));

      expect(_sub(trialEndDate: future).isInTrial, isTrue);
      expect(_sub(trialEndDate: past).isInTrial, isFalse);
      expect(_sub().isInTrial, isFalse);
    });

    test('billable monthly cost is zero during the trial', () {
      final future = DateTime.now().add(const Duration(days: 5));
      final past = DateTime.now().subtract(const Duration(days: 5));

      expect(_sub(trialEndDate: future).billableMonthlyCostIn('EUR'), 0);
      expect(_sub(trialEndDate: past).billableMonthlyCostIn('EUR'), 12);
      expect(_sub().billableMonthlyCostIn('EUR'), 12);
    });
  });
}
