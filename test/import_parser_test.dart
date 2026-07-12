import 'package:flutter_test/flutter_test.dart';
import 'package:subly/features/import/domain/import_parser.dart';
import 'package:subly/features/subscriptions/domain/models/billing_cycle.dart';
import 'package:subly/features/subscriptions/domain/models/subscription_category.dart';

void main() {
  group('CSV with headers', () {
    test('parses the app\'s own CSV export format (round trip)', () {
      const csv = 'Name,Price,Currency,Billing cycle,Category,Start date,Next charge,Status\n'
          'Netflix,17.99,EUR,Monthly,Streaming,2023-01-15,2026-07-12,Active\n'
          'Dropbox,11.99,USD,Yearly,Cloud Storage,2024-03-01,2026-09-01,Canceled\n';

      final result = parseSubscriptionImport(csv);

      expect(result.items, hasLength(2));
      expect(result.skippedLines, 0);

      final netflix = result.items[0];
      expect(netflix.name, 'Netflix');
      expect(netflix.price, 17.99);
      expect(netflix.currency, 'EUR');
      expect(netflix.cycle, BillingCycle.monthly);
      expect(netflix.category, SubscriptionCategory.streaming);
      expect(netflix.startDate, DateTime(2023, 1, 15));
      expect(netflix.nextBillingDate, DateTime(2026, 7, 12));
      expect(netflix.isActive, isTrue);

      final dropbox = result.items[1];
      expect(dropbox.currency, 'USD');
      expect(dropbox.cycle, BillingCycle.yearly);
      expect(dropbox.category, SubscriptionCategory.cloud);
      expect(dropbox.isActive, isFalse);
    });

    test('parses European Excel export: semicolons and decimal commas', () {
      const csv = 'Service;Kosten;Zyklus\n'
          'Netflix;17,99;monthly\n'
          'Spotify;10,99;monthly\n';
      // "Kosten" isn't a known header word, but "Service" is — header row
      // is detected and price falls back to heuristics per row.
      final result = parseSubscriptionImport(csv);

      expect(result.items, hasLength(2));
      expect(result.items[0].name, 'Netflix');
      expect(result.items[0].price, 17.99);
      expect(result.items[1].price, 10.99);
    });

    test('recognizes varied header names', () {
      const csv = 'Subscription,Amount,Frequency,Renewal date\n'
          'iCloud+,2.99,monthly,12/07/2026\n';
      final result = parseSubscriptionImport(csv);

      expect(result.items, hasLength(1));
      final item = result.items.first;
      expect(item.name, 'iCloud+');
      expect(item.price, 2.99);
      expect(item.cycle, BillingCycle.monthly);
      expect(item.nextBillingDate, DateTime(2026, 7, 12));
    });

    test('skips rows without a usable price', () {
      const csv = 'Name,Price\nNetflix,17.99\nBroken row,not-a-number\n';
      final result = parseSubscriptionImport(csv);

      expect(result.items, hasLength(1));
      expect(result.skippedLines, 1);
    });
  });

  group('headerless CSV', () {
    test('infers columns from content', () {
      const csv = 'Netflix,17.99,EUR,monthly\nFigma,12.00,USD,yearly\n';
      final result = parseSubscriptionImport(csv);

      expect(result.items, hasLength(2));
      expect(result.items[0].name, 'Netflix');
      expect(result.items[0].currency, 'EUR');
      expect(result.items[0].cycle, BillingCycle.monthly);
      expect(result.items[1].cycle, BillingCycle.yearly);
    });
  });

  group('free text', () {
    test('parses notes-style lines with bullets, dashes, and EU amounts', () {
      const text = '- Netflix – 17,99 € monthly\n'
          '• Spotify: 10.99\n'
          '* ChatGPT Plus 22 EUR / month\n'
          '\n'
          'just a random note without any numbers\n';
      final result = parseSubscriptionImport(text);

      expect(result.items, hasLength(3));
      expect(result.skippedLines, 1);

      expect(result.items[0].name, 'Netflix');
      expect(result.items[0].price, 17.99);
      expect(result.items[0].currency, 'EUR');
      expect(result.items[0].cycle, BillingCycle.monthly);

      expect(result.items[1].name, 'Spotify');
      expect(result.items[1].price, 10.99);

      expect(result.items[2].name, 'ChatGPT Plus');
      expect(result.items[2].price, 22);
      expect(result.items[2].currency, 'EUR');
    });

    test('detects yearly cycle and dollar amounts', () {
      const text = 'Amazon Prime \$139 per year';
      final result = parseSubscriptionImport(text);

      expect(result.items, hasLength(1));
      expect(result.items.first.name, 'Amazon Prime');
      expect(result.items.first.price, 139);
      expect(result.items.first.currency, 'USD');
      expect(result.items.first.cycle, BillingCycle.yearly);
    });

    test('single free-text line is not mistaken for CSV', () {
      const text = 'Netflix, Spotify and iCloud cost me 31,97 monthly';
      final result = parseSubscriptionImport(text);

      expect(result.items, hasLength(1));
      expect(result.items.first.price, 31.97);
    });
  });

  group('amount formats', () {
    double priceOf(String line) =>
        parseSubscriptionImport('Service X $line').items.single.price;

    test('handles thousands and decimal separator combinations', () {
      expect(priceOf('1,299.00'), 1299.00);
      expect(priceOf('1.299,00'), 1299.00);
      expect(priceOf('9,99'), 9.99);
      expect(priceOf('9.99'), 9.99);
      expect(priceOf('12'), 12);
    });
  });

  test('empty input produces empty result', () {
    final result = parseSubscriptionImport('   \n  \n');
    expect(result.items, isEmpty);
    expect(result.skippedLines, 0);
  });
}
