/// Risultato di una ricerca su una fonte online di ebook liberi (es. la
/// collezione Gutenberg su Internet Archive). Non è un [Book]: esiste solo
/// finché l'utente non decide di scaricarlo e importarlo in libreria.
///
/// [id] è l'identificatore usato dalla fonte per risolvere l'URL di download
/// reale (vedi [OnlineBookRepository.resolveDownloadUrl]): al momento della
/// ricerca non è ancora noto il nome esatto del file da scaricare, solo
/// dopo un'interrogazione dedicata.
class OnlineBook {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;

  const OnlineBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
  });
}
