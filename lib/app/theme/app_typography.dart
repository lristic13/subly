import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography for the "Ledger" design — Instrument Sans throughout.
/// Letter-spacing values are em × font size (Flutter uses logical px).
abstract final class AppTypography {
  static TextStyle get _base => GoogleFonts.instrumentSans();

  static const tabularFigures = [FontFeature.tabularFigures()];

  // ── Ledger scale ──────────────────────────────────────────────

  /// Hero amount on Home: 56 / w700 / -0.035em, line-height 1.0
  static TextStyle get heroAmount => _base.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: 56 * -0.035,
        height: 1.0,
        color: AppColors.inkStrong,
        fontFeatures: tabularFigures,
      );

  /// Large screen title ("Subscriptions", "Insights", "Settings"): 30 / w700
  static TextStyle get screenTitleLarge => _base.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: 30 * -0.03,
        color: AppColors.inkStrong,
      );

  /// Detail price: 44 / w700
  static TextStyle get detailPrice => _base.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        letterSpacing: 44 * -0.03,
        height: 1.0,
        color: AppColors.inkStrong,
        fontFeatures: tabularFigures,
      );

  /// Add screen amount: 52 / w700
  static TextStyle get addAmount => _base.copyWith(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        letterSpacing: 52 * -0.03,
        height: 1.0,
        color: AppColors.inkStrong,
        fontFeatures: tabularFigures,
      );

  /// Muted "€" prefix next to the add amount: 34 / w600
  static TextStyle get addAmountPrefix => _base.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: AppColors.muted,
      );

  /// Medium screen title ("New subscription"): 22 / w700
  static TextStyle get screenTitle => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 22 * -0.02,
        color: AppColors.inkStrong,
      );

  /// Detail header name: 23 / w700
  static TextStyle get detailName => _base.copyWith(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: AppColors.inkStrong,
      );

  /// Section header ("Upcoming", "Monthly spend"): 17 / w600
  static TextStyle get sectionHeader => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.inkStrong,
      );

  /// Wordmark "Subly": 17 / w700
  static TextStyle get wordmark => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: 17 * -0.02,
        color: AppColors.inkStrong,
      );

  /// List row title / amounts: 15 / w600
  static TextStyle get rowTitle => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );

  /// Money in list rows: 15 / w600 tabular
  static TextStyle get rowAmount => rowTitle.copyWith(
        fontFeatures: tabularFigures,
      );

  /// Setting labels / body: 15 / w500
  static TextStyle get body => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
      );

  /// Secondary text under row titles: 12 / w400 muted
  static TextStyle get caption => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      );

  /// Slightly larger secondary text: 13 / w400 muted
  static TextStyle get captionLarge => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      );

  /// Uppercase section label: 12 / w600 / +0.06em, muted2
  static TextStyle get sectionLabel => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 12 * 0.06,
        color: AppColors.muted2,
      );

  /// Tiny footnote (version string)
  static TextStyle get footnote => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.footnote,
      );

  /// Primary button label
  static TextStyle get button => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

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
