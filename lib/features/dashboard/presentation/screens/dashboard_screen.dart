import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../shared/utils/category_buckets.dart';
import '../../../../shared/widgets/logo_image.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../../subscriptions/domain/models/subscription.dart';
import '../../../subscriptions/providers/subscriptions_providers.dart';
import '../../providers/dashboard_providers.dart';

/// Home — the "what am I spending this month" glance.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currency = settings.valueOrNull?.currency ?? 'EUR';
    final statsAsync = ref.watch(dashboardStatsProvider(currency: currency));
    final upcomingAsync = ref.watch(upcomingRenewalsProvider(days: 60));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: statsAsync.when(
          data: (stats) {
            final upcoming = upcomingAsync.valueOrNull ?? const <Subscription>[];
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HomeHeader(),
                  const SizedBox(height: 28),
                  Text('This month', style: AppTypography.captionLarge),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyUtils.formatGrouped(
                      stats.totalMonthlySpend,
                      currency,
                    ),
                    style: AppTypography.heroAmount,
                  ),
                  const SizedBox(height: 14),
                  _DeltaRow(currency: currency, activeCount: stats.activeCount),
                  const SizedBox(height: 24),
                  if (stats.spendByCategory.isNotEmpty) ...[
                    _CategoryBar(
                      buckets: buildCategoryBuckets(stats.spendByCategory),
                    ),
                    const SizedBox(height: 28),
                  ],
                  if (upcoming.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Upcoming', style: AppTypography.sectionHeader),
                        GestureDetector(
                          onTap: () => context.go('/subscriptions'),
                          child: Text(
                            'See all',
                            style: AppTypography.captionLarge.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    for (var i = 0; i < upcoming.length && i < 4; i++) ...[
                      if (i > 0)
                        const Divider(color: AppColors.hairline, height: 1),
                      _UpcomingRow(
                        subscription: upcoming[i],
                        currency: currency,
                      ),
                    ],
                  ] else if (stats.activeCount == 0)
                    _EmptyHome(onAdd: () => context.push('/subscriptions/add')),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Something went wrong', style: AppTypography.body),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Text('Subly', style: AppTypography.wordmark),
          ],
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            context.push('/settings');
          },
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.toggleOff,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.person_fill,
              size: 18,
              color: AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}

/// Month-over-month delta pill + active count. Without spend history, the
/// delta is derived from subscriptions added/cancelled this calendar month.
class _DeltaRow extends ConsumerWidget {
  const _DeltaRow({required this.currency, required this.activeCount});

  final String currency;
  final int activeCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeSubscriptionsProvider).valueOrNull ?? [];
    final cancelled =
        ref.watch(cancelledSubscriptionsProvider).valueOrNull ?? [];

    final now = DateTime.now();
    bool inThisMonth(DateTime? d) =>
        d != null && d.year == now.year && d.month == now.month;

    final added = active
        .where((s) => inThisMonth(s.startDate))
        .fold<double>(0, (sum, s) => sum + s.monthlyCostIn(currency));
    final removed = cancelled
        .where((s) => inThisMonth(s.cancelledDate))
        .fold<double>(0, (sum, s) => sum + s.monthlyCostIn(currency));
    final delta = added - removed;

    final prevMonth = DateFormat('MMM').format(DateTime(now.year, now.month - 1));

    return Row(
      children: [
        if (delta.abs() >= 0.01) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${delta > 0 ? '↑' : '↓'} '
              '${CurrencyUtils.formatGrouped(delta.abs(), currency)}',
              style: AppTypography.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          delta.abs() >= 0.01
              ? 'vs. $prevMonth · $activeCount active'
              : '$activeCount active',
          style: AppTypography.captionLarge,
        ),
      ],
    );
  }
}

/// Segmented spend bar (height 10, radius 6, 3px gaps) with legend.
class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.buckets});

  final List<CategoryBucket> buckets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < buckets.length; i++) ...[
              if (i > 0) const SizedBox(width: 3),
              Expanded(
                // Flex factors need ints; per-mille keeps proportions.
                flex: (buckets[i].fraction * 1000).round().clamp(1, 1000),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: buckets[i].color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < buckets.length && i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 14),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: buckets[i].color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(buckets[i].label, style: AppTypography.caption),
            ],
          ],
        ),
      ],
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({required this.subscription, required this.currency});

  final Subscription subscription;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/subscriptions/${subscription.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            LogoImage(
              name: subscription.name,
              domain: subscription.domain,
              brandColor: subscription.brandColor,
              size: 38,
              radius: 11,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subscription.name, style: AppTypography.rowTitle),
                  const SizedBox(height: 2),
                  Text(
                    'Renews ${DateFormat('MMM d').format(subscription.nextBillingDate)}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            Text(
              CurrencyUtils.formatGrouped(
                subscription.priceIn(currency),
                currency,
              ),
              style: AppTypography.rowAmount,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: Column(
          children: [
            Text('No subscriptions yet', style: AppTypography.sectionHeader),
            const SizedBox(height: 6),
            Text(
              'Add your first subscription to start tracking.',
              style: AppTypography.captionLarge,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('Add subscription', style: AppTypography.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
