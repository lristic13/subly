import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../shared/utils/category_buckets.dart';
import '../../../../shared/widgets/ledger/ledger_widgets.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../../subscriptions/domain/models/subscription.dart';
import '../../../subscriptions/domain/models/subscription_category.dart';
import '../../../subscriptions/providers/subscriptions_providers.dart';

/// Monthly total reconstructed from each subscription's start, trial,
/// and cancellation dates.
double _totalForMonth(
  DateTime month,
  List<Subscription> subscriptions,
  String currency,
) {
  final endOfMonth = DateTime(month.year, month.month + 1, 0);
  final startOfMonth = DateTime(month.year, month.month);
  double total = 0;
  for (final sub in subscriptions) {
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

bool _inMonth(DateTime? date, DateTime month) =>
    date != null && date.year == month.year && date.month == month.month;

/// Insights — spending trends and breakdowns, browsable by month.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  /// Index into the 7-month window (0 = oldest, 6 = current month).
  int _selectedIndex = 6;

  @override
  Widget build(BuildContext context) {
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

            final now = DateTime.now();
            final months = [
              for (var i = 6; i >= 0; i--) DateTime(now.year, now.month - i),
            ];
            final everything = [...active, ...cancelled];

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
                  const SizedBox(height: 4),
                  Text(
                    'Tap a month to see what changed.',
                    style: t.caption,
                  ),
                  const SizedBox(height: 16),
                  _MonthlyChart(
                    months: months,
                    subscriptions: everything,
                    currency: currency,
                    selectedIndex: _selectedIndex,
                    onSelect: (index) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedIndex = index);
                    },
                  ),
                  const SizedBox(height: 16),
                  _MonthDetailCard(
                    month: months[_selectedIndex],
                    previousMonth: _selectedIndex > 0
                        ? months[_selectedIndex - 1]
                        : DateTime(
                            months.first.year,
                            months.first.month - 1,
                          ),
                    subscriptions: everything,
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

/// 7-bar chart of the last seven months; tapping a bar selects it.
class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({
    required this.months,
    required this.subscriptions,
    required this.currency,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<DateTime> months;
  final List<Subscription> subscriptions;
  final String currency;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    final totals = [
      for (final m in months) _totalForMonth(m, subscriptions, currency),
    ];
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
                  child: GestureDetector(
                    onTap: () => onSelect(i),
                    behavior: HitTestBehavior.opaque,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: maxTotal > 0
                            ? (totals[i] / maxTotal * 88).clamp(6.0, 88.0)
                            : 6,
                        decoration: BoxDecoration(
                          color: i == selectedIndex ? c.accent : c.barTrack,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
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
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    DateFormat('MMMMM').format(months[i]),
                    textAlign: TextAlign.center,
                    style: t.caption.copyWith(
                      fontSize: 11,
                      color: i == selectedIndex ? c.accentText : c.muted,
                      fontWeight: i == selectedIndex
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
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

/// Breakdown of the selected month: total, delta vs the previous month,
/// and the subscription changes that happened in it.
class _MonthDetailCard extends StatelessWidget {
  const _MonthDetailCard({
    required this.month,
    required this.previousMonth,
    required this.subscriptions,
    required this.currency,
  });

  final DateTime month;
  final DateTime previousMonth;
  final List<Subscription> subscriptions;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;

    final total = _totalForMonth(month, subscriptions, currency);
    final previousTotal =
        _totalForMonth(previousMonth, subscriptions, currency);
    final delta = total - previousTotal;

    final started =
        subscriptions.where((s) => _inMonth(s.startDate, month)).toList();
    final canceled =
        subscriptions.where((s) => _inMonth(s.cancelledDate, month)).toList();
    final converted = subscriptions
        .where((s) =>
            _inMonth(s.trialEndDate, month) &&
            s.startDate.isBefore(DateTime(month.year, month.month)) &&
            !_inMonth(s.cancelledDate, month))
        .toList();
    final hasChanges =
        started.isNotEmpty || canceled.isNotEmpty || converted.isNotEmpty;

    return LedgerCard(
      radius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(month),
                style: t.rowTitle,
              ),
              Text(
                CurrencyUtils.formatGrouped(total, currency),
                style: t.rowAmount.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            delta.abs() < 0.01
                ? 'Same as ${DateFormat('MMMM').format(previousMonth)}'
                : '${delta > 0 ? '+' : '−'}'
                    '${CurrencyUtils.formatGrouped(delta.abs(), currency)} '
                    'vs ${DateFormat('MMMM').format(previousMonth)}',
            style: t.caption.copyWith(
              color: delta > 0.01 ? c.danger : c.muted,
            ),
          ),
          if (hasChanges) ...[
            const SizedBox(height: 12),
            Divider(color: c.hairline2, height: 1),
            for (final sub in started)
              _ChangeRow(
                symbol: '+',
                symbolColor: c.accentText,
                name: sub.name,
                // startDate is in this month; a trial ending later means the
                // subscription began as a free trial here.
                detail: sub.trialEndDate != null &&
                        !_inMonth(sub.trialEndDate, month)
                    ? 'trial started'
                    : 'added',
                amount: sub.monthlyCostIn(currency),
                currency: currency,
              ),
            for (final sub in converted)
              _ChangeRow(
                symbol: '↑',
                symbolColor: c.accentText,
                name: sub.name,
                detail: 'trial converted to paid',
                amount: sub.monthlyCostIn(currency),
                currency: currency,
              ),
            for (final sub in canceled)
              _ChangeRow(
                symbol: '−',
                symbolColor: c.muted,
                name: sub.name,
                detail: 'canceled',
                amount: -sub.monthlyCostIn(currency),
                currency: currency,
              ),
          ] else ...[
            const SizedBox(height: 10),
            Text('No changes this month', style: t.caption),
          ],
        ],
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({
    required this.symbol,
    required this.symbolColor,
    required this.name,
    required this.detail,
    required this.amount,
    required this.currency,
  });

  final String symbol;
  final Color symbolColor;
  final String name;
  final String detail;
  final double amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final t = context.ledgerText;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text(
              symbol,
              style: t.rowTitle.copyWith(color: symbolColor),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: t.caption.copyWith(fontSize: 13),
                children: [
                  TextSpan(
                    text: name,
                    style: t.caption.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.ledgerColors.ink,
                    ),
                  ),
                  TextSpan(text: ' · $detail'),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${amount >= 0 ? '' : '−'}'
            '${CurrencyUtils.formatGrouped(amount.abs(), currency)}',
            style: t.rowAmount.copyWith(fontSize: 13),
          ),
        ],
      ),
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
