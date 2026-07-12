import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

/// White card with a hairline border and no shadow — the Ledger surface.
class LedgerCard extends StatelessWidget {
  const LedgerCard({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.hairline),
      ),
      child: child,
    );
  }
}

/// Uppercase section label above grouped cards.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTypography.sectionLabel);
  }
}

/// Custom switch matching the Ledger spec: 48×29 track, 24 knob, 2.5 inset.
class LedgerSwitch extends StatelessWidget {
  const LedgerSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 48,
        height: 29,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: value ? AppColors.accent : AppColors.toggleOff,
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width indigo primary button.
class LedgerPrimaryButton extends StatelessWidget {
  const LedgerPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(label, style: AppTypography.button),
        ),
      ),
    );
  }
}

/// Option shown in a [showLedgerPicker] sheet.
class LedgerPickerOption<T> {
  const LedgerPickerOption({
    required this.value,
    required this.label,
    this.detail,
  });

  final T value;
  final String label;
  final String? detail;
}

/// Ledger-styled selection sheet. Returns the picked value or null.
Future<T?> showLedgerPicker<T>({
  required BuildContext context,
  required String title,
  required List<LedgerPickerOption<T>> options,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(title, style: AppTypography.sectionHeader),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                for (final option in options)
                  InkWell(
                    onTap: () => Navigator.pop(context, option.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 13,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.label,
                                  style: AppTypography.rowTitle,
                                ),
                                if (option.detail != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    option.detail!,
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (option.value == selected)
                            const Icon(
                              CupertinoIcons.checkmark_alt,
                              size: 20,
                              color: AppColors.accent,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
