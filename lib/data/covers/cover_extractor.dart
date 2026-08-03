import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:xml/xml.dart' as xml;

import '../../domain/entities/book_format.dart';
import '../../domain/repositories/cover_extractor.dart';

/// Estrae un'immagine di copertina per la card della libreria: la copertina
/// incorporata nel manifest per EPUB (lo standard del formato — non un vero
/// screenshot del testo), la prima pagina renderizzata per PDF.
///
/// Best-effort: se il file è malformato o non ha una copertina riconoscibile
/// ritorna `null` senza bloccare l'importazione del libro.
class ArchiveCoverExtractor implements CoverExtractor {
  @override
  Future<String?> extract({
    required String bookId,
    required String sourceFilePath,
    required BookFormat format,
  }) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final coversDir = Directory(p.join(documentsDir.path, 'covers'));
      if (!await coversDir.exists()) {
        await coversDir.create(recursive: true);
      }
      return switch (format) {
        BookFormat.epub => await _extractEpubCover(
          sourceFilePath,
          bookId,
          coversDir.path,
        ),
        BookFormat.pdf => await _extractPdfCover(
          sourceFilePath,
          bookId,
          coversDir.path,
        ),
      };
    } catch (_) {
      return null;
    }
  }

  Future<String?> _extractEpubCover(
    String sourceFilePath,
    String bookId,
    String coversDirPath,
  ) async {
    final bytes = await File(sourceFilePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final containerFile = archive.findFile('META-INF/container.xml');
    if (containerFile == null) return null;
    final containerDoc = xml.XmlDocument.parse(
      utf8.decode(containerFile.content, allowMalformed: true),
    );
    final rootfiles = containerDoc.findAllElements('rootfile').toList();
    if (rootfiles.isEmpty) return null;
    final opfPath = rootfiles.first.getAttribute('full-path');
    if (opfPath == null) return null;

    final opfFile = archive.findFile(opfPath);
    if (opfFile == null) return null;
    final opfDoc = xml.XmlDocument.parse(
      utf8.decode(opfFile.content, allowMalformed: true),
    );

    final manifestItems = opfDoc.findAllElements('item').toList();
    final coverItem =
        _find(
          manifestItems,
          (e) => (e.getAttribute('properties') ?? '')
              .split(' ')
              .contains('cover-image'),
        ) ??
        _findByCoverMeta(opfDoc, manifestItems) ??
        _find(manifestItems, (e) {
          final mediaType = e.getAttribute('media-type') ?? '';
          final idOrHref =
              '${e.getAttribute('id') ?? ''} ${e.getAttribute('href') ?? ''}'
                  .toLowerCase();
          return mediaType.startsWith('image/') && idOrHref.contains('cover');
        });
    final href = coverItem?.getAttribute('href');
    if (href == null) return null;

    final imagePath = p.posix.normalize(
      p.posix.join(p.posix.dirname(opfPath), Uri.decodeComponent(href)),
    );
    final imageFile = archive.findFile(imagePath);
    if (imageFile == null) return null;

    final extension = p.extension(imagePath).isNotEmpty
        ? p.extension(imagePath)
        : '.jpg';
    final destination = p.join(coversDirPath, '$bookId$extension');
    await File(destination).writeAsBytes(imageFile.content);
    return destination;
  }

  xml.XmlElement? _findByCoverMeta(
    xml.XmlDocument opfDoc,
    List<xml.XmlElement> manifestItems,
  ) {
    final coverId = _find(
      opfDoc.findAllElements('meta').toList(),
      (e) => e.getAttribute('name') == 'cover',
    )?.getAttribute('content');
    if (coverId == null) return null;
    return _find(manifestItems, (e) => e.getAttribute('id') == coverId);
  }

  xml.XmlElement? _find(
    List<xml.XmlElement> items,
    bool Function(xml.XmlElement) test,
  ) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  Future<String?> _extractPdfCover(
    String sourceFilePath,
    String bookId,
    String coversDirPath,
  ) async {
    final document = await pdfx.PdfDocument.openFile(sourceFilePath);
    try {
      final page = await document.getPage(1);
      try {
        final image = await page.render(
          width: page.width,
          height: page.height,
          format: pdfx.PdfPageImageFormat.jpeg,
        );
        if (image == null) return null;
        final destination = p.join(coversDirPath, '$bookId.jpg');
        await File(destination).writeAsBytes(image.bytes);
        return destination;
      } finally {
        await page.close();
      }
    } finally {
      await document.close();
    }
  }
}
