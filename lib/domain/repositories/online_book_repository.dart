import '../entities/online_book.dart';
import '../entities/online_search_filters.dart';
import '../entities/online_search_page.dart';

/// Interfaccia comune per una fonte di ebook liberi da cercare e scaricare.
/// Pensata per avere più implementazioni dietro la stessa ricerca (oggi la
/// collezione Gutenberg di Internet Archive, altre fonti in futuro).
abstract class OnlineBookRepository {
  /// [start] è l'offset per la paginazione (0 = prima pagina): la fonte può
  /// avere centinaia di risultati per una ricerca generica, non tutti in
  /// una volta sola.
  Future<OnlineSearchPage> search(
    String query, {
    OnlineSearchFilters filters = const OnlineSearchFilters(),
    int start = 0,
  });

  /// Risolve l'URL di download effettivo per [book]: alcune fonti (come
  /// questa) non lo conoscono già al momento della ricerca, perché il nome
  /// esatto del file richiede un'interrogazione dedicata sui metadati.
  /// [fileType] segue la preferenza usata in [search] (vedi
  /// [OnlineSearchFilters.fileType]).
  Future<String> resolveDownloadUrl(OnlineBook book, OnlineFileType fileType);
}
