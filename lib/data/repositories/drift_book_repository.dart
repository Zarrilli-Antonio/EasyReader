import 'package:drift/drift.dart';

import '../../domain/entities/book.dart';
import '../../domain/entities/book_format.dart';
import '../../domain/repositories/book_repository.dart';
import '../local/database/app_database.dart';

class DriftBookRepository implements BookRepository {
  final AppDatabase _db;
  DriftBookRepository(this._db);

  @override
  Stream<List<Book>> watchAll() {
    final query = _db.select(_db.books)
      ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<void> add(Book book) {
    return _db
        .into(_db.books)
        .insert(
          BooksCompanion.insert(
            id: book.id,
            title: book.title,
            format: book.format.storageName,
            filePath: book.filePath,
            coverPath: Value(book.coverPath),
            shelfId: Value(book.shelfId),
            addedAt: book.addedAt,
            lastOpenedAt: Value(book.lastOpenedAt),
          ),
        );
  }

  @override
  Future<void> markOpened(String bookId, DateTime openedAt) {
    return (_db.update(_db.books)..where((t) => t.id.equals(bookId))).write(
      BooksCompanion(lastOpenedAt: Value(openedAt)),
    );
  }

  @override
  Future<void> rename(String bookId, String newTitle) {
    return (_db.update(_db.books)..where((t) => t.id.equals(bookId))).write(
      BooksCompanion(title: Value(newTitle)),
    );
  }

  @override
  Future<void> assignShelf(String bookId, String? shelfId) {
    return (_db.update(_db.books)..where((t) => t.id.equals(bookId))).write(
      BooksCompanion(shelfId: Value(shelfId)),
    );
  }

  @override
  Future<void> clearShelf(String shelfId) {
    return (_db.update(_db.books)..where((t) => t.shelfId.equals(shelfId)))
        .write(const BooksCompanion(shelfId: Value(null)));
  }

  @override
  Future<void> delete(String bookId) {
    return (_db.delete(_db.books)..where((t) => t.id.equals(bookId))).go();
  }

  Book _toEntity(BookRow row) => Book(
    id: row.id,
    title: row.title,
    format: BookFormat.fromStorageName(row.format),
    filePath: row.filePath,
    coverPath: row.coverPath,
    shelfId: row.shelfId,
    addedAt: row.addedAt,
    lastOpenedAt: row.lastOpenedAt,
  );
}
