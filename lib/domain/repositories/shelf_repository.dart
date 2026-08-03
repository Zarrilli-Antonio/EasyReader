import '../entities/shelf.dart';

abstract class ShelfRepository {
  Stream<List<Shelf>> watchAll();
  Future<void> add(Shelf shelf);
  Future<void> update(Shelf shelf);
  Future<void> delete(String shelfId);
}
