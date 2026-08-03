import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../entities/book.dart';
import '../entities/book_format.dart';
import '../repositories/book_repository.dart';
import '../repositories/cover_extractor.dart';

/// Copia un ebook nello storage privato dell'app, ne estrae la copertina e
/// lo registra in libreria — sia scegliendolo dal selettore di file, sia
/// ricevendolo tramite condivisione da un'altra app.
class ImportBookUseCase {
  final BookRepository _repository;
  final CoverExtractor _coverExtractor;
  static const _uuid = Uuid();

  ImportBookUseCase(this._repository, this._coverExtractor);

  /// Restituisce `null` se l'utente annulla la selezione o il formato non è
  /// ancora supportato (solo EPUB e PDF in Fase 1). Se [shelfId] è passato,
  /// il libro viene assegnato subito a quella libreria.
  Future<Book?> call({String? shelfId}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf'],
    );
    final pickedPath = result?.files.single.path;
    if (pickedPath == null) return null;
    return importFromPath(pickedPath, shelfId: shelfId);
  }

  /// Importa un file già presente sul dispositivo, senza passare dal
  /// selettore. Se [mimeType] è noto viene preferito all'estensione per
  /// riconoscere il formato: i file ricevuti tramite condivisione arrivano
  /// copiati in una cache che spesso non mantiene l'estensione originale.
  Future<Book?> importFromPath(
    String sourcePath, {
    String? shelfId,
    String? mimeType,
  }) async {
    final format =
        BookFormat.fromMimeType(mimeType) ??
        BookFormat.fromExtension(p.extension(sourcePath));
    if (format == null) return null;

    final documentsDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(documentsDir.path, 'books'));
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }

    final id = _uuid.v4();
    final destinationPath = p.join(booksDir.path, '$id.${format.storageName}');
    await File(sourcePath).copy(destinationPath);

    final coverPath = await _coverExtractor.extract(
      bookId: id,
      sourceFilePath: destinationPath,
      format: format,
    );

    final book = Book(
      id: id,
      title: p.basenameWithoutExtension(sourcePath),
      format: format,
      filePath: destinationPath,
      coverPath: coverPath,
      shelfId: shelfId,
      addedAt: DateTime.now(),
    );
    await _repository.add(book);
    return book;
  }
}
