import 'dart:convert';

import 'package:http/http.dart' as http;

/// Service for fetching exchange rates from Frankfurter API
/// Uses European Central Bank data, updated daily
class ExchangeRateService {
  static const _baseUrl = 'https://api.frankfurter.dev/v1';

  final http.Client _client;

  ExchangeRateService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches latest exchange rates with EUR as base
  /// Returns a map of currency codes to their rates relative to EUR
  Future<ExchangeRates> fetchLatestRates() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/latest?base=EUR&symbols=USD'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final rates = (data['rates'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );

        // Add EUR as base rate
        rates['EUR'] = 1.0;

        return ExchangeRates(
          rates: rates,
          date: DateTime.parse(data['date'] as String),
          baseCurrency: 'EUR',
        );
      } else {
        throw ExchangeRateException(
          'Failed to fetch rates: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ExchangeRateException) rethrow;
      throw ExchangeRateException('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Exchange rates data
class ExchangeRates {
  final Map<String, double> rates;
  final DateTime date;
  final String baseCurrency;

  const ExchangeRates({
    required this.rates,
    required this.date,
    required this.baseCurrency,
  });

  /// Convert an amount from one currency to another
  double convert(double amount, String from, String to) {
    if (from == to) return amount;

    final fromRate = rates[from];
    final toRate = rates[to];

    if (fromRate == null || toRate == null) {
      // Fallback to no conversion if rates not available
      return amount;
    }

    // Convert to base currency (EUR), then to target
    final inBase = amount / fromRate;
    return inBase * toRate;
  }

  /// Get the rate for a currency relative to EUR
  double? getRate(String currency) => rates[currency];

  /// Fallback rates for when API is unavailable
  static ExchangeRates fallback() {
    return ExchangeRates(
      rates: const {
        'EUR': 1.0,
        'USD': 1.08,
      },
      date: DateTime.now(),
      baseCurrency: 'EUR',
    );
  }
}

/// Exception for exchange rate errors
class ExchangeRateException implements Exception {
  final String message;

  const ExchangeRateException(this.message);

  @override
  String toString() => 'ExchangeRateException: $message';
}
