import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mobi/dart_mobi.dart';
import 'package:easy_reader/data/import/mobi_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart' as xml;

void main() {
  test(
    'convertRawmlToEpub produces a well-formed EPUB from a MobiRawml',
    () async {
      // Markup HTML deliberatamente malformato (tag non chiusi, entità non
      // escapate) come quello che si trova davvero nei MOBI reali, più un
      // riferimento a un'immagine in stile Mobipocket (`recindex`, non `src`).
      final markup = MobiPart()
        ..data = utf8.encode(
          '<html><body><p>Ciao & benvenuto<img recindex="00001">'
          '<br>fine</body></html>',
        );

      final fakeJpegBytes = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9]);
      final resource = MobiPart()
        ..uid = 0
        ..fileType = MobiFileType.jpg
        ..data = fakeJpegBytes;

      final rawml = MobiRawml()
        ..markup = markup
        ..resources = resource;

      final outputPath =
          '${Directory.systemTemp.path}/mobi_converter_test_${DateTime.now().microsecondsSinceEpoch}.epub';

      final file = await MobiConverter().convertRawmlToEpub(
        rawml,
        'Libro di Prova',
        outputPath,
      );
      addTearDown(() => file.deleteSync());

      expect(file.existsSync(), isTrue);

      final archive = ZipDecoder().decodeBytes(await file.readAsBytes());

      final mimetype = archive.findFile('mimetype');
      expect(mimetype, isNotNull);
      expect(
        utf8.decode(mimetype!.content as List<int>),
        'application/epub+zip',
      );
      expect(mimetype.compress, isFalse);

      final container = archive.findFile('META-INF/container.xml');
      expect(container, isNotNull);
      xml.XmlDocument.parse(utf8.decode(container!.content as List<int>));

      final opf = archive.findFile('OEBPS/content.opf');
      expect(opf, isNotNull);
      final opfDoc = xml.XmlDocument.parse(
        utf8.decode(opf!.content as List<int>),
      );
      expect(
        opfDoc
            .findAllElements('item')
            .any((e) => e.getAttribute('href') == 'resource00000.jpg'),
        isTrue,
      );

      final contentFile = archive.findFile('OEBPS/content.xhtml');
      expect(contentFile, isNotNull);
      final contentXml = utf8.decode(contentFile!.content as List<int>);
      // Deve essere XML valido: se epub.js/il browser non riescono a fare il
      // parse come XHTML la pagina risulta vuota — questa è la verifica che
      // conta di più per l'HTML riparato dal parser HTML5 lenient.
      final contentDoc = xml.XmlDocument.parse(contentXml);
      expect(
        contentDoc.findAllElements('img').first.getAttribute('src'),
        'resource00000.jpg',
      );
      expect(contentDoc.findAllElements('br'), isNotEmpty);
      expect(contentXml.contains('Ciao &amp; benvenuto'), isTrue);

      final imageFile = archive.findFile('OEBPS/resource00000.jpg');
      expect(imageFile, isNotNull);
      expect(imageFile!.content, fakeJpegBytes);
    },
  );
}
