import 'package:intl/intl.dart';

import '../services/exchange_rate_service.dart';

/// Currency conversion utilities
class CurrencyUtils {
  // Fallback exchange rates (EUR as base) - used when API is unavailable
  static const _fallbackRates = {
    'EUR': 1.0,
    'USD': 1.08,
  };

  // Cached rates from API
  static ExchangeRates? _cachedRates;

  /// Set the cached exchange rates (called from provider)
  static void setRates(ExchangeRates rates) {
    _cachedRates = rates;
  }

  /// Convert an amount from one currency to another
  static double convert(double amount, String from, String to) {
    if (from == to) return amount;

    // Use cached rates if available
    if (_cachedRates != null) {
      return _cachedRates!.convert(amount, from, to);
    }

    // Fallback to static rates
    final fromRate = _fallbackRates[from] ?? 1.0;
    final toRate = _fallbackRates[to] ?? 1.0;

    // Convert to EUR first, then to target currency
    final inEur = amount / fromRate;
    return inEur * toRate;
  }

  /// Get the currency symbol
  static String getSymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '\u20AC';
      case 'USD':
        return '\$';
      default:
        return currency;
    }
  }

  /// Format an amount with currency symbol
  static String format(double amount, String currency, {int decimals = 2}) {
    final symbol = getSymbol(currency);
    return '$symbol${amount.toStringAsFixed(decimals)}';
  }

  /// Format with thousands grouping, e.g. "€1,726.44".
  static String formatGrouped(
    double amount,
    String currency, {
    int decimals = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'en_IE',
      symbol: getSymbol(currency),
      decimalDigits: decimals,
    );
    return formatter.format(amount);
  }

  /// Convert and format an amount
  static String convertAndFormat(
    double amount,
    String fromCurrency,
    String toCurrency, {
    int decimals = 2,
  }) {
    final converted = convert(amount, fromCurrency, toCurrency);
    return format(converted, toCurrency, decimals: decimals);
  }
}
