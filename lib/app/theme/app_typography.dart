import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// The Ledger type scale, colored for one palette. Resolve the active set
/// with [AppTypography.of] (or `context.ledgerText`).
/// Letter-spacing values are em × font size (Flutter uses logical px).
class LedgerTextStyles {
  LedgerTextStyles(LedgerColors c)
      : heroAmount = _base(
          size: 56,
          weight: FontWeight.w700,
          spacingEm: -0.035,
          height: 1.0,
          color: c.inkStrong,
          tabular: true,
        ),
        screenTitleLarge = _base(
          size: 30,
          weight: FontWeight.w700,
          spacingEm: -0.03,
          color: c.inkStrong,
        ),
        detailPrice = _base(
          size: 44,
          weight: FontWeight.w700,
          spacingEm: -0.03,
          height: 1.0,
          color: c.inkStrong,
          tabular: true,
        ),
        addAmount = _base(
          size: 52,
          weight: FontWeight.w700,
          spacingEm: -0.03,
          height: 1.0,
          color: c.inkStrong,
          tabular: true,
        ),
        addAmountPrefix = _base(
          size: 34,
          weight: FontWeight.w600,
          height: 1.0,
          color: c.muted,
        ),
        screenTitle = _base(
          size: 22,
          weight: FontWeight.w700,
          spacingEm: -0.02,
          color: c.inkStrong,
        ),
        detailName = _base(
          size: 23,
          weight: FontWeight.w700,
          color: c.inkStrong,
        ),
        sectionHeader = _base(
          size: 17,
          weight: FontWeight.w600,
          color: c.inkStrong,
        ),
        wordmark = _base(
          size: 17,
          weight: FontWeight.w700,
          spacingEm: -0.02,
          color: c.inkStrong,
        ),
        rowTitle = _base(size: 15, weight: FontWeight.w600, color: c.ink),
        rowAmount = _base(
          size: 15,
          weight: FontWeight.w600,
          color: c.ink,
          tabular: true,
        ),
        body = _base(size: 15, weight: FontWeight.w500, color: c.ink),
        caption = _base(size: 12, weight: FontWeight.w400, color: c.muted),
        captionLarge =
            _base(size: 13, weight: FontWeight.w400, color: c.muted),
        sectionLabel = _base(
          size: 12,
          weight: FontWeight.w600,
          spacingEm: 0.06,
          color: c.muted2,
        ),
        footnote = _base(size: 12, weight: FontWeight.w400, color: c.footnote),
        button = _base(size: 15, weight: FontWeight.w600, color: Colors.white);

  /// Hero amount on Home: 56 / w700 / -0.035em, line-height 1.0
  final TextStyle heroAmount;

  /// Large screen title ("Subscriptions", "Insights", "Settings"): 30 / w700
  final TextStyle screenTitleLarge;

  /// Detail price: 44 / w700
  final TextStyle detailPrice;

  /// Add screen amount: 52 / w700
  final TextStyle addAmount;

  /// Muted "€" prefix next to the add amount: 34 / w600
  final TextStyle addAmountPrefix;

  /// Medium screen title ("New subscription"): 22 / w700
  final TextStyle screenTitle;

  /// Detail header name: 23 / w700
  final TextStyle detailName;

  /// Section header ("Upcoming", "Monthly spend"): 17 / w600
  final TextStyle sectionHeader;

  /// Wordmark "Subly": 17 / w700
  final TextStyle wordmark;

  /// List row title: 15 / w600
  final TextStyle rowTitle;

  /// Money in list rows: 15 / w600 tabular
  final TextStyle rowAmount;

  /// Setting labels / body: 15 / w500
  final TextStyle body;

  /// Secondary text under row titles: 12 / w400 muted
  final TextStyle caption;

  /// Slightly larger secondary text: 13 / w400 muted
  final TextStyle captionLarge;

  /// Uppercase section label: 12 / w600 / +0.06em, muted2
  final TextStyle sectionLabel;

  /// Tiny footnote (version string)
  final TextStyle footnote;

  /// Primary button label (white on accent in both modes)
  final TextStyle button;

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    double? spacingEm,
    double? height,
    Color? color,
    bool tabular = false,
  }) {
    return GoogleFonts.instrumentSans(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacingEm != null ? size * spacingEm : null,
      height: height,
      color: color,
      fontFeatures: tabular ? AppTypography.tabularFigures : null,
    );
  }
}

/// Typography for the "Ledger" design — Instrument Sans throughout.
abstract final class AppTypography {
  static TextStyle get _base => GoogleFonts.instrumentSans();

  static const tabularFigures = [FontFeature.tabularFigures()];

  static final _light = LedgerTextStyles(AppColors.light);
  static final _dark = LedgerTextStyles(AppColors.dark);

  /// Resolve the Ledger text styles for the ambient theme brightness.
  static LedgerTextStyles of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _dark : _light;

  // ── Legacy names (still used by onboarding/catalog screens) ───

  static TextStyle get displayLarge => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      );

  static TextStyle get displayMedium => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.7,
      );

  static TextStyle get displaySmall => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineLarge => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineSmall => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleLarge => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleSmall => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelLarge => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelMedium => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelSmall => _base.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get priceLarge => _base.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        fontFeatures: tabularFigures,
      );

  static TextStyle get priceMedium => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        fontFeatures: tabularFigures,
      );

  static TextStyle get priceSmall => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        fontFeatures: tabularFigures,
      );

  /// Creates a TextTheme based on the app typography
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}

/// Terse access to the active Ledger text styles: `context.ledgerText.body`.
extension LedgerTextContext on BuildContext {
  LedgerTextStyles get ledgerText => AppTypography.of(this);
}
