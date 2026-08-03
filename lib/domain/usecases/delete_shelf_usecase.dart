import '../repositories/book_repository.dart';
import '../repositories/shelf_repository.dart';

/// Elimina una libreria senza toccare i libri al suo interno: li scollega
/// (tornano "senza libreria") e poi rimuove la libreria stessa.
class DeleteShelfUseCase {
  final ShelfRepository _shelfRepository;
  final BookRepository _bookRepository;

  DeleteShelfUseCase(this._shelfRepository, this._bookRepository);

  Future<void> call(String shelfId) async {
    await _bookRepository.clearShelf(shelfId);
    await _shelfRepository.delete(shelfId);
  }
}
