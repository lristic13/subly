import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

/// App settings model
class AppSettings {
  final String currency;
  final ThemeMode themeMode;
  final bool renewalReminders;
  final bool priceChangeAlerts;
  final bool weeklySummary;

  /// Monthly budget in the display currency; null when not set.
  final double? monthlyBudget;

  const AppSettings({
    this.currency = 'EUR',
    this.themeMode = ThemeMode.system,
    this.renewalReminders = true,
    this.priceChangeAlerts = true,
    this.weeklySummary = false,
    this.monthlyBudget,
  });

  AppSettings copyWith({
    String? currency,
    ThemeMode? themeMode,
    bool? renewalReminders,
    bool? priceChangeAlerts,
    bool? weeklySummary,
    double? monthlyBudget,
    bool clearMonthlyBudget = false,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      renewalReminders: renewalReminders ?? this.renewalReminders,
      priceChangeAlerts: priceChangeAlerts ?? this.priceChangeAlerts,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      monthlyBudget:
          clearMonthlyBudget ? null : (monthlyBudget ?? this.monthlyBudget),
    );
  }
}

const _currencyKey = 'currency';
const _themeModeKey = 'themeMode';
const _renewalRemindersKey = 'renewalReminders';
const _priceChangeAlertsKey = 'priceChangeAlerts';
const _weeklySummaryKey = 'weeklySummary';
const _monthlyBudgetKey = 'monthlyBudget';

/// Provides app settings with persistence
@riverpod
class Settings extends _$Settings {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      currency: prefs.getString(_currencyKey) ?? 'EUR',
      themeMode: ThemeMode
          .values[prefs.getInt(_themeModeKey) ?? ThemeMode.system.index],
      renewalReminders: prefs.getBool(_renewalRemindersKey) ?? true,
      priceChangeAlerts: prefs.getBool(_priceChangeAlertsKey) ?? true,
      weeklySummary: prefs.getBool(_weeklySummaryKey) ?? false,
      monthlyBudget: prefs.getDouble(_monthlyBudgetKey),
    );
  }

  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
    state = AsyncData(state.value!.copyWith(currency: currency));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    state = AsyncData(state.value!.copyWith(themeMode: mode));
  }

  Future<void> setRenewalReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_renewalRemindersKey, enabled);
    state = AsyncData(state.value!.copyWith(renewalReminders: enabled));
  }

  Future<void> setPriceChangeAlerts(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_priceChangeAlertsKey, enabled);
    state = AsyncData(state.value!.copyWith(priceChangeAlerts: enabled));
  }

  Future<void> setWeeklySummary(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_weeklySummaryKey, enabled);
    state = AsyncData(state.value!.copyWith(weeklySummary: enabled));
  }

  Future<void> setMonthlyBudget(double? budget) async {
    final prefs = await SharedPreferences.getInstance();
    if (budget == null) {
      await prefs.remove(_monthlyBudgetKey);
      state = AsyncData(state.value!.copyWith(clearMonthlyBudget: true));
    } else {
      await prefs.setDouble(_monthlyBudgetKey, budget);
      state = AsyncData(state.value!.copyWith(monthlyBudget: budget));
    }
  }
}
