/// Formati ebook apribili dal reader. Altri formati (MOBI, AZW3, FB2, TXT)
/// arriveranno nelle fasi successive della roadmap, dietro conversione a EPUB.
enum BookFormat {
  epub,
  pdf;

  static BookFormat? fromExtension(String extension) {
    switch (extension.toLowerCase().replaceFirst('.', '')) {
      case 'epub':
        return BookFormat.epub;
      case 'pdf':
        return BookFormat.pdf;
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
      default:
        return null;
    }
  }

  String get storageName => name;

  static BookFormat fromStorageName(String value) =>
      BookFormat.values.firstWhere((f) => f.storageName == value);
}
