import 'package:flutter/material.dart';

/// The full Ledger palette for one brightness. Screens resolve the active
/// palette with [AppColors.of] (or `context.ledgerColors`) so every token
/// adapts to light/dark automatically.
class LedgerColors {
  const LedgerColors({
    required this.bg,
    required this.surface,
    required this.surfaceElevated,
    required this.ink,
    required this.inkStrong,
    required this.muted,
    required this.muted2,
    required this.hairline,
    required this.hairline2,
    required this.tabDivider,
    required this.fieldBg,
    required this.accent,
    required this.accentText,
    required this.accentSoft,
    required this.accent300,
    required this.accent200,
    required this.accent100,
    required this.barTrack,
    required this.barTrackAlt,
    required this.barTrack2,
    required this.toggleOff,
    required this.iconInactive,
    required this.chevron,
    required this.danger,
    required this.footnote,
    required this.chartTeal,
    required this.chartAmber,
    required this.chartOther,
  });

  final Color bg;
  final Color surface;
  final Color surfaceElevated;
  final Color ink;
  final Color inkStrong;
  final Color muted;
  final Color muted2;
  final Color hairline;
  final Color hairline2;
  final Color tabDivider;
  final Color fieldBg;

  /// Accent as a fill (buttons, bars, dots, hero card).
  final Color accent;

  /// Accent as text/icon color — brighter than [accent] in dark mode for
  /// contrast against dark surfaces; identical to [accent] in light mode.
  final Color accentText;
  final Color accentSoft;
  final Color accent300;
  final Color accent200;
  final Color accent100;
  final Color barTrack;
  final Color barTrackAlt;
  final Color barTrack2;
  final Color toggleOff;
  final Color iconInactive;
  final Color chevron;
  final Color danger;
  final Color footnote;

  /// Distinct hues for the category charts (segmented bar, legend,
  /// progress rows): indigo, teal, amber, then neutral for "Other".
  final Color chartTeal;
  final Color chartAmber;
  final Color chartOther;

  List<Color> get chartShades => [accent, chartTeal, chartAmber, chartOther];

  /// Avatar gradient (settings profile card).
  LinearGradient get avatarGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, accent300],
      );
}

/// "Ledger" color palettes — calm, minimal, cool-neutral with a single
/// indigo accent.
abstract final class AppColors {
  static const light = LedgerColors(
    bg: Color(0xFFF6F7F9),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    ink: Color(0xFF14161C),
    inkStrong: Color(0xFF1B1D24),
    muted: Color(0xFF8A8F9C),
    muted2: Color(0xFF9AA0AB),
    hairline: Color(0xFFECEDF1),
    hairline2: Color(0xFFF1F2F5),
    tabDivider: Color(0xFFE7E8EE),
    fieldBg: Color(0xFFEDEEF2),
    accent: Color(0xFF4B53E8),
    accentText: Color(0xFF4B53E8),
    accentSoft: Color(0x1A4B53E8), // rgba(75,83,232,0.10)
    accent300: Color(0xFF8A8FF0),
    accent200: Color(0xFFC3C6F7),
    accent100: Color(0xFFE4E5FB),
    barTrack: Color(0xFFDDE0F4),
    barTrackAlt: Color(0xFFE1E3F5),
    barTrack2: Color(0xFFEDEEF2),
    toggleOff: Color(0xFFE1E3EA),
    iconInactive: Color(0xFFB9BDC6),
    chevron: Color(0xFFC0C4CC),
    danger: Color(0xFFC4362F),
    footnote: Color(0xFFB0B5BE),
    chartTeal: Color(0xFF0FA08B),
    chartAmber: Color(0xFFE0A23F),
    chartOther: Color(0xFF9AA0AB),
  );

  static const dark = LedgerColors(
    bg: Color(0xFF101116),
    surface: Color(0xFF1A1C22),
    surfaceElevated: Color(0xFF23252D),
    ink: Color(0xFFF4F5F7),
    inkStrong: Color(0xFFFFFFFF),
    muted: Color(0xFF9BA1AD),
    muted2: Color(0xFF767C88),
    hairline: Color(0x14FFFFFF), // rgba(255,255,255,0.08)
    hairline2: Color(0x0DFFFFFF), // rgba(255,255,255,0.05)
    tabDivider: Color(0x14FFFFFF),
    fieldBg: Color(0xFF23252D),
    accent: Color(0xFF7B82F5),
    accentText: Color(0xFF9DA3F7),
    accentSoft: Color(0x297B82F5), // rgba(123,130,245,0.16)
    accent300: Color(0xFF565C9C),
    accent200: Color(0xFF3B3F63),
    accent100: Color(0xFF2A2D3F),
    barTrack: Color(0xFF2A2D3F),
    barTrackAlt: Color(0xFF2A2D3F),
    barTrack2: Color(0xFF22242C),
    toggleOff: Color(0xFF33363F),
    iconInactive: Color(0xFF5A5F6A),
    chevron: Color(0xFF565B66),
    danger: Color(0xFFF06A63),
    footnote: Color(0xFF767C88), // not specced — reuses muted2
    chartTeal: Color(0xFF3BC4AC),
    chartAmber: Color(0xFFE8B45C),
    chartOther: Color(0xFF767C88),
  );

  /// Resolve the palette for the ambient theme brightness.
  static LedgerColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  // Legacy aliases still referenced by screens outside the redesign
  // (onboarding, catalog). Fixed to the light palette.
  static const primary = Color(0xFF4B53E8);
  static const primaryLight = Color(0xFF8A8FF0);
  static const primaryDark = Color(0xFF3A41C6);
  static const primaryBg = Color(0xFFE4E5FB);
  static const background = Color(0xFFF6F7F9);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFECEDF1);
  static const textPrimary = Color(0xFF14161C);
  static const textSecondary = Color(0xFF8A8F9C);
  static const danger = Color(0xFFC4362F);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // Dark mode surfaces used by the legacy screens' isDark branches.
  static const backgroundDark = Color(0xFF101116);
  static const surfaceDark = Color(0xFF1A1C22);
  static const borderDark = Color(0x14FFFFFF);
  static const textPrimaryDark = Color(0xFFF4F5F7);
  static const textSecondaryDark = Color(0xFF9BA1AD);

  // Category colors (used by the catalog browser icons)
  static const categoryStreaming = Color(0xFFEF4444);
  static const categoryMusic = Color(0xFF22C55E);
  static const categoryGaming = Color(0xFF8B5CF6);
  static const categorySoftware = Color(0xFF3B82F6);
  static const categoryCloud = Color(0xFF06B6D4);
  static const categoryNews = Color(0xFF64748B);
  static const categoryFitness = Color(0xFFF97316);
  static const categoryFood = Color(0xFFEAB308);
  static const categoryEducation = Color(0xFF14B8A6);
  static const categoryFinance = Color(0xFF10B981);
  static const categoryShopping = Color(0xFFEC4899);
  static const categoryProductivity = Color(0xFF6366F1);
  static const categorySocial = Color(0xFFF43F5E);
  static const categoryVpn = Color(0xFF0EA5E9);
  static const categoryOther = Color(0xFF9CA3AF);

  // Legacy gradients
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
}

/// Terse access to the active Ledger palette: `context.ledgerColors.accent`.
extension LedgerColorsContext on BuildContext {
  LedgerColors get ledgerColors => AppColors.of(this);
}
