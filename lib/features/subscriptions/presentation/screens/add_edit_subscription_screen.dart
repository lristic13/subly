import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../shared/widgets/ledger/ledger_widgets.dart';
import '../../../../shared/widgets/logo_image.dart';
import '../../../catalog/domain/models/catalog_item.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../domain/models/billing_cycle.dart';
import '../../domain/models/subscription.dart';
import '../../domain/models/subscription_category.dart';
import '../../providers/subscriptions_providers.dart';

/// Create or edit a subscription (Ledger "Add / Edit" screen).
class AddEditSubscriptionScreen extends ConsumerStatefulWidget {
  const AddEditSubscriptionScreen({
    super.key,
    this.subscriptionId,
    this.catalogItem,
    this.initialCurrency,
  });

  final String? subscriptionId;
  final CatalogItem? catalogItem;
  final String? initialCurrency;

  bool get isEditing => subscriptionId != null;
  bool get isFromCatalog => catalogItem != null;

  @override
  ConsumerState<AddEditSubscriptionScreen> createState() =>
      _AddEditSubscriptionScreenState();
}

class _AddEditSubscriptionScreenState
    extends ConsumerState<AddEditSubscriptionScreen> {
  final _amountController = TextEditingController();

  String _name = '';
  String _currency = 'EUR';
  BillingCycle _billingCycle = BillingCycle.monthly;
  SubscriptionCategory _category = SubscriptionCategory.other;
  DateTime _firstPayment = DateTime.now();
  String? _domain;
  String? _brandColor;
  String? _catalogItemId;
  String? _description;
  DateTime? _trialEndDate;
  DateTime? _storedNextBillingDate;
  DateTime? _storedStartDate;
  bool _billingChanged = false;

  bool _isLoading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFromCatalog) {
      final item = widget.catalogItem!;
      final currency = widget.initialCurrency ?? 'EUR';
      _initialized = true;
      _name = item.name;
      _amountController.text =
          (currency == 'EUR' ? item.defaultPriceEur : item.defaultPriceUsd)
              .toStringAsFixed(2);
      _domain = item.domain;
      _currency = currency;
      _billingCycle = item.defaultCycle;
      _category = item.category;
      _catalogItemId = item.id;
      _brandColor = item.brandColor;
    } else if (widget.initialCurrency != null) {
      _currency = widget.initialCurrency!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _initializeFromSubscription(Subscription subscription) {
    if (_initialized) return;
    _initialized = true;
    _name = subscription.name;
    _amountController.text = subscription.price.toStringAsFixed(2);
    _currency = subscription.currency;
    _billingCycle = subscription.billingCycle;
    _category = subscription.category;
    _firstPayment = subscription.startDate;
    _domain = subscription.domain;
    _brandColor = subscription.brandColor;
    _catalogItemId = subscription.catalogItemId;
    _description = subscription.description;
    _trialEndDate = subscription.trialEndDate;
    _storedNextBillingDate = subscription.nextBillingDate;
    _storedStartDate = subscription.startDate;
  }

  /// First charge date rolled forward with the billing cycle until it lands
  /// today or later. During a free trial the first charge is the trial end.
  DateTime get _nextBillingDate {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    if (_trialEndDate != null && !_trialEndDate!.isBefore(startOfToday)) {
      return _trialEndDate!;
    }
    if (widget.isEditing && !_billingChanged && _storedNextBillingDate != null) {
      return _storedNextBillingDate!;
    }
    var next = _firstPayment;
    while (next.isBefore(startOfToday)) {
      next = _billingCycle.nextBillingDate(next);
    }
    return next;
  }

  bool get _isValid =>
      _name.trim().isNotEmpty &&
      (double.tryParse(_amountController.text) ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;

    if (widget.isEditing) {
      final subscriptionAsync =
          ref.watch(subscriptionByIdProvider(widget.subscriptionId!));
      return subscriptionAsync.when(
        data: (subscription) {
          if (subscription == null) {
            return Scaffold(
              backgroundColor: c.bg,
              body: SafeArea(
                child: Center(
                  child: Text('Subscription not found', style: t.body),
                ),
              ),
            );
          }
          _initializeFromSubscription(subscription);
          return _buildForm(context);
        },
        loading: () => Scaffold(
          backgroundColor: c.bg,
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          backgroundColor: c.bg,
          body: SafeArea(
            child: Center(
              child: Text('Something went wrong', style: t.body),
            ),
          ),
        ),
      );
    }
    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final remindersOn = settings.valueOrNull?.renewalReminders ?? true;
    final dateFormat = DateFormat('MMM d, yyyy');
    final c = context.ledgerColors;
    final t = context.ledgerText;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: title + close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEditing ? 'Edit subscription' : 'New subscription',
                    style: t.screenTitle,
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 22,
                        color: c.muted2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Service selector
              LedgerCard(
                radius: 16,
                padding: const EdgeInsets.all(12),
                child: InkWell(
                  onTap: _editName,
                  child: Row(
                    children: [
                      LogoImage(
                        name: _name.isEmpty ? '?' : _name,
                        domain: _domain,
                        brandColor: _brandColor,
                        size: 42,
                        radius: 12,
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Service', style: t.caption),
                            const SizedBox(height: 2),
                            Text(
                              _name.isEmpty ? 'Choose service' : _name,
                              style: t.rowTitle.copyWith(
                                color: _name.isEmpty ? c.muted : c.ink,
                              ),
                            ),
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
              ),
              const SizedBox(height: 28),
              // Amount entry
              Center(
                child: Column(
                  children: [
                    Text('Amount', style: t.captionLarge),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_currencySymbol, style: t.addAmountPrefix),
                        const SizedBox(width: 6),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _amountController,
                            onChanged: (_) => setState(() {}),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            style: t.addAmount,
                            cursorColor: c.accent,
                            decoration: InputDecoration(
                              hintText: '0.00',
                              hintStyle: t.addAmount.copyWith(color: c.muted2),
                              filled: false,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.only(bottom: 6),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: c.accent,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: c.accent,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: c.accent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Fields card
              LedgerCard(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    _FieldRow(
                      label: 'Billing cycle',
                      value: _billingCycle.displayName,
                      onTap: _pickBillingCycle,
                    ),
                    Divider(color: c.hairline2, height: 1),
                    _FieldRow(
                      label: 'First payment',
                      value: dateFormat.format(_firstPayment),
                      onTap: _pickFirstPayment,
                    ),
                    Divider(color: c.hairline2, height: 1),
                    _FieldRow(
                      label: 'Category',
                      value: _category.displayName,
                      accent: true,
                      onTap: _pickCategory,
                    ),
                    Divider(color: c.hairline2, height: 1),
                    _FieldRow(
                      label: 'Currency',
                      value: _currency == 'EUR' ? 'EUR (€)' : 'USD (\$)',
                      onTap: _pickCurrency,
                    ),
                    Divider(color: c.hairline2, height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Free trial', style: t.body),
                          LedgerSwitch(
                            value: _trialEndDate != null,
                            onChanged: (value) => setState(() {
                              _trialEndDate = value
                                  ? DateTime.now()
                                      .add(const Duration(days: 7))
                                  : null;
                            }),
                          ),
                        ],
                      ),
                    ),
                    if (_trialEndDate != null) ...[
                      Divider(color: c.hairline2, height: 1),
                      _FieldRow(
                        label: 'Trial ends',
                        value: dateFormat.format(_trialEndDate!),
                        accent: true,
                        onTap: _pickTrialEnd,
                      ),
                    ],
                    Divider(color: c.hairline2, height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Remind me before', style: t.body),
                          LedgerSwitch(
                            value: remindersOn,
                            onChanged: (value) => ref
                                .read(settingsProvider.notifier)
                                .setRenewalReminders(value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              LedgerPrimaryButton(
                label: widget.isEditing ? 'Save changes' : 'Add subscription',
                loading: _isLoading,
                onPressed: _isValid ? _save : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _currencySymbol => _currency == 'EUR' ? '€' : '\$';

  Future<void> _editName() async {
    final t = context.ledgerText;
    final controller = TextEditingController(text: _name);
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
            Text('Service name', style: t.sectionHeader),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              style: t.body,
              decoration: const InputDecoration(hintText: 'e.g. Netflix'),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
            const SizedBox(height: 16),
            LedgerPrimaryButton(
              label: 'Done',
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        ),
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() => _name = result.trim());
    }
  }

  Future<void> _pickBillingCycle() async {
    final picked = await showLedgerPicker<BillingCycle>(
      context: context,
      title: 'Billing cycle',
      selected: _billingCycle,
      options: [
        for (final cycle in BillingCycle.values)
          LedgerPickerOption(value: cycle, label: cycle.displayName),
      ],
    );
    if (picked != null && picked != _billingCycle) {
      setState(() {
        _billingCycle = picked;
        _billingChanged = true;
      });
    }
  }

  Future<void> _pickTrialEnd() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _trialEndDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _trialEndDate = picked);
  }

  Future<void> _pickFirstPayment() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _firstPayment,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _firstPayment = picked;
        _billingChanged = true;
      });
    }
  }

  Future<void> _pickCategory() async {
    final picked = await showLedgerPicker<SubscriptionCategory>(
      context: context,
      title: 'Category',
      selected: _category,
      options: [
        for (final category in SubscriptionCategory.values)
          LedgerPickerOption(value: category, label: category.displayName),
      ],
    );
    if (picked != null) setState(() => _category = picked);
  }

  Future<void> _pickCurrency() async {
    final picked = await showLedgerPicker<String>(
      context: context,
      title: 'Currency',
      selected: _currency,
      options: const [
        LedgerPickerOption(value: 'EUR', label: 'EUR (€)', detail: 'Euro'),
        LedgerPickerOption(value: 'USD', label: 'USD (\$)', detail: 'US Dollar'),
      ],
    );
    if (picked != null) setState(() => _currency = picked);
  }

  Future<void> _save() async {
    if (!_isValid) return;
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final now = DateTime.now();

      final subscription = Subscription(
        id: widget.subscriptionId ?? const Uuid().v4(),
        name: _name.trim(),
        // Round to whole cents so float noise never enters the database.
        price: (double.parse(_amountController.text) * 100).round() / 100,
        currency: _currency,
        billingCycle: _billingCycle,
        category: _category,
        startDate: widget.isEditing && !_billingChanged
            ? (_storedStartDate ?? _firstPayment)
            : _firstPayment,
        nextBillingDate: _nextBillingDate,
        trialEndDate: _trialEndDate,
        description: _description,
        domain: _domain,
        catalogItemId: _catalogItemId,
        brandColor: _brandColor,
        isActive: true,
        createdAt: widget.isEditing ? null : now,
        updatedAt: now,
      );

      if (widget.isEditing) {
        await repository.updateSubscription(subscription);
      } else {
        await repository.addSubscription(subscription);
      }

      if (mounted) {
        HapticFeedback.mediumImpact();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.accent = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    final t = context.ledgerText;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(label, style: t.body)),
            if (accent) ...[
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: c.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
            ],
            Text(
              value,
              style: t.rowTitle.copyWith(
                color: accent ? c.accentText : c.muted,
              ),
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
