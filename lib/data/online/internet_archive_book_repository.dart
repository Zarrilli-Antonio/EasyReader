import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/online_book.dart';
import '../../domain/entities/online_search_filters.dart';
import '../../domain/entities/online_search_page.dart';
import '../../domain/repositories/online_book_repository.dart';
import 'retry.dart';

/// Cerca e scarica ebook di pubblico dominio dai mirror che Internet Archive
/// (https://archive.org) mantiene per due cataloghi distinti — "gutenberg"
/// (l'intero Project Gutenberg) e "standardebooks" (edizioni ricurate di
/// Standard Ebooks) — invece che dai siti originali: gutenberg.org si è
/// rivelato irraggiungibile per problemi di risoluzione DNS non legati a
/// EasyReader (falliva anche dal dispositivo dell'utente), mentre
/// standardebooks.org richiede un account per la ricerca via API. Passando
/// da archive.org, che li mirra entrambi pubblicamente, si evitano tutti e
/// due i problemi con un'unica integrazione — e aggiungere un'altra
/// collezione mirrorata da Internet Archive in futuro è solo una riga in
/// più in [_collections].
class InternetArchiveBookRepository implements OnlineBookRepository {
  static const _collections = ['gutenberg', 'standardebooks'];

  /// Il campo "language" della collezione non è normalizzato (compaiono sia
  /// codici a due che a tre lettere, a volte il nome per intero): includere
  /// tutte le varianti note rende il filtro robusto a questa incoerenza.
  static const _languageCodes = {
    'it': ['ita', 'it', 'italian'],
    'en': ['eng', 'en', 'english'],
    'es': ['spa', 'es', 'spanish'],
    'fr': ['fre', 'fra', 'fr', 'french'],
    'de': ['ger', 'deu', 'de', 'german'],
  };

  static const _formatTokens = {
    OnlineFileType.epub: 'EPUB',
    OnlineFileType.pdf: 'PDF',
    OnlineFileType.mobi: 'MOBI',
  };

  static const _extensions = {
    OnlineFileType.epub: '.epub',
    OnlineFileType.pdf: '.pdf',
    OnlineFileType.mobi: '.mobi',
  };

  static const _pageSize = 25;

  @override
  Future<OnlineSearchPage> search(
    String query, {
    OnlineSearchFilters filters = const OnlineSearchFilters(),
    int start = 0,
  }) async {
    final trimmed = query.trim();
    final subject = filters.subject?.trim();
    if (trimmed.isEmpty && filters.isEmpty) {
      return const OnlineSearchPage(books: [], totalCount: 0, rawCount: 0);
    }

    final clauses = ['collection:(${_collections.join(' OR ')})'];
    if (trimmed.isNotEmpty) clauses.add('($trimmed)');
    if (filters.language != null) {
      final codes = _languageCodes[filters.language] ?? [filters.language!];
      clauses.add('language:(${codes.join(' OR ')})');
    }
    if (subject != null && subject.isNotEmpty) {
      clauses.add('subject:($subject)');
    }
    if (filters.fileType != OnlineFileType.any) {
      clauses.add('format:(${_formatTokens[filters.fileType]})');
    }

    // L'endpoint accetta ed echeggia "start" nella risposta ma lo ignora di
    // fatto (restituisce sempre la prima pagina, verificato empiricamente):
    // la paginazione che funziona davvero è quella a pagine 1-indexed.
    final page = (start ~/ _pageSize) + 1;
    final uri = Uri.parse(
      'https://archive.org/advancedsearch.php'
      '?q=${Uri.encodeQueryComponent(clauses.join(' AND '))}'
      '&fl[]=identifier&fl[]=title&fl[]=creator&fl[]=format'
      '&rows=$_pageSize&page=$page&output=json',
    );

    final response = await withRetry(
      () => http.get(uri).timeout(const Duration(seconds: 20)),
    );
    if (response.statusCode != 200) {
      throw Exception('Internet Archive ha risposto ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final responseBody = json['response'] as Map<String, dynamic>? ?? const {};
    final docs = responseBody['docs'] as List<dynamic>? ?? const [];
    final totalCount = responseBody['numFound'] as int? ?? docs.length;

    // La collezione "gutenberg" include anche audiolibri LibriVox delle
    // stesse opere: se non si è già filtrato per un formato specifico nella
    // query, va comunque escluso chi non ha nessuno dei formati leggibili
    // dall'app, altrimenti il download fallirebbe sempre. Il conteggio
    // totale resta quello grezzo di Internet Archive: usato solo per capire
    // se proporre "carica altri", non per numerare i risultati mostrati.
    final needsClientFilter = filters.fileType == OnlineFileType.any;
    final books = docs
        .where((doc) => !needsClientFilter || _hasReadableFormat(doc))
        .map(_toOnlineBook)
        .toList(growable: false);

    return OnlineSearchPage(
      books: books,
      totalCount: totalCount,
      rawCount: docs.length,
    );
  }

  bool _hasReadableFormat(dynamic raw) {
    final format = (raw as Map<String, dynamic>)['format'];
    final tokens = _formatTokens.values;
    if (format is List) return format.any(tokens.contains);
    return tokens.contains(format);
  }

  OnlineBook _toOnlineBook(dynamic raw) {
    final entry = raw as Map<String, dynamic>;
    final identifier = entry['identifier'] as String;
    final creator = entry['creator'];
    final author = creator is List
        ? creator.join(', ')
        : (creator as String? ?? '');

    return OnlineBook(
      id: identifier,
      title: entry['title'] as String? ?? '',
      author: author,
      // Servizio di anteprima di Internet Archive: nessuna chiamata extra
      // ai metadati necessaria solo per mostrare una copertina.
      coverUrl: 'https://archive.org/services/img/$identifier',
    );
  }

  @override
  Future<String> resolveDownloadUrl(
    OnlineBook book,
    OnlineFileType fileType,
  ) async {
    final response = await withRetry(
      () => http
          .get(Uri.https('archive.org', '/metadata/${book.id}'))
          .timeout(const Duration(seconds: 20)),
    );
    if (response.statusCode != 200) {
      throw Exception('Internet Archive ha risposto ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final files = json['files'] as List<dynamic>? ?? const [];
    final names = files
        .map((f) => (f as Map<String, dynamic>)['name'] as String)
        .toList();

    // "any" prova nell'ordine di preferenza dell'app: EPUB ha filtri,
    // ricerca e lettura vocale già pronti, MOBI viene solo convertito.
    final tryOrder = fileType == OnlineFileType.any
        ? const [OnlineFileType.epub, OnlineFileType.pdf, OnlineFileType.mobi]
        : [fileType];

    for (final type in tryOrder) {
      final fileName = _findFile(names, _extensions[type]!);
      if (fileName != null) {
        return 'https://archive.org/download/${book.id}/$fileName';
      }
    }
    throw Exception('Nessun file scaricabile trovato per questo libro');
  }

  String? _findFile(List<String> names, String extension) {
    final candidates = names.where(
      (name) => name.toLowerCase().endsWith(extension),
    );
    if (candidates.isEmpty) return null;
    // Preferisce l'EPUB "semplice" (più piccolo) a quello con le immagini
    // incorporate, se entrambi sono disponibili.
    return candidates.firstWhere(
      (name) => !name.contains('-images'),
      orElse: () => candidates.first,
    );
  }
}
