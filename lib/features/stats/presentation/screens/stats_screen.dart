import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../shared/utils/category_buckets.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../../subscriptions/domain/models/subscription.dart';
import '../../../subscriptions/domain/models/subscription_category.dart';
import '../../../subscriptions/providers/subscriptions_providers.dart';

/// Insights — spending trends and breakdowns.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currency = settings.valueOrNull?.currency ?? 'EUR';
    final activeAsync = ref.watch(activeSubscriptionsProvider);
    final cancelled =
        ref.watch(cancelledSubscriptionsProvider).valueOrNull ??
            const <Subscription>[];
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: activeAsync.when(
          data: (active) {
            final monthlyTotal = active.fold<double>(
              0,
              (sum, s) => sum + s.billableMonthlyCostIn(currency),
            );
            final byCategory = <SubscriptionCategory, double>{};
            for (final sub in active) {
              final monthly = sub.billableMonthlyCostIn(currency);
              if (monthly > 0) {
                byCategory[sub.category] =
                    (byCategory[sub.category] ?? 0) + monthly;
              }
            }
            final buckets = buildCategoryBuckets(byCategory, c.chartShades);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Insights', style: t.screenTitleLarge),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: c.accentSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${DateTime.now().year}',
                          style: t.caption.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: c.accentText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _ProjectionHero(
                    monthlyTotal: monthlyTotal,
                    activeCount: active.length,
                    currency: currency,
                  ),
                  const SizedBox(height: 28),
                  Text('Monthly spend', style: t.sectionHeader),
                  const SizedBox(height: 16),
                  _MonthlyChart(
                    active: active,
                    cancelled: cancelled,
                    currency: currency,
                  ),
                  const SizedBox(height: 28),
                  Text('By category', style: t.sectionHeader),
                  const SizedBox(height: 16),
                  for (var i = 0; i < buckets.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _CategoryProgressRow(
                      bucket: buckets[i],
                      currency: currency,
                    ),
                  ],
                  if (buckets.isEmpty)
                    Text(
                      'Add subscriptions to see your breakdown.',
                      style: t.captionLarge,
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Something went wrong', style: t.body),
          ),
        ),
      ),
    );
  }
}

class _ProjectionHero extends StatelessWidget {
  const _ProjectionHero({
    required this.monthlyTotal,
    required this.activeCount,
    required this.currency,
  });

  final double monthlyTotal;
  final int activeCount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.accent,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projected this year',
            style: t.captionLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyUtils.formatGrouped(monthlyTotal * 12, currency),
            style: t.detailPrice.copyWith(fontSize: 38, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Avg ${CurrencyUtils.formatGrouped(monthlyTotal, currency)} / month '
            'across $activeCount subscription${activeCount == 1 ? '' : 's'}',
            style: t.captionLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

/// 7-bar chart of the last seven months. Totals are reconstructed from each
/// subscription's start (and cancellation) dates.
class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({
    required this.active,
    required this.cancelled,
    required this.currency,
  });

  final List<Subscription> active;
  final List<Subscription> cancelled;
  final String currency;

  double _totalForMonth(DateTime month) {
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    final startOfMonth = DateTime(month.year, month.month);
    double total = 0;
    for (final sub in [...active, ...cancelled]) {
      final startedBy = !sub.startDate.isAfter(endOfMonth);
      final stillRunning = sub.isActive ||
          sub.cancelledDate == null ||
          !sub.cancelledDate!.isBefore(startOfMonth);
      // A month inside the free trial costs nothing.
      final pastTrial =
          sub.trialEndDate == null || !sub.trialEndDate!.isAfter(endOfMonth);
      if (startedBy && stillRunning && pastTrial) {
        total += sub.monthlyCostIn(currency);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    final now = DateTime.now();
    final months = [
      for (var i = 6; i >= 0; i--) DateTime(now.year, now.month - i),
    ];
    final totals = [for (final m in months) _totalForMonth(m)];
    final maxTotal = totals.fold<double>(0, (a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 88,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < months.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: maxTotal > 0
                        ? (totals[i] / maxTotal * 88).clamp(6.0, 88.0)
                        : 6,
                    decoration: BoxDecoration(
                      color:
                          i == months.length - 1 ? c.accent : c.barTrack,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < months.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Text(
                  DateFormat('MMMMM').format(months[i]),
                  textAlign: TextAlign.center,
                  style: t.caption.copyWith(
                    fontSize: 11,
                    color: i == months.length - 1 ? c.accentText : c.muted,
                    fontWeight: i == months.length - 1
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _CategoryProgressRow extends StatelessWidget {
  const _CategoryProgressRow({required this.bucket, required this.currency});

  final CategoryBucket bucket;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    final fillPerMille = (bucket.fraction * 1000).round().clamp(1, 1000);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bucket.label, style: t.body.copyWith(fontSize: 13)),
            Text(
              CurrencyUtils.formatGrouped(bucket.amount, currency),
              style: t.rowAmount.copyWith(fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                Expanded(
                  flex: fillPerMille,
                  child: Container(color: bucket.color),
                ),
                if (fillPerMille < 1000)
                  Expanded(
                    flex: 1000 - fillPerMille,
                    child: Container(color: c.barTrack2),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
