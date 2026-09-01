/// Tipo di file richiesto in una ricerca online, o [any] per accettare
/// qualunque formato tra quelli che la fonte offre.
enum OnlineFileType { any, epub, pdf, mobi }

/// Quale fonte interrogare, o [any] per cercare su tutte contemporaneamente.
/// Restringere a una sola fonte evita del tutto la chiamata di rete verso
/// le altre, invece di scartarne poi i risultati.
enum OnlineBookSource { any, internetArchive, wikisource }

/// Filtri opzionali per la ricerca di ebook online. [language] è un codice
/// lingua ISO a due lettere (es. 'it'); [subject] è testo libero perché la
/// tassonomia dei generi di Internet Archive non è un elenco fisso e chiuso.
class OnlineSearchFilters {
  final String? language;
  final String? subject;
  final OnlineFileType fileType;
  final OnlineBookSource source;

  const OnlineSearchFilters({
    this.language,
    this.subject,
    this.fileType = OnlineFileType.any,
    this.source = OnlineBookSource.any,
  });

  bool get isEmpty =>
      language == null &&
      (subject == null || subject!.trim().isEmpty) &&
      fileType == OnlineFileType.any &&
      source == OnlineBookSource.any;
}
