import 'online_book.dart';

/// Una pagina di risultati di ricerca online, con il conteggio totale
/// disponibile lato fonte — necessario per sapere se ha senso proporre di
/// caricare altri risultati.
class OnlineSearchPage {
  final List<OnlineBook> books;
  final int totalCount;

  /// Quanti risultati grezzi ha restituito la fonte per questa pagina,
  /// prima di eventuali filtri applicati lato client (es. l'esclusione
  /// degli audiolibri): serve a calcolare l'offset della pagina successiva,
  /// perché [books] può contenerne di meno.
  final int rawCount;

  const OnlineSearchPage({
    required this.books,
    required this.totalCount,
    required this.rawCount,
  });
}
