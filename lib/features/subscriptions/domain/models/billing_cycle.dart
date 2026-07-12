/// Billing cycle options for subscriptions
enum BillingCycle {
  weekly,
  monthly,
  yearly;

  /// Display name for the billing cycle
  String get displayName => switch (this) {
        weekly => 'Weekly',
        monthly => 'Monthly',
        yearly => 'Yearly',
      };

  /// Short label (e.g., for tags)
  String get shortLabel => switch (this) {
        weekly => '/wk',
        monthly => '/mo',
        yearly => '/yr',
      };

  /// Normalize any subscription cost to monthly
  double toMonthly(double price) => switch (this) {
        weekly => price * 4.33,
        monthly => price,
        yearly => price / 12,
      };

  /// Normalize any subscription cost to yearly
  double toYearly(double price) => switch (this) {
        weekly => price * 52,
        monthly => price * 12,
        yearly => price,
      };

  /// Get the number of days in the billing cycle (approximate)
  int get daysInCycle => switch (this) {
        weekly => 7,
        monthly => 30,
        yearly => 365,
      };

  /// Calculate the next billing date from a given date
  DateTime nextBillingDate(DateTime from) => switch (this) {
        weekly => from.add(const Duration(days: 7)),
        monthly => DateTime(
            from.year,
            from.month + 1,
            from.day > 28 ? _lastDayOfMonth(from.year, from.month + 1) : from.day,
          ),
        yearly => DateTime(from.year + 1, from.month, from.day),
      };

  /// Get the last day of a given month
  static int _lastDayOfMonth(int year, int month) {
    // Normalize month if it exceeds 12
    if (month > 12) {
      year += (month - 1) ~/ 12;
      month = ((month - 1) % 12) + 1;
    }
    return DateTime(year, month + 1, 0).day;
  }
}
