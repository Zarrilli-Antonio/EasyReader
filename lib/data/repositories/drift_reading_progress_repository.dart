import 'package:drift/drift.dart';

import '../../domain/entities/reading_progress.dart';
import '../../domain/repositories/reading_progress_repository.dart';
import '../local/database/app_database.dart';

class DriftReadingProgressRepository implements ReadingProgressRepository {
  final AppDatabase _db;
  DriftReadingProgressRepository(this._db);

  @override
  Stream<ReadingProgress?> watch(String bookId) {
    final query = _db.select(_db.readingProgressEntries)
      ..where((t) => t.bookId.equals(bookId));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toEntity(row),
    );
  }

  @override
  Future<void> save(ReadingProgress progress) {
    return _db
        .into(_db.readingProgressEntries)
        .insertOnConflictUpdate(
          ReadingProgressEntriesCompanion.insert(
            bookId: progress.bookId,
            position: progress.position,
            percentage: Value(progress.percentage),
            totalUnits: Value(progress.totalUnits),
            updatedAt: progress.updatedAt,
          ),
        );
  }

  @override
  Future<void> deleteFor(String bookId) {
    return (_db.delete(
      _db.readingProgressEntries,
    )..where((t) => t.bookId.equals(bookId))).go();
  }

  ReadingProgress _toEntity(ReadingProgressRow row) => ReadingProgress(
    bookId: row.bookId,
    position: row.position,
    percentage: row.percentage,
    totalUnits: row.totalUnits,
    updatedAt: row.updatedAt,
  );
}
