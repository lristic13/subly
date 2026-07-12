import 'package:flutter_test/flutter_test.dart';
import 'package:subly/core/services/exchange_rate_service.dart';
import 'package:subly/core/utils/currency_utils.dart';

void main() {
  test('same-currency conversion is identity', () {
    expect(CurrencyUtils.convert(9.99, 'EUR', 'EUR'), 9.99);
  });

  test('falls back to static rates when no API rates are cached', () {
    // Runs before the setRates test below — the static cache is shared.
    expect(CurrencyUtils.convert(10, 'EUR', 'USD'), closeTo(10.8, 0.001));
    expect(CurrencyUtils.convert(10.8, 'USD', 'EUR'), closeTo(10.0, 0.001));
  });

  test('getSymbol', () {
    expect(CurrencyUtils.getSymbol('EUR'), '€');
    expect(CurrencyUtils.getSymbol('USD'), '\$');
    expect(CurrencyUtils.getSymbol('GBP'), 'GBP');
  });

  test('formatGrouped adds thousands separators', () {
    expect(CurrencyUtils.formatGrouped(1726.44, 'EUR'), '€1,726.44');
    expect(CurrencyUtils.formatGrouped(9.99, 'EUR'), '€9.99');
    expect(CurrencyUtils.formatGrouped(1234567.5, 'USD'), '\$1,234,567.50');
  });

  test('uses cached API rates once set', () {
    CurrencyUtils.setRates(ExchangeRates(
      rates: const {'EUR': 1.0, 'USD': 2.0},
      date: DateTime(2026, 7, 12),
      baseCurrency: 'EUR',
    ));
    expect(CurrencyUtils.convert(10, 'EUR', 'USD'), 20);
  });
}
