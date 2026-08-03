import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('BookRow')
class Books extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get format => text()();
  TextColumn get filePath => text()();
  TextColumn get coverPath => text().nullable()();
  TextColumn get shelfId => text().nullable().references(Shelves, #id)();
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FilterProfileRow')
class FilterProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get backgroundColor => integer()();
  IntColumn get overlayColor => integer()();
  RealColumn get overlayOpacity => real().withDefault(const Constant(0))();
  RealColumn get brightness => real().withDefault(const Constant(0))();
  RealColumn get fontSize => real().withDefault(const Constant(16))();
  BoolColumn get paperFilterEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReadingProgressRow')
class ReadingProgressEntries extends Table {
  TextColumn get bookId => text().references(Books, #id)();
  TextColumn get position => text()();
  RealColumn get percentage => real().withDefault(const Constant(0))();
  IntColumn get totalUnits => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {bookId};
}

@DataClassName('ShelfRow')
class Shelves extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  TextColumn get icon => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReadingSessionRow')
class ReadingSessions extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(Books, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Books,
    FilterProfiles,
    ReadingProgressEntries,
    Shelves,
    ReadingSessions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'easy_reader_db'));
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(filterProfiles, filterProfiles.paperFilterEnabled);
      }
      if (from < 3) {
        await m.addColumn(books, books.coverPath);
      }
      if (from < 4) {
        await m.createTable(shelves);
        await m.addColumn(books, books.shelfId);
      }
      if (from < 5) {
        await m.addColumn(
          readingProgressEntries,
          readingProgressEntries.totalUnits,
        );
      }
      if (from < 6) {
        await m.createTable(readingSessions);
      }
    },
  );
}
