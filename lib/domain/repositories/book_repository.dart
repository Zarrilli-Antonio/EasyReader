import '../entities/book.dart';

abstract class BookRepository {
  Stream<List<Book>> watchAll();
  Future<void> add(Book book);
  Future<void> markOpened(String bookId, DateTime openedAt);
  Future<void> rename(String bookId, String newTitle);

  /// Passare `null` per rimuovere il libro da qualunque libreria.
  Future<void> assignShelf(String bookId, String? shelfId);

  /// Rimuove tutti i libri da [shelfId] (usato prima di eliminare la libreria).
  Future<void> clearShelf(String shelfId);
  Future<void> delete(String bookId);
}
