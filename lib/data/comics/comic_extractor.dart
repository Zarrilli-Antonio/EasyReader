import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rar/rar.dart';

import '../../domain/entities/book_format.dart';

const _imageExtensions = {'.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'};

/// Estrae le pagine (immagini) di un fumetto CBZ/CBR in una cartella privata
/// dell'app, una sola volta per libro: le letture successive riusano i file
/// già estratti invece di decomprimere di nuovo l'intero archivio.
class ComicExtractor {
  Future<List<File>> extractPages({
    required String bookId,
    required String archivePath,
    required BookFormat format,
  }) async {
    final pagesDir = await _pagesDirFor(bookId);
    final alreadyExtracted =
        await pagesDir.exists() && await pagesDir.list().any((_) => true);
    if (!alreadyExtracted) {
      await pagesDir.create(recursive: true);
      switch (format) {
        case BookFormat.cbz:
          await _extractCbz(archivePath, pagesDir.path);
        case BookFormat.cbr:
          // Il pacchetto `rar` non supporta Windows (solo Android/iOS/macOS/web).
          if (Platform.isWindows) {
            throw UnsupportedError(
              'I file CBR non sono ancora supportati su Windows',
            );
          }
          await Rar.extractRarFile(
            rarFilePath: archivePath,
            destinationPath: pagesDir.path,
          );
        case BookFormat.epub:
        case BookFormat.pdf:
          throw ArgumentError('Formato non supportato per i fumetti: $format');
      }
    }
    return _listPagesSorted(pagesDir);
  }

  Future<Directory> _pagesDirFor(String bookId) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return Directory(p.join(documentsDir.path, 'comics', bookId));
  }

  Future<void> _extractCbz(String archivePath, String destinationPath) async {
    final bytes = await File(archivePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final entry in archive) {
      if (!entry.isFile) continue;
      if (!_imageExtensions.contains(p.extension(entry.name).toLowerCase())) {
        continue;
      }
      final destination = File(p.join(destinationPath, p.basename(entry.name)));
      await destination.writeAsBytes(entry.content as List<int>);
    }
  }

  Future<List<File>> _listPagesSorted(Directory pagesDir) async {
    final files = await pagesDir
        .list(recursive: true)
        .where(
          (entity) =>
              entity is File &&
              _imageExtensions.contains(p.extension(entity.path).toLowerCase()),
        )
        .cast<File>()
        .toList();
    files.sort(
      (a, b) => _naturalCompare(p.basename(a.path), p.basename(b.path)),
    );
    return files;
  }

  /// Confronto "naturale" dei nomi file, così "pagina2.jpg" precede
  /// "pagina10.jpg" invece di finire dopo per un ordinamento lessicografico.
  int _naturalCompare(String a, String b) {
    final chunksA = _splitAlphaNumeric(a);
    final chunksB = _splitAlphaNumeric(b);
    for (var i = 0; i < chunksA.length && i < chunksB.length; i++) {
      final numA = int.tryParse(chunksA[i]);
      final numB = int.tryParse(chunksB[i]);
      final comparison = (numA != null && numB != null)
          ? numA.compareTo(numB)
          : chunksA[i].compareTo(chunksB[i]);
      if (comparison != 0) return comparison;
    }
    return chunksA.length.compareTo(chunksB.length);
  }

  List<String> _splitAlphaNumeric(String value) =>
      RegExp(r'\d+|\D+').allMatches(value).map((m) => m.group(0)!).toList();
}
