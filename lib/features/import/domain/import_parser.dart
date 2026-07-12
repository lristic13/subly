import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../subscriptions/domain/models/billing_cycle.dart';
import '../../subscriptions/domain/models/subscription_category.dart';

/// A subscription candidate parsed from user-provided text or CSV.
class ImportedSubscription {
  const ImportedSubscription({
    required this.name,
    required this.price,
    this.currency,
    this.cycle,
    this.category,
    this.startDate,
    this.nextBillingDate,
    this.isActive = true,
  });

  final String name;
  final double price;

  /// Null when the source didn't specify one — caller applies its default.
  final String? currency;
  final BillingCycle? cycle;
  final SubscriptionCategory? category;
  final DateTime? startDate;
  final DateTime? nextBillingDate;
  final bool isActive;
}

class ImportParseResult {
  const ImportParseResult({required this.items, required this.skippedLines});

  final List<ImportedSubscription> items;

  /// Non-empty lines that couldn't be understood.
  final int skippedLines;
}

/// Parses pasted text or file contents into subscription candidates.
/// Detects CSV input (Excel/Numbers/Sheets exports, including European
/// semicolon-delimited files) and falls back to line-by-line free text
/// ("Netflix – 17,99 € monthly") for notes-style input.
ImportParseResult parseSubscriptionImport(String raw) {
  final text = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();
  if (text.isEmpty) return const ImportParseResult(items: [], skippedLines: 0);

  final delimiter = _detectCsvDelimiter(text);
  if (delimiter != null) {
    return _parseCsv(text, delimiter);
  }
  return _parseFreeText(text);
}

// ── CSV ────────────────────────────────────────────────────────────

/// A delimiter qualifies when most non-empty lines contain it.
String? _detectCsvDelimiter(String text) {
  final lines =
      text.split('\n').where((l) => l.trim().isNotEmpty).take(20).toList();
  if (lines.isEmpty) return null;

  for (final delimiter in const ['\t', ';', ',']) {
    final withDelimiter =
        lines.where((l) => l.contains(delimiter)).length;
    if (withDelimiter >= lines.length * 0.8 && withDelimiter >= 1) {
      // A single free-text line with one comma is not a CSV; neither is a
      // line whose comma sits inside a number ("1,299.00").
      if (lines.length == 1 && delimiter == ',') {
        if (RegExp(r'\d,\d').hasMatch(lines.first)) continue;
        final cells = lines.first.split(',');
        if (cells.length < 2 || _parseAmount(cells[1]) == null) continue;
      }
      return delimiter;
    }
  }
  return null;
}

ImportParseResult _parseCsv(String text, String delimiter) {
  final rows = CsvDecoder(fieldDelimiter: delimiter).convert(text);

  if (rows.isEmpty) return const ImportParseResult(items: [], skippedLines: 0);

  final firstRow = [for (final c in rows.first) c.toString().trim()];
  final columns = _mapHeaderColumns(firstRow);
  final dataRows = columns != null ? rows.skip(1) : rows;

  final items = <ImportedSubscription>[];
  var skipped = 0;

  for (final row in dataRows) {
    final cells = [for (final c in row) c.toString().trim()];
    if (cells.every((c) => c.isEmpty)) continue;

    final item = columns != null
        ? _rowFromMappedColumns(cells, columns)
        : _rowFromHeuristics(cells);
    if (item != null) {
      items.add(item);
    } else {
      skipped++;
    }
  }
  return ImportParseResult(items: items, skippedLines: skipped);
}

class _ColumnMap {
  int? name, price, currency, cycle, category, startDate, nextDate, status;

  int get matchCount => [
        name, price, currency, cycle, category, startDate, nextDate, status,
      ].where((i) => i != null).length;
}

_ColumnMap? _mapHeaderColumns(List<String> header) {
  final map = _ColumnMap();
  for (var i = 0; i < header.length; i++) {
    final cell = header[i].toLowerCase();
    if (cell.isEmpty) continue;
    if (map.name == null &&
        RegExp(r'\b(name|service|subscription|app|title)\b').hasMatch(cell)) {
      map.name = i;
    } else if (map.price == null &&
        RegExp(r'\b(price|amount|cost|fee)\b').hasMatch(cell)) {
      map.price = i;
    } else if (map.currency == null && cell.contains('currenc')) {
      map.currency = i;
    } else if (map.cycle == null &&
        RegExp(r'\b(cycle|billing|frequency|period|interval)\b')
            .hasMatch(cell)) {
      map.cycle = i;
    } else if (map.category == null &&
        RegExp(r'\b(category|type|group)\b').hasMatch(cell)) {
      map.category = i;
    } else if (map.startDate == null &&
        RegExp(r'\b(start|since|first)\b').hasMatch(cell)) {
      map.startDate = i;
    } else if (map.nextDate == null &&
        RegExp(r'\b(next|renew\w*|due|charge|payment)\b').hasMatch(cell)) {
      map.nextDate = i;
    } else if (map.status == null &&
        RegExp(r'\b(status|active)\b').hasMatch(cell)) {
      map.status = i;
    }
  }
  // Require at least a recognizable name or price column to trust the
  // header, and reject rows carrying amounts — those are data, not headers.
  if (map.name == null && map.price == null) return null;
  if (header.any((cell) => _parseAmount(cell) != null)) return null;
  return map;
}

String? _cellAt(List<String> cells, int? index) =>
    index != null && index < cells.length && cells[index].isNotEmpty
        ? cells[index]
        : null;

ImportedSubscription? _rowFromMappedColumns(
  List<String> cells,
  _ColumnMap columns,
) {
  final name = _cellAt(cells, columns.name);
  var price = _parseAmount(_cellAt(cells, columns.price) ?? '');
  var currency = _parseCurrency(_cellAt(cells, columns.currency) ?? '') ??
      _parseCurrency(_cellAt(cells, columns.price) ?? '');
  var cycle = _parseCycle(_cellAt(cells, columns.cycle) ?? '');

  // Header rows in unrecognized languages ("Kosten", "Zyklus") map only some
  // columns — fill the gaps from the leftover cells' content.
  final mappedIndices = {
    columns.name, columns.price, columns.currency, columns.cycle,
    columns.category, columns.startDate, columns.nextDate, columns.status,
  };
  for (var i = 0; i < cells.length; i++) {
    if (mappedIndices.contains(i) || cells[i].isEmpty) continue;
    price ??= _parseAmount(cells[i]);
    if (_isOnlyCycle(cells[i])) cycle ??= _parseCycle(cells[i]);
    if (cells[i].length <= 4) currency ??= _parseCurrency(cells[i]);
  }

  if (name == null || price == null || price <= 0) return null;

  final statusCell = _cellAt(cells, columns.status)?.toLowerCase();
  return ImportedSubscription(
    name: name,
    price: price,
    currency: currency,
    cycle: cycle,
    category: _parseCategory(_cellAt(cells, columns.category) ?? ''),
    startDate: _parseDate(_cellAt(cells, columns.startDate) ?? ''),
    nextBillingDate: _parseDate(_cellAt(cells, columns.nextDate) ?? ''),
    isActive: statusCell == null ||
        !RegExp(r'cancell?ed|inactive|expired|no\b').hasMatch(statusCell),
  );
}

/// Headerless CSV: infer each cell's meaning from its content.
ImportedSubscription? _rowFromHeuristics(List<String> cells) {
  String? name;
  double? price;
  String? currency;
  BillingCycle? cycle;
  SubscriptionCategory? category;
  DateTime? date;

  for (final cell in cells) {
    if (cell.isEmpty) continue;
    final asDate = _parseDate(cell);
    if (asDate != null) {
      date ??= asDate;
      continue;
    }
    final asCycle = _parseCycle(cell);
    if (asCycle != null && _isOnlyCycle(cell)) {
      cycle ??= asCycle;
      continue;
    }
    final asAmount = _parseAmount(cell);
    if (asAmount != null && price == null) {
      price = asAmount;
      currency ??= _parseCurrency(cell);
      continue;
    }
    final asCurrency = _parseCurrency(cell);
    if (asCurrency != null && cell.length <= 4) {
      currency ??= asCurrency;
      continue;
    }
    final asCategory = _parseCategory(cell);
    if (asCategory != null && name != null) {
      category ??= asCategory;
      continue;
    }
    name ??= cell;
  }

  if (name == null || price == null || price <= 0) return null;
  return ImportedSubscription(
    name: name,
    price: price,
    currency: currency,
    cycle: cycle,
    category: category,
    nextBillingDate:
        date != null && date.isAfter(DateTime.now()) ? date : null,
    startDate: date != null && !date.isAfter(DateTime.now()) ? date : null,
  );
}

// ── Free text ──────────────────────────────────────────────────────

final _amountPattern = RegExp(
  r'([€$])?\s*(\d{1,3}(?:[.,]\d{3})+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?)\s*(€|\$|eur|usd)?',
  caseSensitive: false,
);

ImportParseResult _parseFreeText(String text) {
  final items = <ImportedSubscription>[];
  var skipped = 0;

  for (var line in text.split('\n')) {
    line = line.trim().replaceFirst(RegExp(r'^[-–—•*·]+\s*'), '');
    if (line.isEmpty) continue;

    // Pick the amount token that carries a currency marker or decimals;
    // otherwise fall back to the last bare number in the line.
    RegExpMatch? best;
    for (final match in _amountPattern.allMatches(line)) {
      final hasCurrency = match.group(1) != null || match.group(3) != null;
      final hasDecimals = RegExp(r'[.,]\d{1,2}$').hasMatch(match.group(2)!);
      if (hasCurrency || hasDecimals) {
        best = match;
        break;
      }
      best = match;
    }

    final price = best != null ? _parseAmount(best.group(2)!) : null;
    if (best == null || price == null || price <= 0) {
      skipped++;
      continue;
    }

    var name = line.replaceRange(best.start, best.end, ' ');
    name = name
        .replaceAll(_cyclePattern, ' ')
        .replaceAll(RegExp(r'\b(eur|usd|per|for|at)\b', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'[€$/]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceAll(RegExp(r'^[-–—:,.]+|[-–—:,.]+$'), '')
        .trim();

    if (name.isEmpty) {
      skipped++;
      continue;
    }

    final currencyMarker = best.group(1) ?? best.group(3) ?? '';
    items.add(ImportedSubscription(
      name: name,
      price: price,
      currency: _parseCurrency('$currencyMarker $line'),
      cycle: _parseCycle(line),
      category: null,
    ));
  }
  return ImportParseResult(items: items, skippedLines: skipped);
}

// ── Field parsers ──────────────────────────────────────────────────

/// Handles "9.99", "9,99", "1,299.00", "1.299,00", "€ 12", "12 EUR".
double? _parseAmount(String input) {
  var s = input
      .replaceAll(RegExp(r'[€$]|eur|usd', caseSensitive: false), '')
      .replaceAll(' ', '')
      .trim();
  if (s.isEmpty || !RegExp(r'^\d[\d.,]*$').hasMatch(s)) return null;

  final lastComma = s.lastIndexOf(',');
  final lastDot = s.lastIndexOf('.');
  if (lastComma >= 0 && lastDot >= 0) {
    // Both present: the later one is the decimal separator.
    if (lastComma > lastDot) {
      s = s.replaceAll('.', '').replaceAll(',', '.');
    } else {
      s = s.replaceAll(',', '');
    }
  } else if (lastComma >= 0) {
    final digitsAfter = s.length - lastComma - 1;
    s = digitsAfter <= 2 && s.indexOf(',') == lastComma
        ? s.replaceAll(',', '.')
        : s.replaceAll(',', '');
  } else if (lastDot >= 0) {
    final digitsAfter = s.length - lastDot - 1;
    if (digitsAfter == 3 || s.indexOf('.') != lastDot) {
      s = s.replaceAll('.', ''); // thousands separator ("1.299")
    }
  }
  final parsed = double.tryParse(s);
  // Round to whole cents so float noise never enters the database.
  return parsed == null ? null : (parsed * 100).round() / 100;
}

String? _parseCurrency(String input) {
  final s = input.toLowerCase();
  if (s.contains('€') || s.contains('eur')) return 'EUR';
  if (s.contains(r'$') || s.contains('usd')) return 'USD';
  return null;
}

final _cyclePattern = RegExp(
  r'\b(per\s+month|monthly|month|mo\.?|per\s+year|yearly|annually?|annual|year|yr\.?|per\s+week|weekly|week|wk\.?)\b',
  caseSensitive: false,
);

BillingCycle? _parseCycle(String input) {
  final match = _cyclePattern.firstMatch(input.toLowerCase());
  if (match == null) return null;
  final word = match.group(1)!;
  if (word.contains('year') || word.contains('annual') || word.startsWith('yr')) {
    return BillingCycle.yearly;
  }
  if (word.contains('week') || word.startsWith('wk')) return BillingCycle.weekly;
  return BillingCycle.monthly;
}

const _categorySynonyms = <String, SubscriptionCategory>{
  'entertainment': SubscriptionCategory.streaming,
  'tv': SubscriptionCategory.streaming,
  'video': SubscriptionCategory.streaming,
  'storage': SubscriptionCategory.cloud,
  'tools': SubscriptionCategory.software,
  'utilities': SubscriptionCategory.software,
  'health': SubscriptionCategory.fitness,
  'security': SubscriptionCategory.vpn,
};

SubscriptionCategory? _parseCategory(String input) {
  final s = input.toLowerCase().trim();
  if (s.isEmpty) return null;
  for (final category in SubscriptionCategory.values) {
    if (s == category.name || s == category.displayName.toLowerCase()) {
      return category;
    }
  }
  for (final entry in _categorySynonyms.entries) {
    if (s.contains(entry.key)) return entry.value;
  }
  // Partial match against multi-word display names ("Cloud Storage").
  for (final category in SubscriptionCategory.values) {
    if (category.displayName.toLowerCase().contains(s)) return category;
  }
  return null;
}

bool _isOnlyCycle(String cell) =>
    cell.trim().replaceFirst(_cyclePattern, '').trim().isEmpty;

DateTime? _parseDate(String input) {
  final s = input.trim();
  if (s.isEmpty || _parseAmount(s) != null && !s.contains(RegExp(r'[./-]'))) {
    return null;
  }

  final iso = DateTime.tryParse(s);
  if (iso != null) return iso;

  // Numeric formats; day-first (EU) unless the first number can't be a day.
  final numeric =
      RegExp(r'^(\d{1,2})[./-](\d{1,2})[./-](\d{2,4})$').firstMatch(s);
  if (numeric != null) {
    var first = int.parse(numeric.group(1)!);
    var second = int.parse(numeric.group(2)!);
    var year = int.parse(numeric.group(3)!);
    if (year < 100) year += 2000;
    final dayFirst = first > 12 || second <= 12;
    final day = dayFirst ? first : second;
    final month = dayFirst ? second : first;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    return DateTime(year, month, day);
  }

  for (final format in ['MMM d, yyyy', 'd MMM yyyy', 'MMMM d, yyyy', 'MMM yyyy']) {
    try {
      return DateFormat(format).parseLoose(s);
    } catch (_) {
      // try next format
    }
  }
  return null;
}
