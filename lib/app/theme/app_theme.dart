import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// UI design tokens from the Ledger handoff.
abstract final class AppThemeTokens {
  // Border radius
  static const double radiusCardLarge = 20; // settings / detail cards
  static const double radiusCard = 16; // list item cards
  static const double radiusHero = 22; // insights hero
  static const double radiusTile = 11; // brand monogram tiles (38px)
  static const double radiusField = 12; // search / filter fields
  static const double radiusButton = 14; // primary buttons
  static const double radiusPill = 999;

  // Legacy aliases
  static const double radiusInput = radiusField;

  // Spacing
  static const double screenPadding = 24; // horizontal screen padding
  static const double screenBottomPadding = 40;
  static const double iconTextGap = 13; // tile-to-text gap
  static const double rowVerticalPadding = 11; // list rows
  static const double cardRowPadding = 14; // rows inside white cards

  static const double spacingUnit = 4;
  static const double spacing2 = 8;
  static const double spacing3 = 12;
  static const double spacing4 = 16;
  static const double spacing5 = 20;
  static const double spacing6 = 24;
  static const double spacing8 = 32;
  static const double spacing10 = 40;
  static const double spacing12 = 48;
}

/// Light and dark theme definitions, both built from the Ledger palettes.
abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(LedgerColors c, Brightness brightness) {
    final ledgerText = LedgerTextStyles(c);
    final textTheme = AppTypography.textTheme.apply(
      bodyColor: c.ink,
      displayColor: c.inkStrong,
    );
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: c.accent,
            onPrimary: Colors.white,
            primaryContainer: c.accent100,
            onPrimaryContainer: c.accentText,
            secondary: c.accent300,
            onSecondary: Colors.white,
            secondaryContainer: c.accent100,
            onSecondaryContainer: c.accentText,
            error: c.danger,
            onError: Colors.white,
            surface: c.surface,
            onSurface: c.ink,
            onSurfaceVariant: c.muted,
            outline: c.hairline,
            outlineVariant: c.hairline2,
          )
        : ColorScheme.light(
            primary: c.accent,
            onPrimary: Colors.white,
            primaryContainer: c.accent100,
            onPrimaryContainer: c.accent,
            secondary: c.accent300,
            onSecondary: Colors.white,
            secondaryContainer: c.accent100,
            onSecondaryContainer: c.accent,
            error: c.danger,
            onError: Colors.white,
            surface: c.surface,
            onSurface: c.ink,
            onSurfaceVariant: c.muted,
            outline: c.hairline,
            outlineVariant: c.hairline2,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.bg,
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        foregroundColor: c.inkStrong,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: ledgerText.sectionHeader,
      ),
      // No shadows — Ledger uses hairline borders instead of elevation.
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusCard),
          side: BorderSide(color: c.hairline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeTokens.radiusButton),
          ),
          textStyle: ledgerText.button,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeTokens.radiusButton),
          ),
          textStyle: ledgerText.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.accentText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeTokens.radiusButton),
          ),
          side: BorderSide(color: c.accent),
          textStyle: ledgerText.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accentText,
          textStyle: ledgerText.rowTitle,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.fieldBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppThemeTokens.spacing4,
          vertical: AppThemeTokens.spacing3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusField),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusField),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusField),
          borderSide: BorderSide(color: c.accent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusField),
          borderSide: BorderSide(color: c.danger),
        ),
        hintStyle: ledgerText.body.copyWith(color: c.muted),
      ),
      dividerTheme: DividerThemeData(
        color: c.hairline,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? c.accent
              : c.toggleOff,
        ),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.fieldBg,
        labelStyle: AppTypography.labelMedium.copyWith(color: c.accentText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusField),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppThemeTokens.radiusCardLarge),
        ),
        titleTextStyle: ledgerText.sectionHeader,
        contentTextStyle: ledgerText.body.copyWith(color: c.muted),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? c.surfaceElevated : c.inkStrong,
        contentTextStyle: ledgerText.body.copyWith(
          color: isDark ? c.ink : Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surfaceElevated,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
