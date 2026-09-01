import '../../domain/entities/online_book.dart';
import '../../domain/entities/online_search_filters.dart';
import '../../domain/entities/online_search_page.dart';
import '../../domain/repositories/online_book_repository.dart';
import 'wikisource_book_repository.dart';

/// Combina più fonti dietro un'unica ricerca: [_primary] (Internet Archive)
/// per il catalogo più ampio, [_bonus] (Wikisource) per qualche risultato
/// italiano in più intercalato nella stessa pagina, non relegato in coda.
///
/// [filters.source] permette di restringere a una sola fonte, evitando del
/// tutto la chiamata di rete verso l'altra invece di interrogarla e
/// scartarne poi i risultati.
///
/// Quando entrambe sono attive, [start] resta l'offset nativo di [_primary]
/// (fatto apposta: [_primary] ha centinaia di risultati da poter sfogliare
/// a fondo, [_bonus] ne ha in genere molti meno). L'offset di [_bonus] non
/// viene sommato a [start] ma derivato da esso — [_wsChunk] risultati in
/// più per ogni pagina "nativa" di [_primary] — così le due paginazioni
/// avanzano in parallelo senza mai ripetersi né saltare risultati, restando
/// comunque calcolabili dal solo [start] senza stato nascosto tra una
/// chiamata e l'altra.
class CompositeBookRepository implements OnlineBookRepository {
  CompositeBookRepository(this._primary, this._bonus);

  final OnlineBookRepository _primary;
  final OnlineBookRepository _bonus;

  /// Deve combaciare con la dimensione di pagina di [_primary]
  /// (vedi `InternetArchiveBookRepository._pageSize`): è il passo con cui
  /// avanza il suo offset nativo, usato qui per derivare quello di [_bonus].
  static const _primaryPageSize = 25;
  static const _wsChunk = 5;

  @override
  Future<OnlineSearchPage> search(
    String query, {
    OnlineSearchFilters filters = const OnlineSearchFilters(),
    int start = 0,
  }) async {
    switch (filters.source) {
      case OnlineBookSource.internetArchive:
        return _primary.search(query, filters: filters, start: start);
      case OnlineBookSource.wikisource:
        return _bonus.search(query, filters: filters, start: start);
      case OnlineBookSource.any:
        break;
    }

    final wsOffset = (start ~/ _primaryPageSize) * _wsChunk;
    final results = await Future.wait([
      _primary.search(query, filters: filters, start: start),
      _bonus.search(query, filters: filters, start: wsOffset),
    ]);
    final primaryPage = results[0];
    final bonusPage = results[1];

    return OnlineSearchPage(
      books: [...bonusPage.books, ...primaryPage.books],
      totalCount: primaryPage.totalCount + bonusPage.totalCount,
      rawCount: primaryPage.rawCount,
    );
  }

  @override
  Future<String> resolveDownloadUrl(OnlineBook book, OnlineFileType fileType) {
    final repository = book.id.startsWith(wikisourceIdPrefix)
        ? _bonus
        : _primary;
    return repository.resolveDownloadUrl(book, fileType);
  }
}
