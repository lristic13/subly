import 'package:flutter/material.dart';

/// "Ledger" color palette for Subly — calm, minimal, cool-neutral with a
/// single indigo accent. Values come from the design handoff tokens.
abstract final class AppColors {
  // Core Ledger tokens
  static const bg = Color(0xFFF6F7F9);
  static const ink = Color(0xFF14161C);
  static const inkStrong = Color(0xFF1B1D24);
  static const muted = Color(0xFF8A8F9C);
  static const muted2 = Color(0xFF9AA0AB);
  static const hairline = Color(0xFFECEDF1);
  static const hairline2 = Color(0xFFF1F2F5);
  static const tabDivider = Color(0xFFE7E8EE);
  static const surface = Color(0xFFFFFFFF);
  static const fieldBg = Color(0xFFEDEEF2);
  static const accent = Color(0xFF4B53E8);
  static const accentSoft = Color(0x1A4B53E8); // rgba(75,83,232,0.10)
  static const accent300 = Color(0xFF8A8FF0);
  static const accent200 = Color(0xFFC3C6F7);
  static const accent100 = Color(0xFFE4E5FB);
  static const barTrack = Color(0xFFDDE0F4);
  static const barTrackAlt = Color(0xFFE1E3F5);
  static const barTrack2 = Color(0xFFEDEEF2);
  static const toggleOff = Color(0xFFE1E3EA);
  static const iconInactive = Color(0xFFB9BDC6);
  static const chevron = Color(0xFFC0C4CC);
  static const danger = Color(0xFFC4362F);
  static const footnote = Color(0xFFB0B5BE);

  /// Accent shades for category charts (segmented bar, progress rows).
  static const chartShades = [accent, accent300, accent200, accent100];

  /// Avatar gradient (settings profile card).
  static const avatarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accent300],
  );

  // Legacy aliases still referenced by screens outside the redesign
  // (onboarding, catalog). Point at the Ledger palette.
  static const primary = accent;
  static const primaryLight = accent300;
  static const primaryDark = Color(0xFF3A41C6);
  static const primaryBg = accent100;
  static const background = bg;
  static const border = hairline;
  static const textPrimary = ink;
  static const textSecondary = muted;
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // Dark mode surfaces (kept for the dark ThemeData; the Ledger handoff is
  // light-only, so these stay close to the previous dark palette).
  static const backgroundDark = Color(0xFF0F1119);
  static const surfaceDark = Color(0xFF1A1C26);
  static const borderDark = Color(0xFF2B2E3B);
  static const textPrimaryDark = Color(0xFFF3F4F6);
  static const textSecondaryDark = Color(0xFF9CA3AF);

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

  static const accentGradient = avatarGradient;
}
