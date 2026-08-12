import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mobi/dart_mobi.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

/// Converte un MOBI/AZW3/AZW in un EPUB "sintetico" in fase di importazione,
/// così il resto dell'app (reader, filtri, ricerca, lettura vocale) tratta
/// questi formati come un EPUB qualunque senza bisogno di un motore di
/// rendering dedicato — sono comunque HTML+risorse sotto il cofano.
///
/// Copertura intenzionalmente limitata alla parte "documento": un solo file
/// XHTML con tutto il testo del libro (senza indice dei capitoli) e le
/// immagini incorporate. Sufficiente per leggere il libro; la struttura a
/// capitoli di MOBI/KF8 è più complessa da ricostruire fedelmente e non vale
/// la spesa per questa fase.
class MobiConverter {
  static const _imageTypeExtensions = {
    MobiFileType.jpg: 'jpg',
    MobiFileType.png: 'png',
    MobiFileType.gif: 'gif',
    MobiFileType.bmp: 'bmp',
  };

  static const _imageMimeTypes = {
    'jpg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
  };

  Future<File> convertToEpub(File sourceFile, String destinationPath) async {
    final mobiData = await DartMobiReader.read(await sourceFile.readAsBytes());
    final rawml = mobiData.parseOpt(false, false, true);
    final title = mobiData.mobiHeader?.fullname?.trim().isNotEmpty == true
        ? mobiData.mobiHeader!.fullname!.trim()
        : 'Untitled';
    return convertRawmlToEpub(rawml, title, destinationPath);
  }

  /// Logica di trasformazione pura, separata da [convertToEpub] per poterla
  /// testare con un [MobiRawml] costruito a mano, senza dover passare da un
  /// file MOBI binario reale.
  Future<File> convertRawmlToEpub(
    MobiRawml rawml,
    String title,
    String destinationPath,
  ) async {
    final resources = _extractImageResources(rawml);
    final bodyHtml = _repairToXhtmlBody(
      _concatenateMarkup(rawml)
      // Le vecchie immagini in stile Mobipocket referenziano la risorsa
      // con `recindex` invece di `src`; KF8 usa `kindle:embed:` già
      // riscritto da `parseOpt(reconstruct: true)` in `src="resourceN.ext"`.
      .replaceAllMapped(RegExp('recindex="0*(\\d+)"'), (match) {
        final index = int.parse(match.group(1)!) - 1;
        final resource = resources[index];
        return resource != null
            ? 'src="${resource.fileName}"'
            : match.group(0)!;
      }),
    );

    final imageResources = resources.nonNulls.toList();

    final archive = Archive()
      ..addFile(
        ArchiveFile.string('mimetype', 'application/epub+zip')
          ..compress = false,
      )
      ..addFile(ArchiveFile.string('META-INF/container.xml', _containerXml))
      ..addFile(
        ArchiveFile.string(
          'OEBPS/content.opf',
          _contentOpf(title, imageResources),
        ),
      )
      ..addFile(ArchiveFile.string('OEBPS/toc.ncx', _tocNcx(title)))
      ..addFile(
        ArchiveFile.string(
          'OEBPS/content.xhtml',
          _contentXhtml(title, bodyHtml),
        ),
      );
    for (final resource in imageResources) {
      archive.addFile(
        ArchiveFile.noCompress(
          'OEBPS/${resource.fileName}',
          resource.bytes.length,
          resource.bytes,
        ),
      );
    }

    final epubBytes = ZipEncoder().encode(archive);
    if (epubBytes == null) {
      throw StateError('Impossibile generare il file EPUB dal MOBI');
    }
    final destination = File(destinationPath);
    await destination.writeAsBytes(epubBytes);
    return destination;
  }

  String _concatenateMarkup(MobiRawml rawml) {
    final buffer = StringBuffer();
    var part = rawml.markup;
    while (part != null) {
      if (part.data != null) {
        buffer.write(utf8.decode(part.data!, allowMalformed: true));
      }
      part = part.next;
    }
    return buffer.toString();
  }

  List<_ImageResource?> _extractImageResources(MobiRawml rawml) {
    final resources = <_ImageResource?>[];
    var part = rawml.resources;
    while (part != null) {
      final extension = _imageTypeExtensions[part.fileType];
      if (extension == null || part.data == null) {
        resources.add(null);
      } else {
        resources.add(
          _ImageResource(
            fileName:
                'resource${part.uid.toString().padLeft(5, '0')}.$extension',
            mimeType: _imageMimeTypes[extension]!,
            bytes: part.data!,
          ),
        );
      }
      part = part.next;
    }
    return resources;
  }

  static const _voidElements = {
    'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link',
    'meta', 'param', 'source', 'track', 'wbr', //
  };

  String _repairToXhtmlBody(String rawHtml) {
    final document = html_parser.parse(rawHtml);
    final buffer = StringBuffer();
    for (final node in document.body?.nodes ?? const <dom.Node>[]) {
      _writeNode(buffer, node);
    }
    return buffer.toString();
  }

  void _writeNode(StringBuffer buffer, dom.Node node) {
    if (node is dom.Text) {
      buffer.write(_escapeText(node.text));
      return;
    }
    if (node is dom.Element) {
      final tag = node.localName ?? '';
      if (tag.isEmpty) return;
      buffer.write('<$tag');
      for (final entry in node.attributes.entries) {
        buffer.write(' ${entry.key}="${_escapeAttribute(entry.value)}"');
      }
      if (_voidElements.contains(tag)) {
        buffer.write('/>');
        return;
      }
      buffer.write('>');
      for (final child in node.nodes) {
        _writeNode(buffer, child);
      }
      buffer.write('</$tag>');
    }
  }

  String _escapeText(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');

  String _escapeAttribute(String value) =>
      _escapeText(value).replaceAll('"', '&quot;');

  String get _containerXml => '''<?xml version="1.0"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>''';

  String _contentOpf(String title, List<_ImageResource> resources) {
    final manifestItems = StringBuffer();
    for (final resource in resources) {
      manifestItems.write(
        '<item id="${resource.fileName}" href="${resource.fileName}" '
        'media-type="${resource.mimeType}"/>\n',
      );
    }
    return '''<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="BookId" version="2.0">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:title>${_escapeText(title)}</dc:title>
    <dc:identifier id="BookId">easyreader-${title.hashCode}</dc:identifier>
  </metadata>
  <manifest>
    <item id="content" href="content.xhtml" media-type="application/xhtml+xml"/>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    $manifestItems
  </manifest>
  <spine toc="ncx">
    <itemref idref="content"/>
  </spine>
</package>''';
  }

  String _tocNcx(String title) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
  <head/>
  <docTitle><text>${_escapeText(title)}</text></docTitle>
  <navMap>
    <navPoint id="nav1" playOrder="1">
      <navLabel><text>${_escapeText(title)}</text></navLabel>
      <content src="content.xhtml"/>
    </navPoint>
  </navMap>
</ncx>''';

  String _contentXhtml(String title, String bodyHtml) =>
      '''<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>${_escapeText(title)}</title></head>
<body>$bodyHtml</body>
</html>''';
}

class _ImageResource {
  final String fileName;
  final String mimeType;
  final Uint8List bytes;

  _ImageResource({
    required this.fileName,
    required this.mimeType,
    required this.bytes,
  });
}
