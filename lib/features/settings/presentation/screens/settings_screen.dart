import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../shared/widgets/ledger/ledger_widgets.dart';
import '../../../subscriptions/providers/subscriptions_providers.dart';
import '../../providers/settings_providers.dart';

/// Settings — account, preferences, notifications, data.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: settingsAsync.when(
          data: (settings) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nav row: back chevron (pushed route)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
                const SizedBox(height: 8),
                Text('Settings', style: t.screenTitleLarge),
                const SizedBox(height: 18),
                const _ProfileCard(),
                const SizedBox(height: 26),
                const SectionLabel('Preferences'),
                const SizedBox(height: 10),
                LedgerCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _SettingsRow(
                        iconBg: c.accent,
                        iconGlyph: const Text(
                          '€',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        label: 'Currency',
                        value: settings.currency == 'EUR'
                            ? 'EUR (€)'
                            : 'USD (\$)',
                        onTap: () => _pickCurrency(context, ref, settings),
                      ),
                      Divider(color: c.hairline2, height: 1),
                      _SettingsRow(
                        iconBg: c.accent300,
                        iconGlyph: const Icon(
                          CupertinoIcons.chart_bar,
                          size: 14,
                          color: Colors.white,
                        ),
                        label: 'Monthly budget',
                        value: settings.monthlyBudget != null
                            ? CurrencyUtils.formatGrouped(
                                settings.monthlyBudget!,
                                settings.currency,
                              )
                            : 'Not set',
                        onTap: () => _editBudget(context, ref, settings),
                      ),
                      Divider(color: c.hairline2, height: 1),
                      _SettingsRow(
                        iconBg: c.accent200,
                        iconGlyph: const Icon(
                          CupertinoIcons.sun_max,
                          size: 14,
                          color: Colors.white,
                        ),
                        label: 'Appearance',
                        value: switch (settings.themeMode) {
                          ThemeMode.system => 'System',
                          ThemeMode.light => 'Light',
                          ThemeMode.dark => 'Dark',
                        },
                        onTap: () => _pickAppearance(context, ref, settings),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const SectionLabel('Notifications'),
                const SizedBox(height: 10),
                LedgerCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _SwitchRow(
                        label: 'Renewal reminders',
                        value: settings.renewalReminders,
                        onChanged: (v) => ref
                            .read(settingsProvider.notifier)
                            .setRenewalReminders(v),
                      ),
                      Divider(color: c.hairline2, height: 1),
                      _SwitchRow(
                        label: 'Price change alerts',
                        value: settings.priceChangeAlerts,
                        onChanged: (v) => ref
                            .read(settingsProvider.notifier)
                            .setPriceChangeAlerts(v),
                      ),
                      Divider(color: c.hairline2, height: 1),
                      _SwitchRow(
                        label: 'Weekly summary',
                        value: settings.weeklySummary,
                        onChanged: (v) => ref
                            .read(settingsProvider.notifier)
                            .setWeeklySummary(v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const SectionLabel('Data'),
                const SizedBox(height: 10),
                LedgerCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => context.push('/import'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Import data', style: t.body),
                              ),
                              Icon(
                                CupertinoIcons.chevron_right,
                                size: 14,
                                color: c.chevron,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: c.hairline2, height: 1),
                      InkWell(
                        onTap: () => _exportCsv(context, ref),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Export as CSV', style: t.body),
                              ),
                              Icon(
                                CupertinoIcons.chevron_right,
                                size: 14,
                                color: c.chevron,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: c.hairline2, height: 1),
                      InkWell(
                        onTap: () => _confirmDeleteAll(context, ref),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Delete all data',
                                  style:
                                      t.rowTitle.copyWith(color: c.danger),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Center(child: Text('Subly v1.0.0', style: t.footnote)),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Something went wrong', style: t.body),
          ),
        ),
      ),
    );
  }

  Future<void> _pickCurrency(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final picked = await showLedgerPicker<String>(
      context: context,
      title: 'Currency',
      selected: settings.currency,
      options: const [
        LedgerPickerOption(value: 'EUR', label: 'EUR (€)', detail: 'Euro'),
        LedgerPickerOption(value: 'USD', label: 'USD (\$)', detail: 'US Dollar'),
      ],
    );
    if (picked != null) {
      await ref.read(settingsProvider.notifier).setCurrency(picked);
    }
  }

  Future<void> _pickAppearance(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final picked = await showLedgerPicker<ThemeMode>(
      context: context,
      title: 'Appearance',
      selected: settings.themeMode,
      options: const [
        LedgerPickerOption(value: ThemeMode.light, label: 'Light'),
        LedgerPickerOption(value: ThemeMode.dark, label: 'Dark'),
        LedgerPickerOption(
          value: ThemeMode.system,
          label: 'System',
          detail: 'Follow device setting',
        ),
      ],
    );
    if (picked != null) {
      await ref.read(settingsProvider.notifier).setThemeMode(picked);
    }
  }

  Future<void> _editBudget(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final t = context.ledgerText;
    final controller = TextEditingController(
      text: settings.monthlyBudget?.toStringAsFixed(2) ?? '',
    );
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monthly budget', style: t.sectionHeader),
            const SizedBox(height: 4),
            Text('Leave empty to remove the budget.', style: t.caption),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: t.body,
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText:
                    '${CurrencyUtils.getSymbol(settings.currency)} ',
              ),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
            const SizedBox(height: 16),
            LedgerPrimaryButton(
              label: 'Save',
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        ),
      ),
    );
    if (result != null) {
      final parsed = double.tryParse(result.trim());
      await ref.read(settingsProvider.notifier).setMonthlyBudget(
            parsed != null && parsed > 0 ? parsed : null,
          );
    }
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final active = await ref.read(activeSubscriptionsProvider.future);
      final cancelled = await ref.read(cancelledSubscriptionsProvider.future);
      final all = [...active, ...cancelled];

      if (all.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No subscriptions to export')),
          );
        }
        return;
      }

      String escape(String value) =>
          value.contains(RegExp(r'[",\n]')) ? '"${value.replaceAll('"', '""')}"' : value;

      final buffer = StringBuffer(
        'Name,Price,Currency,Billing cycle,Category,Start date,Next charge,Status\n',
      );
      for (final sub in all) {
        buffer.writeln([
          escape(sub.name),
          sub.price.toStringAsFixed(2),
          sub.currency,
          sub.billingCycle.displayName,
          sub.category.displayName,
          sub.startDate.toIso8601String().split('T').first,
          sub.nextBillingDate.toIso8601String().split('T').first,
          sub.isActive ? 'Active' : 'Canceled',
        ].join(','));
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/subly_export.csv');
      await file.writeAsString(buffer.toString());

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Subly subscriptions export',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _confirmDeleteAll(BuildContext context, WidgetRef ref) async {
    final danger = context.ledgerColors.danger;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all data?'),
        content: const Text(
          'This permanently deletes all your subscriptions. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final active = await ref.read(activeSubscriptionsProvider.future);
      final cancelled = await ref.read(cancelledSubscriptionsProvider.future);
      for (final sub in [...active, ...cancelled]) {
        await repository.deleteSubscription(sub.id);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All subscriptions deleted')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return LedgerCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: c.avatarGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subly account', style: t.wordmark),
                const SizedBox(height: 2),
                Text('Data stored on this device', style: t.captionLarge),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: c.chevron,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.iconBg,
    required this.iconGlyph,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final Color iconBg;
  final Widget iconGlyph;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: iconGlyph),
            ),
            const SizedBox(width: 13),
            Expanded(child: Text(label, style: t.body)),
            Text(
              value,
              style: t.captionLarge.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 6),
            Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: c.chevron,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.ledgerText.body),
          LedgerSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
