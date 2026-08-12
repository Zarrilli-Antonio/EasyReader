import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/import/mobi_converter.dart';
import '../entities/book.dart';
import '../entities/book_format.dart';
import '../repositories/book_repository.dart';
import '../repositories/cover_extractor.dart';

const _mobiExtensions = {'mobi', 'azw', 'azw3', 'azw4', 'prc'};
const _mobiMimeTypes = {
  'application/x-mobipocket-ebook',
  'application/vnd.amazon.ebook',
};

/// Copia un ebook nello storage privato dell'app, ne estrae la copertina e
/// lo registra in libreria — sia scegliendolo dal selettore di file, sia
/// ricevendolo tramite condivisione da un'altra app.
class ImportBookUseCase {
  final BookRepository _repository;
  final CoverExtractor _coverExtractor;
  final MobiConverter _mobiConverter = MobiConverter();
  static const _uuid = Uuid();

  ImportBookUseCase(this._repository, this._coverExtractor);

  /// Restituisce `null` se l'utente annulla la selezione o il formato non è
  /// riconosciuto. Se [shelfId] è passato, il libro viene assegnato subito a
  /// quella libreria.
  Future<Book?> call({String? shelfId}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'epub',
        'pdf',
        'cbz',
        // Il pacchetto per l'estrazione RAR non supporta Windows.
        if (!Platform.isWindows) 'cbr',
        'mobi',
        'azw',
        'azw3',
        'azw4',
        'prc',
      ],
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
    final sourceExtension = p
        .extension(sourcePath)
        .toLowerCase()
        .replaceFirst('.', '');
    // MOBI/AZW3 vengono convertiti a EPUB già in importazione: da qui in
    // avanti il libro è trattato come un EPUB qualunque, nessuna logica
    // specifica altrove nell'app. Controlla anche il MIME type perché i file
    // condivisi da altre app arrivano spesso senza l'estensione originale.
    final isMobiLike =
        _mobiExtensions.contains(sourceExtension) ||
        _mobiMimeTypes.contains(mimeType);
    final format = isMobiLike
        ? BookFormat.epub
        : BookFormat.fromMimeType(mimeType) ??
              BookFormat.fromExtension(sourceExtension);
    if (format == null) return null;

    final documentsDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(documentsDir.path, 'books'));
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }

    final id = _uuid.v4();
    final destinationPath = p.join(booksDir.path, '$id.${format.storageName}');
    if (isMobiLike) {
      await _mobiConverter.convertToEpub(File(sourcePath), destinationPath);
    } else {
      await File(sourcePath).copy(destinationPath);
    }

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
