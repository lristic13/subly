import 'package:flutter_test/flutter_test.dart';
import 'package:subly/features/subscriptions/domain/models/billing_cycle.dart';

void main() {
  group('nextBillingDate', () {
    test('monthly advances one month, keeping the day', () {
      expect(
        BillingCycle.monthly.nextBillingDate(DateTime(2026, 3, 15)),
        DateTime(2026, 4, 15),
      );
    });

    test('monthly clamps month-end dates to the target month\'s last day', () {
      expect(
        BillingCycle.monthly.nextBillingDate(DateTime(2026, 1, 31)),
        DateTime(2026, 2, 28),
      );
      expect(
        BillingCycle.monthly.nextBillingDate(DateTime(2026, 3, 31)),
        DateTime(2026, 4, 30),
      );
    });

    test('monthly respects leap years', () {
      expect(
        BillingCycle.monthly.nextBillingDate(DateTime(2024, 1, 31)),
        DateTime(2024, 2, 29),
      );
    });

    test('monthly rolls over the year boundary', () {
      expect(
        BillingCycle.monthly.nextBillingDate(DateTime(2025, 12, 15)),
        DateTime(2026, 1, 15),
      );
    });

    test('weekly adds seven days', () {
      expect(
        BillingCycle.weekly.nextBillingDate(DateTime(2026, 7, 12)),
        DateTime(2026, 7, 19),
      );
    });

    test('yearly adds one year', () {
      expect(
        BillingCycle.yearly.nextBillingDate(DateTime(2026, 7, 12)),
        DateTime(2027, 7, 12),
      );
    });
  });

  group('cost normalization', () {
    test('toMonthly', () {
      expect(BillingCycle.monthly.toMonthly(10), 10);
      expect(BillingCycle.yearly.toMonthly(120), 10);
      expect(BillingCycle.weekly.toMonthly(10), closeTo(43.3, 0.001));
    });

    test('toYearly', () {
      expect(BillingCycle.monthly.toYearly(10), 120);
      expect(BillingCycle.yearly.toYearly(120), 120);
      expect(BillingCycle.weekly.toYearly(10), 520);
    });
  });
}
