import '../entities/book_format.dart';

abstract class CoverExtractor {
  /// Ritorna il percorso locale dell'immagine di copertina estratta, o
  /// `null` se il file non ne ha una riconoscibile.
  Future<String?> extract({
    required String bookId,
    required String sourceFilePath,
    required BookFormat format,
  });
}
