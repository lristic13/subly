import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../shared/widgets/ledger/ledger_widgets.dart';
import '../../../../shared/widgets/logo_image.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../domain/models/subscription.dart';
import '../../providers/subscriptions_providers.dart';

enum _SortMode { amount, name, nextCharge }

extension on _SortMode {
  String get label => switch (this) {
        _SortMode.amount => 'Amount',
        _SortMode.name => 'Name',
        _SortMode.nextCharge => 'Next charge',
      };
}

/// Browse and manage all subscriptions.
class SubscriptionsListScreen extends ConsumerStatefulWidget {
  const SubscriptionsListScreen({super.key});

  @override
  ConsumerState<SubscriptionsListScreen> createState() =>
      _SubscriptionsListScreenState();
}

class _SubscriptionsListScreenState
    extends ConsumerState<SubscriptionsListScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  _SortMode _sortMode = _SortMode.amount;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Subscription> _visibleSubscriptions(
    List<Subscription> all,
    String currency,
  ) {
    var subs = all;
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      subs = subs.where((s) => s.name.toLowerCase().contains(q)).toList();
    } else {
      subs = [...subs];
    }
    switch (_sortMode) {
      case _SortMode.amount:
        subs.sort((a, b) =>
            b.monthlyCostIn(currency).compareTo(a.monthlyCostIn(currency)));
      case _SortMode.name:
        subs.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case _SortMode.nextCharge:
        subs.sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
    }
    return subs;
  }

  Future<void> _pickSort() async {
    final picked = await showLedgerPicker<_SortMode>(
      context: context,
      title: 'Sort by',
      selected: _sortMode,
      options: [
        for (final mode in _SortMode.values)
          LedgerPickerOption(value: mode, label: mode.label),
      ],
    );
    if (picked != null) setState(() => _sortMode = picked);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final currency = settings.valueOrNull?.currency ?? 'EUR';
    final subscriptionsAsync = ref.watch(activeSubscriptionsProvider);
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: subscriptionsAsync.when(
          data: (subscriptions) {
            final monthlyTotal = subscriptions.fold<double>(
              0,
              (sum, s) => sum + s.billableMonthlyCostIn(currency),
            );
            final visible = _visibleSubscriptions(subscriptions, currency);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  Text('Subscriptions', style: t.screenTitleLarge),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      style: t.captionLarge,
                      children: [
                        TextSpan(text: '${subscriptions.length} active · '),
                        TextSpan(
                          text: CurrencyUtils.formatGrouped(
                            monthlyTotal,
                            currency,
                          ),
                          style: t.captionLarge.copyWith(
                            color: c.ink,
                            fontWeight: FontWeight.w600,
                            fontFeatures: AppTypography.tabularFigures,
                          ),
                        ),
                        const TextSpan(text: ' / month'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _SearchField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                      )),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _pickSort,
                        child: Container(
                          height: 42,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: c.fieldBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _sortMode.label,
                                style: t.caption.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: c.accentText,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                CupertinoIcons.chevron_down,
                                size: 12,
                                color: c.accentText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: subscriptions.isEmpty
                        ? _EmptyState(
                            onAdd: () => context.push('/subscriptions/add'),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: visible.length,
                            separatorBuilder: (_, _) =>
                                Divider(color: c.hairline, height: 1),
                            itemBuilder: (context, index) => _SubscriptionRow(
                              subscription: visible[index],
                              currency: currency,
                            ),
                          ),
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, size: 17, color: c.muted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: t.body,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search',
                hintStyle: t.body.copyWith(color: c.muted),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionRow extends StatelessWidget {
  const _SubscriptionRow({required this.subscription, required this.currency});

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
                  Text.rich(
                    TextSpan(
                      style: t.caption,
                      children: [
                        if (subscription.isInTrial)
                          TextSpan(
                            text: 'Trial · ',
                            style: t.caption.copyWith(
                              color: c.accentText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        TextSpan(
                          text: '${subscription.category.displayName} · '
                              '${subscription.billingCycle.displayName}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyUtils.formatGrouped(
                    subscription.monthlyCostIn(currency),
                    currency,
                  ),
                  style: t.rowAmount,
                ),
                const SizedBox(height: 2),
                Text('/mo', style: t.caption.copyWith(fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final t = context.ledgerText;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No subscriptions yet', style: t.sectionHeader),
          const SizedBox(height: 6),
          Text(
            'Start tracking your recurring expenses.',
            style: t.captionLarge,
          ),
          const SizedBox(height: 20),
          LedgerPrimaryButton(label: 'Add subscription', onPressed: onAdd),
        ],
      ),
    );
  }
}
