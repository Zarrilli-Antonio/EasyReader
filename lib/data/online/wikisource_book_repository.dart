import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/online_book.dart';
import '../../domain/entities/online_search_filters.dart';
import '../../domain/entities/online_search_page.dart';
import '../../domain/repositories/online_book_repository.dart';
import 'retry.dart';

/// Prefisso che marca un [OnlineBook.id] come proveniente da questa fonte,
/// così [CompositeBookRepository] sa a quale repository instradare
/// [resolveDownloadUrl] senza dover interrogare più fonti per scoprirlo.
const wikisourceIdPrefix = 'wikisource:';

/// Cerca testi di pubblico dominio in italiano su it.wikisource.org e li
/// scarica in EPUB tramite ws-export (https://ws-export.wmcloud.org), il
/// servizio ufficiale della Wikimedia Foundation che assembla le pagine wiki
/// di un'opera in un unico file: Wikisource di per sé non ospita file
/// scaricabili, solo pagine HTML.
///
/// Copre solo l'italiano (è un progetto diviso per lingua, un dominio per
/// lingua) e solo EPUB — PDF e MOBI su ws-export sono andati in timeout nei
/// test manuali, quindi non abbastanza affidabili da offrirli in un'app.
/// Per queste combinazioni [search] restituisce sempre una pagina vuota,
/// così chi la compone con altre fonti sa di doverla saltare.
class WikisourceBookRepository implements OnlineBookRepository {
  static const _pageSize = 25;
  static const _emptyPage = OnlineSearchPage(
    books: [],
    totalCount: 0,
    rawCount: 0,
  );

  @override
  Future<OnlineSearchPage> search(
    String query, {
    OnlineSearchFilters filters = const OnlineSearchFilters(),
    int start = 0,
  }) async {
    if (filters.language != null && filters.language != 'it') {
      return _emptyPage;
    }
    if (filters.fileType != OnlineFileType.any &&
        filters.fileType != OnlineFileType.epub) {
      return _emptyPage;
    }
    final terms = [
      query.trim(),
      filters.subject?.trim() ?? '',
    ].where((t) => t.isNotEmpty).join(' ');
    if (terms.isEmpty) return _emptyPage;

    final uri = Uri.https('it.wikisource.org', '/w/api.php', {
      'action': 'query',
      // "list=search" (con srlimit minimo) serve solo a farsi restituire
      // "searchinfo.totalhits" nella stessa chiamata: è lo stesso motore di
      // ricerca di "generator=search" sotto, non un'interrogazione diversa.
      'list': 'search',
      'srsearch': terms,
      'srnamespace': '0',
      'srlimit': '1',
      'srprop': '',
      'generator': 'search',
      'gsrsearch': terms,
      'gsrnamespace': '0',
      'gsrlimit': '$_pageSize',
      'gsroffset': '$start',
      'prop': 'pageimages',
      'piprop': 'thumbnail',
      'pithumbsize': '200',
      'format': 'json',
    });

    final response = await withRetry(
      // L'API di Wikimedia rifiuta con 403 le richieste senza uno User-Agent
      // descrittivo (verificato empiricamente): non basta lasciare quello
      // di default del client HTTP.
      () => http
          .get(uri, headers: const {'User-Agent': 'EasyReaderApp/1.1'})
          .timeout(const Duration(seconds: 20)),
    );
    if (response.statusCode != 200) {
      throw Exception('Wikisource ha risposto ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final queryResult = json['query'] as Map<String, dynamic>?;
    final totalHits =
        (queryResult?['searchinfo'] as Map<String, dynamic>?)?['totalhits']
            as int? ??
        0;
    final pages = queryResult?['pages'] as Map<String, dynamic>? ?? const {};
    final rawEntries = pages.values.cast<Map<String, dynamic>>().toList();

    // Le sottopagine dei singoli capitoli (es. "Opera/Capitolo 3")
    // comparirebbero come libri separati e incompleti: ws-export assembla
    // già l'opera intera a partire dalla pagina principale, quindi vanno
    // escluse dai risultati mostrati. Il conteggio grezzo (prima del
    // filtro) resta quello usato per calcolare l'offset della pagina
    // successiva, sullo stesso principio già usato per Internet Archive.
    final books =
        (rawEntries.where((p) => !(p['title'] as String).contains('/')).toList()
              ..sort(
                (a, b) => (a['index'] as int).compareTo(b['index'] as int),
              ))
            .map(_toOnlineBook)
            .toList(growable: false);

    return OnlineSearchPage(
      books: books,
      totalCount: totalHits,
      rawCount: rawEntries.length,
    );
  }

  OnlineBook _toOnlineBook(Map<String, dynamic> entry) {
    final title = entry['title'] as String;
    final thumbnail = entry['thumbnail'] as Map<String, dynamic>?;
    return OnlineBook(
      id: '$wikisourceIdPrefix$title',
      title: title,
      // L'API di ricerca di MediaWiki non restituisce l'autore: richiederebbe
      // un'altra chiamata per pagina (ai dati strutturati di Wikidata), non
      // giustificata per un campo puramente informativo nella lista risultati.
      author: '',
      coverUrl: thumbnail?['source'] as String?,
    );
  }

  @override
  Future<String> resolveDownloadUrl(
    OnlineBook book,
    OnlineFileType fileType,
  ) async {
    final title = book.id.substring(wikisourceIdPrefix.length);
    return Uri.https('ws-export.wmcloud.org', '/', {
      'lang': 'it',
      'format': 'epub-3',
      'page': title,
    }).toString();
  }
}
