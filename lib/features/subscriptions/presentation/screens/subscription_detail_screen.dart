import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../shared/widgets/ledger/ledger_widgets.dart';
import '../../../../shared/widgets/logo_image.dart';
import '../../domain/models/subscription.dart';
import '../../providers/subscriptions_providers.dart';

/// One subscription's full record + edit/cancel.
class SubscriptionDetailScreen extends ConsumerWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync =
        ref.watch(subscriptionByIdProvider(subscriptionId));
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: subscriptionAsync.when(
          data: (subscription) {
            if (subscription == null) {
              return Center(
                child: Text('Subscription not found', style: t.body),
              );
            }
            return _DetailBody(subscription: subscription);
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

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.subscription});

  final Subscription subscription;

  /// Amount paid so far this year, in the subscription's own currency:
  /// completed charge months from max(Jan, first charge) through the current
  /// month, capped at the cancellation month for cancelled subscriptions.
  /// Charges start at trial end when there is a free trial.
  double get _paidThisYear {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year);
    final chargeStart = subscription.trialEndDate ?? subscription.startDate;
    final from = chargeStart.isAfter(startOfYear) ? chargeStart : startOfYear;
    final until = !subscription.isActive && subscription.cancelledDate != null
        ? subscription.cancelledDate!
        : now;
    if (until.isBefore(from)) return 0;
    final months =
        (until.year - from.year) * 12 + until.month - from.month + 1;
    return subscription.monthlyCost * months;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = subscription.currency;
    final dateFormat = DateFormat('MMM d, yyyy');
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nav row: back chevron + Edit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    size: 24,
                    color: c.inkStrong,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context
                    .push('/subscriptions/${subscription.id}/edit'),
                child: Text(
                  'Edit',
                  style: t.rowTitle.copyWith(color: c.accentText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Centered header
          Center(
            child: Column(
              children: [
                LogoImage(
                  name: subscription.name,
                  domain: subscription.domain,
                  brandColor: subscription.brandColor,
                  size: 66,
                  radius: 19,
                ),
                const SizedBox(height: 14),
                Text(subscription.name, style: t.detailName),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: c.accentSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    subscription.category.displayName,
                    style: t.caption.copyWith(
                      color: c.accentText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  CurrencyUtils.formatGrouped(subscription.price, currency),
                  style: t.detailPrice,
                ),
                const SizedBox(height: 6),
                Text(
                  '/ ${subscription.billingCycle.displayName.toLowerCase()}',
                  style: t.body.copyWith(color: c.muted),
                ),
                if (subscription.isInTrial) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: c.accentSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Free until ${DateFormat('MMM d').format(subscription.trialEndDate!)}',
                      style: t.caption.copyWith(
                        color: c.accentText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Info card
          LedgerCard(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                if (subscription.isInTrial)
                  _InfoRow(
                    label: 'Trial ends',
                    value: dateFormat.format(subscription.trialEndDate!),
                  )
                else
                  _InfoRow(
                    label: 'Next charge',
                    value: dateFormat.format(subscription.nextBillingDate),
                  ),
                Divider(color: c.hairline2, height: 1),
                _InfoRow(
                  label: 'Billing cycle',
                  value: subscription.billingCycle.displayName,
                ),
                Divider(color: c.hairline2, height: 1),
                _InfoRow(
                  label: 'Subscribed since',
                  value: DateFormat('MMM yyyy').format(subscription.startDate),
                ),
                Divider(color: c.hairline2, height: 1),
                _InfoRow(
                  label: 'Yearly cost',
                  value: CurrencyUtils.formatGrouped(
                    subscription.yearlyCost,
                    currency,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Paid this year + mini chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Paid this year', style: t.rowTitle),
              Text(
                CurrencyUtils.formatGrouped(_paidThisYear, currency),
                style: t.rowAmount.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _YearChart(subscription: subscription),
          const SizedBox(height: 28),
          if (subscription.isActive) ...[
            LedgerPrimaryButton(
              label: 'Edit subscription',
              onPressed: () =>
                  context.push('/subscriptions/${subscription.id}/edit'),
            ),
            const SizedBox(height: 8),
            _DangerTextButton(
              label: 'Mark as canceled',
              onPressed: () => _confirmCancel(context, ref),
            ),
          ] else ...[
            LedgerPrimaryButton(
              label: 'Reactivate subscription',
              onPressed: () => ref
                  .read(subscriptionRepositoryProvider)
                  .reactivateSubscription(subscription.id),
            ),
            const SizedBox(height: 8),
            _DangerTextButton(
              label: 'Delete subscription',
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final danger = context.ledgerColors.danger;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as canceled?'),
        content: Text(
          '${subscription.name} will be excluded from your monthly totals. '
          'You can reactivate it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: danger),
            child: const Text('Mark as canceled'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      HapticFeedback.mediumImpact();
      await ref
          .read(subscriptionRepositoryProvider)
          .cancelSubscription(subscription.id, DateTime.now());
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final danger = context.ledgerColors.danger;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete subscription?'),
        content: const Text(
          'This permanently removes the subscription and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(subscriptionRepositoryProvider)
          .deleteSubscription(subscription.id);
      if (context.mounted) context.pop();
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: t.body.copyWith(
              color: c.muted,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: t.rowTitle.copyWith(
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

/// 12-bar mini chart: months already charged this year in a light indigo,
/// the current month in accent, months without a charge on the track color.
class _YearChart extends StatelessWidget {
  const _YearChart({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final now = DateTime.now();
    final chargeStart = subscription.trialEndDate ?? subscription.startDate;
    final startMonth = chargeStart.year < now.year
        ? 1
        : chargeStart.year > now.year
            ? 13 // charges only begin next year — nothing paid yet
            : chargeStart.month;
    final endMonth = !subscription.isActive &&
            subscription.cancelledDate != null &&
            subscription.cancelledDate!.year == now.year
        ? subscription.cancelledDate!.month
        : now.month;

    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var month = 1; month <= 12; month++) ...[
            if (month > 1) const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: _heightFor(month, startMonth, endMonth, now.month),
                decoration: BoxDecoration(
                  color: _colorFor(c, month, startMonth, endMonth, now.month),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _heightFor(int month, int start, int end, int current) {
    if (month == current && month >= start && month <= end) return 44;
    if (month >= start && month <= end) return 32;
    return 12;
  }

  Color _colorFor(LedgerColors c, int month, int start, int end, int current) {
    if (month == current && month >= start && month <= end) return c.accent;
    if (month >= start && month <= end) return c.barTrackAlt;
    return c.barTrack2;
  }
}

class _DangerTextButton extends StatelessWidget {
  const _DangerTextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Center(
          child: Text(label, style: t.rowTitle.copyWith(color: c.danger)),
        ),
      ),
    );
  }
}
