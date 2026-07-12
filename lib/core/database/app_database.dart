import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:subly/features/subscriptions/domain/models/billing_cycle.dart';
import 'package:subly/features/subscriptions/domain/models/subscription_category.dart';

import 'daos/subscriptions_dao.dart';
import 'tables/subscriptions_table.dart';

part 'app_database.g.dart';

/// Main database class for Subly app
@DriftDatabase(tables: [SubscriptionsTable], daos: [SubscriptionsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for testing with custom executor
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }
}

/// Opens a connection to the SQLite database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'subly.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
