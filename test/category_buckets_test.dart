import 'package:flutter_test/flutter_test.dart';
import 'package:subly/app/theme/app_colors.dart';
import 'package:subly/features/subscriptions/domain/models/subscription_category.dart';
import 'package:subly/shared/utils/category_buckets.dart';

void main() {
  final shades = AppColors.light.chartShades;

  test('empty spend map produces no buckets', () {
    expect(buildCategoryBuckets({}, shades), isEmpty);
  });

  test('three or fewer categories map directly, largest first', () {
    final buckets = buildCategoryBuckets({
      SubscriptionCategory.streaming: 30,
      SubscriptionCategory.software: 70,
    }, shades);

    expect(buckets, hasLength(2));
    expect(buckets[0].label, 'Software');
    expect(buckets[0].fraction, closeTo(0.7, 0.001));
    expect(buckets[0].color, shades[0]);
    expect(buckets[1].label, 'Streaming');
    expect(buckets[1].color, shades[1]);
  });

  test('more than three categories collapse into an Other bucket', () {
    final buckets = buildCategoryBuckets({
      SubscriptionCategory.streaming: 40,
      SubscriptionCategory.software: 30,
      SubscriptionCategory.cloud: 20,
      SubscriptionCategory.music: 6,
      SubscriptionCategory.fitness: 4,
    }, shades);

    expect(buckets, hasLength(4));
    expect(buckets[3].label, 'Other');
    expect(buckets[3].amount, 10); // music + fitness
    expect(buckets[3].color, shades[3]);

    final totalFraction =
        buckets.fold<double>(0, (sum, b) => sum + b.fraction);
    expect(totalFraction, closeTo(1.0, 0.001));
  });
}
