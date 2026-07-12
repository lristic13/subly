import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../shared/widgets/ledger/ledger_widgets.dart';
import '../../../catalog/domain/models/catalog_item.dart';
import '../../../catalog/providers/catalog_providers.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../../subscriptions/domain/models/billing_cycle.dart';
import '../../../subscriptions/domain/models/subscription.dart';
import '../../../subscriptions/domain/models/subscription_category.dart';
import '../../domain/import_parser.dart';

/// Import subscriptions from a CSV file (Excel, Numbers, Sheets) or
/// pasted free text (Notes, reminders, plain lists).
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _DraftItem {
  _DraftItem(this.parsed) : include = true;

  final ImportedSubscription parsed;
  bool include;
  CatalogItem? catalogMatch;
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  List<_DraftItem>? _drafts;
  int _skipped = 0;
  bool _importing = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt', 'tsv'],
      withData: true,
    );
    final bytes = result?.files.firstOrNull?.bytes;
    if (bytes == null) return;
    _applyParsed(utf8.decode(bytes, allowMalformed: true));
  }

  Future<void> _pasteText() async {
    final t = context.ledgerText;
    final controller = TextEditingController();
    final text = await showModalBottomSheet<String>(
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
            Text('Paste your list', style: t.sectionHeader),
            const SizedBox(height: 4),
            Text(
              'One subscription per line, e.g. "Netflix – 17,99 € monthly".',
              style: t.caption,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 8,
              minLines: 4,
              style: t.body,
              decoration: const InputDecoration(
                hintText: 'Netflix 17,99\nSpotify 10,99\niCloud+ 2,99',
              ),
            ),
            const SizedBox(height: 16),
            LedgerPrimaryButton(
              label: 'Parse',
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        ),
      ),
    );
    if (text != null && text.trim().isNotEmpty) {
      _applyParsed(text);
    }
  }

  Future<void> _applyParsed(String raw) async {
    final result = parseSubscriptionImport(raw);
    final catalog = await ref.read(catalogItemsProvider.future);

    final drafts = [for (final item in result.items) _DraftItem(item)];
    for (final draft in drafts) {
      draft.catalogMatch = _matchCatalog(draft.parsed.name, catalog);
    }

    if (!mounted) return;
    setState(() {
      _drafts = drafts;
      _skipped = result.skippedLines;
    });
    if (drafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't find any subscriptions in that input"),
        ),
      );
    }
  }

  CatalogItem? _matchCatalog(String name, List<CatalogItem> catalog) {
    final n = name.toLowerCase().trim();
    for (final item in catalog) {
      if (item.name.toLowerCase() == n) return item;
    }
    for (final item in catalog) {
      final c = item.name.toLowerCase();
      if (n.startsWith(c) || c.startsWith(n)) return item;
    }
    return null;
  }

  Future<void> _import() async {
    final drafts = _drafts?.where((d) => d.include).toList() ?? [];
    if (drafts.isEmpty) return;
    setState(() => _importing = true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final defaultCurrency =
          ref.read(settingsProvider).valueOrNull?.currency ?? 'EUR';
      final now = DateTime.now();

      for (final draft in drafts) {
        final parsed = draft.parsed;
        final match = draft.catalogMatch;
        final cycle = parsed.cycle ?? match?.defaultCycle ?? BillingCycle.monthly;
        final startDate = parsed.startDate ?? now;
        var nextBilling = parsed.nextBillingDate ??
            (parsed.startDate != null ? parsed.startDate! : now);
        final startOfToday = DateTime(now.year, now.month, now.day);
        while (nextBilling.isBefore(startOfToday)) {
          nextBilling = cycle.nextBillingDate(nextBilling);
        }

        await repository.addSubscription(Subscription(
          id: const Uuid().v4(),
          name: parsed.name,
          price: parsed.price,
          currency: parsed.currency ?? defaultCurrency,
          billingCycle: cycle,
          category: parsed.category ??
              match?.category ??
              SubscriptionCategory.other,
          startDate: startDate,
          nextBillingDate: nextBilling,
          domain: match?.domain,
          brandColor: match?.brandColor,
          catalogItemId: match?.id,
          isActive: parsed.isActive,
          cancelledDate: parsed.isActive ? null : now,
          createdAt: now,
          updatedAt: now,
        ));
      }

      if (mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Imported ${drafts.length} subscription${drafts.length == 1 ? '' : 's'}',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Import failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultCurrency =
        ref.watch(settingsProvider).valueOrNull?.currency ?? 'EUR';
    final drafts = _drafts;
    final selectedCount = drafts?.where((d) => d.include).length ?? 0;
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 8),
                  Text('Import', style: t.screenTitleLarge),
                  const SizedBox(height: 6),
                  Text(
                    'Bring subscriptions from a spreadsheet or notes.',
                    style: t.captionLarge,
                  ),
                  const SizedBox(height: 20),
                  _SourceCard(
                    icon: CupertinoIcons.doc,
                    title: 'Choose CSV file',
                    subtitle: 'Exported from Excel, Numbers, or Sheets',
                    onTap: _pickFile,
                  ),
                  const SizedBox(height: 10),
                  _SourceCard(
                    icon: CupertinoIcons.text_alignleft,
                    title: 'Paste text',
                    subtitle: 'A list from Notes — one per line',
                    onTap: _pasteText,
                  ),
                ],
              ),
            ),
            if (drafts != null && drafts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionLabel(
                      '${drafts.length} found'
                      '${_skipped > 0 ? ' · $_skipped skipped' : ''}',
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        final allOn = drafts.every((d) => d.include);
                        for (final d in drafts) {
                          d.include = !allOn;
                        }
                      }),
                      child: Text(
                        drafts.every((d) => d.include)
                            ? 'Deselect all'
                            : 'Select all',
                        style: t.caption.copyWith(
                          color: c.accentText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  itemCount: drafts.length,
                  separatorBuilder: (_, _) =>
                      Divider(color: c.hairline, height: 1),
                  itemBuilder: (context, index) => _DraftRow(
                    draft: drafts[index],
                    defaultCurrency: defaultCurrency,
                    onToggle: () => setState(
                      () => drafts[index].include = !drafts[index].include,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: LedgerPrimaryButton(
                  label: selectedCount > 0
                      ? 'Import $selectedCount subscription'
                          '${selectedCount == 1 ? '' : 's'}'
                      : 'Nothing selected',
                  loading: _importing,
                  onPressed: selectedCount > 0 ? _import : null,
                ),
              ),
            ] else
              const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return LedgerCard(
      radius: 16,
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 19, color: c.accentText),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.rowTitle),
                  const SizedBox(height: 2),
                  Text(subtitle, style: t.caption),
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
      ),
    );
  }
}

class _DraftRow extends StatelessWidget {
  const _DraftRow({
    required this.draft,
    required this.defaultCurrency,
    required this.onToggle,
  });

  final _DraftItem draft;
  final String defaultCurrency;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final parsed = draft.parsed;
    final currency = parsed.currency ?? defaultCurrency;
    final cycle =
        parsed.cycle ?? draft.catalogMatch?.defaultCycle ?? BillingCycle.monthly;
    final category = parsed.category ?? draft.catalogMatch?.category;
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Icon(
              draft.include
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle,
              size: 24,
              color: draft.include ? c.accent : c.iconInactive,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parsed.name,
                    style: t.rowTitle.copyWith(
                      color: draft.include ? c.ink : c.muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      cycle.displayName,
                      if (category != null) category.displayName,
                      if (draft.catalogMatch != null) 'Matched',
                    ].join(' · '),
                    style: t.caption,
                  ),
                ],
              ),
            ),
            Text(
              CurrencyUtils.formatGrouped(parsed.price, currency),
              style: t.rowAmount.copyWith(
                color: draft.include ? c.ink : c.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
