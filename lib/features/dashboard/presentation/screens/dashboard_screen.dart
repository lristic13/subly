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
    final active =
        ref.watch(activeSubscriptionsProvider).valueOrNull ??
            const <Subscription>[];
    final c = context.ledgerColors;
    final t = context.ledgerText;

    // Trials converting to paid within the next week, soonest first.
    final endingTrials = active
        .where((s) => s.isInTrial && _daysUntil(s.trialEndDate!) <= 7)
        .toList()
      ..sort((a, b) => a.trialEndDate!.compareTo(b.trialEndDate!));

    return Scaffold(
      backgroundColor: c.bg,
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
                  Text('This month', style: t.captionLarge),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyUtils.formatGrouped(
                      stats.totalMonthlySpend,
                      currency,
                    ),
                    style: t.heroAmount,
                  ),
                  const SizedBox(height: 14),
                  _DeltaRow(currency: currency, activeCount: stats.activeCount),
                  if (settings.valueOrNull?.monthlyBudget != null) ...[
                    const SizedBox(height: 20),
                    _BudgetBar(
                      spent: stats.totalMonthlySpend,
                      budget: settings.valueOrNull!.monthlyBudget!,
                      currency: currency,
                    ),
                  ],
                  if (endingTrials.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _TrialAlertCard(
                      subscription: endingTrials.first,
                      currency: currency,
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (stats.spendByCategory.isNotEmpty) ...[
                    _CategoryBar(
                      buckets: buildCategoryBuckets(
                        stats.spendByCategory,
                        c.chartShades,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (stats.activeCount > 0) ...[
                    _StatRow(stats: stats),
                    const SizedBox(height: 28),
                  ],
                  if (upcoming.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Upcoming', style: t.sectionHeader),
                        GestureDetector(
                          onTap: () => context.go('/subscriptions'),
                          child: Text(
                            'See all',
                            style: t.captionLarge.copyWith(
                              color: c.accentText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    for (var i = 0; i < upcoming.length && i < 4; i++) ...[
                      if (i > 0) Divider(color: c.hairline, height: 1),
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
            child: Text('Something went wrong', style: t.body),
          ),
        ),
      ),
    );
  }
}

/// Whole days from today (date-only) until [date].
int _daysUntil(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return DateTime(date.year, date.month, date.day).difference(today).inDays;
}

/// Alert for a free trial converting to paid within the next week.
class _TrialAlertCard extends StatelessWidget {
  const _TrialAlertCard({required this.subscription, required this.currency});

  final Subscription subscription;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    final days = _daysUntil(subscription.trialEndDate!);
    final when = switch (days) {
      <= 0 => 'today',
      1 => 'tomorrow',
      _ => 'in $days days',
    };

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/subscriptions/${subscription.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.accentSoft,
          borderRadius: BorderRadius.circular(16),
        ),
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
                  Text(
                    '${subscription.name} trial ends $when',
                    style: t.rowTitle.copyWith(color: c.accentText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${CurrencyUtils.formatGrouped(subscription.monthlyCostIn(currency), currency)}'
                    '/mo after · cancel anytime before',
                    style: t.caption,
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: c.accentText,
            ),
          ],
        ),
      ),
    );
  }
}

/// Quiet three-stat strip: yearly projection, daily cost, average per sub.
class _StatRow extends StatelessWidget {
  const _StatRow({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final currency = stats.displayCurrency;
    final perDay = stats.totalMonthlySpend * 12 / 365;
    final average = stats.activeCount > 0
        ? stats.totalMonthlySpend / stats.activeCount
        : 0.0;

    return Row(
      children: [
        Expanded(
          child: _Stat(
            label: 'Per year',
            value: CurrencyUtils.formatGrouped(
              stats.totalYearlySpend,
              currency,
              decimals: 0,
            ),
            alignment: CrossAxisAlignment.start,
          ),
        ),
        Expanded(
          child: _Stat(
            label: 'Per day',
            value: CurrencyUtils.formatGrouped(perDay, currency),
            alignment: CrossAxisAlignment.center,
          ),
        ),
        Expanded(
          child: _Stat(
            label: 'Avg / sub',
            value: CurrencyUtils.formatGrouped(average, currency),
            alignment: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.alignment,
  });

  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final t = context.ledgerText;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(label, style: t.caption),
        const SizedBox(height: 3),
        Text(value, style: t.rowAmount),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: c.accent,
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
            Text('Subly', style: context.ledgerText.wordmark),
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
            decoration: BoxDecoration(
              color: c.toggleOff,
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.person_fill,
              size: 18,
              color: c.muted,
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
    final c = context.ledgerColors;
    final t = context.ledgerText;

    final now = DateTime.now();
    bool inThisMonth(DateTime? d) =>
        d != null && d.year == now.year && d.month == now.month;

    final added = active
        .where((s) => inThisMonth(s.startDate))
        .fold<double>(0, (sum, s) => sum + s.billableMonthlyCostIn(currency));
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
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${delta > 0 ? '↑' : '↓'} '
              '${CurrencyUtils.formatGrouped(delta.abs(), currency)}',
              style: t.caption.copyWith(
                color: c.accentText,
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
          style: t.captionLarge,
        ),
      ],
    );
  }
}

/// Progress against the monthly budget from Settings. Fills in accent and
/// switches to the danger color once spending exceeds the budget.
class _BudgetBar extends StatelessWidget {
  const _BudgetBar({
    required this.spent,
    required this.budget,
    required this.currency,
  });

  final double spent;
  final double budget;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    final over = spent > budget;
    final fraction = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 1.0;
    final fillPerMille = (fraction * 1000).round().clamp(1, 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Budget', style: t.caption),
            Text.rich(
              TextSpan(
                style: t.caption.copyWith(
                  fontFeatures: AppTypography.tabularFigures,
                ),
                children: [
                  TextSpan(
                    text: CurrencyUtils.formatGrouped(spent, currency),
                    style: t.caption.copyWith(
                      color: over ? c.danger : c.ink,
                      fontWeight: FontWeight.w600,
                      fontFeatures: AppTypography.tabularFigures,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' of ${CurrencyUtils.formatGrouped(budget, currency)}',
                  ),
                ],
              ),
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
                  child: Container(color: over ? c.danger : c.accent),
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
        if (over) ...[
          const SizedBox(height: 6),
          Text(
            '${CurrencyUtils.formatGrouped(spent - budget, currency)} over budget',
            style: t.caption.copyWith(
              color: c.danger,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
    final t = context.ledgerText;
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
              Text(buckets[i].label, style: t.caption),
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
    final c = context.ledgerColors;
    final t = context.ledgerText;
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
                  Text(subscription.name, style: t.rowTitle),
                  const SizedBox(height: 2),
                  Text(
                    subscription.isInTrial
                        ? 'Trial ends ${DateFormat('MMM d').format(subscription.nextBillingDate)}'
                        : 'Renews ${DateFormat('MMM d').format(subscription.nextBillingDate)}',
                    style: t.caption.copyWith(
                      color: subscription.isInTrial ? c.accentText : c.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              CurrencyUtils.formatGrouped(
                subscription.priceIn(currency),
                currency,
              ),
              style: t.rowAmount,
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
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: Column(
          children: [
            Text('No subscriptions yet', style: t.sectionHeader),
            const SizedBox(height: 6),
            Text(
              'Add your first subscription to start tracking.',
              style: t.captionLarge,
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
                  color: c.accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('Add subscription', style: t.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
