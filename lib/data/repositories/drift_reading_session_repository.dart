import '../../domain/entities/reading_session.dart';
import '../../domain/repositories/reading_session_repository.dart';
import '../local/database/app_database.dart';

class DriftReadingSessionRepository implements ReadingSessionRepository {
  final AppDatabase _db;
  DriftReadingSessionRepository(this._db);

  @override
  Future<void> record(ReadingSession session) {
    return _db
        .into(_db.readingSessions)
        .insert(
          ReadingSessionsCompanion.insert(
            id: session.id,
            bookId: session.bookId,
            startedAt: session.startedAt,
            endedAt: session.endedAt,
          ),
        );
  }

  @override
  Stream<List<ReadingSession>> watchForBook(String bookId) {
    final query = _db.select(_db.readingSessions)
      ..where((t) => t.bookId.equals(bookId));
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<List<ReadingSession>> watchAll() {
    return _db
        .select(_db.readingSessions)
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<void> deleteForBook(String bookId) {
    return (_db.delete(
      _db.readingSessions,
    )..where((t) => t.bookId.equals(bookId))).go();
  }

  ReadingSession _toEntity(ReadingSessionRow row) => ReadingSession(
    id: row.id,
    bookId: row.bookId,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
  );
}
