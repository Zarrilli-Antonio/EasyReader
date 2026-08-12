/// Formati ebook apribili dal reader. Altri formati (FB2, TXT) arriveranno
/// nelle fasi successive della roadmap, dietro conversione a EPUB. MOBI/AZW3
/// vengono convertiti a EPUB già in fase di importazione (vedi
/// `MobiConverter`), quindi non hanno un proprio [BookFormat].
enum BookFormat {
  epub,
  pdf,
  cbz,
  cbr;

  static BookFormat? fromExtension(String extension) {
    switch (extension.toLowerCase().replaceFirst('.', '')) {
      case 'epub':
        return BookFormat.epub;
      case 'pdf':
        return BookFormat.pdf;
      case 'cbz':
        return BookFormat.cbz;
      case 'cbr':
        return BookFormat.cbr;
      default:
        return null;
    }
  }

  /// Riconoscimento da MIME type, usato per i file ricevuti tramite
  /// condivisione da un'altra app: arrivano copiati in una cache che spesso
  /// non mantiene l'estensione originale del file.
  static BookFormat? fromMimeType(String? mimeType) {
    switch (mimeType) {
      case 'application/epub+zip':
        return BookFormat.epub;
      case 'application/pdf':
        return BookFormat.pdf;
      case 'application/vnd.comicbook+zip':
      case 'application/x-cbz':
        return BookFormat.cbz;
      case 'application/vnd.comicbook-rar':
      case 'application/x-cbr':
        return BookFormat.cbr;
      default:
        return null;
    }
  }

  bool get isComic => this == BookFormat.cbz || this == BookFormat.cbr;

  String get storageName => name;

  static BookFormat fromStorageName(String value) =>
      BookFormat.values.firstWhere((f) => f.storageName == value);
}
