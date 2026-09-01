import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/online/retry.dart';
import '../../domain/entities/online_book.dart';
import '../../domain/entities/online_search_filters.dart';
import '../../l10n/app_localizations.dart';
import '../common/providers.dart';

/// Ricerca e importazione di ebook di pubblico dominio da fonti online —
/// oggi Internet Archive (Gutenberg e Standard Ebooks) e Wikisource in
/// italiano, dietro la stessa interfaccia [OnlineBookRepository] che rende
/// semplice aggiungere altre fonti in futuro senza toccare questa schermata.
class OnlineSearchScreen extends ConsumerStatefulWidget {
  const OnlineSearchScreen({super.key});

  @override
  ConsumerState<OnlineSearchScreen> createState() => _OnlineSearchScreenState();
}

class _OnlineSearchScreenState extends ConsumerState<OnlineSearchScreen> {
  final _queryController = TextEditingController();
  final _subjectController = TextEditingController();
  String? _language;
  OnlineFileType _fileType = OnlineFileType.any;
  OnlineBookSource _source = OnlineBookSource.any;

  List<OnlineBook> _results = const [];
  bool _searching = false;
  bool _loadingMore = false;
  bool _searched = false;
  String? _downloadingId;
  String? _searchError;
  int _nextStart = 0;
  int _totalCount = 0;

  bool get _hasMore => _nextStart < _totalCount;

  static String _extensionFor(OnlineFileType type) {
    switch (type) {
      case OnlineFileType.pdf:
        return '.pdf';
      case OnlineFileType.mobi:
        return '.mobi';
      case OnlineFileType.epub:
      case OnlineFileType.any:
        return '.epub';
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  OnlineSearchFilters get _filters => OnlineSearchFilters(
    language: _language,
    subject: _subjectController.text,
    fileType: _fileType,
    source: _source,
  );

  Future<void> _search([String? _]) async {
    final query = _queryController.text;
    if (query.trim().isEmpty && _filters.isEmpty) return;
    setState(() {
      _searching = true;
      _searched = true;
      _searchError = null;
    });
    try {
      final page = await ref
          .read(onlineBookRepositoryProvider)
          .search(query, filters: _filters);
      if (!mounted) return;
      setState(() {
        _results = page.books;
        _nextStart = page.rawCount;
        _totalCount = page.totalCount;
        _searching = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _nextStart = 0;
        _totalCount = 0;
        _searchError = '$error';
        _searching = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final page = await ref
          .read(onlineBookRepositoryProvider)
          .search(_queryController.text, filters: _filters, start: _nextStart);
      if (!mounted) return;
      setState(() {
        _results = [..._results, ...page.books];
        _nextStart += page.rawCount;
        _totalCount = page.totalCount;
        _loadingMore = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.discoverBooksSearchError('$error'),
          ),
        ),
      );
    }
  }

  Future<void> _download(OnlineBook book) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _downloadingId = book.id);
    try {
      final downloadUrl = await ref
          .read(onlineBookRepositoryProvider)
          .resolveDownloadUrl(book, _fileType);
      final response = await withRetry(
        () => http
            .get(Uri.parse(downloadUrl))
            .timeout(const Duration(seconds: 30)),
      );
      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }
      final tempDir = await getTemporaryDirectory();
      // Su macOS questa cartella non esiste ancora finché non ci scrive
      // qualcun altro: writeAsBytes non la crea da sola, va fatto esplicitamente.
      if (!await tempDir.exists()) {
        await tempDir.create(recursive: true);
      }
      // Non tutte le fonti restituiscono un URL con estensione nel path (es.
      // Wikisource, che passa il formato come query param): se manca si usa
      // il tipo di file richiesto, o EPUB come miglior default con "any".
      var extension = p.extension(Uri.parse(downloadUrl).path);
      if (extension.isEmpty) {
        extension = _extensionFor(
          _fileType == OnlineFileType.any ? OnlineFileType.epub : _fileType,
        );
      }
      // L'id di alcune fonti (es. Wikisource) contiene caratteri non validi
      // in un nome di file (":", spazi): va reso sicuro prima di scriverlo
      // su disco.
      final safeName = book.id.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      final tempFile = File(p.join(tempDir.path, '$safeName$extension'));
      await tempFile.writeAsBytes(response.bodyBytes);

      final imported = await ref
          .read(importBookUseCaseProvider)
          .importFromPath(tempFile.path, fallbackCoverUrl: book.coverUrl);
      await tempFile.delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            imported != null
                ? l10n.downloadSuccessMessage(book.title)
                : l10n.downloadErrorMessage,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.downloadErrorMessageDetailed('$error'))),
      );
    } finally {
      if (mounted) setState(() => _downloadingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoverBooks)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _queryController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  tooltip: l10n.discoverBooksSearchButton,
                  onPressed: _search,
                ),
                hintText: l10n.discoverBooksSearchHint,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: _search,
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(l10n.discoverBooksFilters),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _language,
                        decoration: InputDecoration(
                          labelText: l10n.discoverBooksLanguageLabel,
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.discoverBooksLanguageAny),
                          ),
                          DropdownMenuItem(
                            value: 'it',
                            child: Text(l10n.languageItalian),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(l10n.languageEnglish),
                          ),
                          DropdownMenuItem(
                            value: 'es',
                            child: Text(l10n.languageSpanish),
                          ),
                          DropdownMenuItem(
                            value: 'fr',
                            child: Text(l10n.languageFrench),
                          ),
                          DropdownMenuItem(
                            value: 'de',
                            child: Text(l10n.languageGerman),
                          ),
                        ],
                        onChanged: (value) => setState(() => _language = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          labelText: l10n.discoverBooksSubjectLabel,
                          hintText: l10n.discoverBooksSubjectHint,
                          isDense: true,
                        ),
                        onSubmitted: _search,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.discoverBooksFileTypeLabel,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.discoverBooksFileTypeAny),
                      selected: _fileType == OnlineFileType.any,
                      onSelected: (_) =>
                          setState(() => _fileType = OnlineFileType.any),
                    ),
                    ChoiceChip(
                      label: const Text('EPUB'),
                      selected: _fileType == OnlineFileType.epub,
                      onSelected: (_) =>
                          setState(() => _fileType = OnlineFileType.epub),
                    ),
                    ChoiceChip(
                      label: const Text('PDF'),
                      selected: _fileType == OnlineFileType.pdf,
                      onSelected: (_) =>
                          setState(() => _fileType = OnlineFileType.pdf),
                    ),
                    ChoiceChip(
                      label: const Text('MOBI'),
                      selected: _fileType == OnlineFileType.mobi,
                      onSelected: (_) =>
                          setState(() => _fileType = OnlineFileType.mobi),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.discoverBooksSourceFilterLabel,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.discoverBooksSourceFilterAny),
                      selected: _source == OnlineBookSource.any,
                      onSelected: (_) =>
                          setState(() => _source = OnlineBookSource.any),
                    ),
                    ChoiceChip(
                      label: const Text('Internet Archive'),
                      selected: _source == OnlineBookSource.internetArchive,
                      onSelected: (_) => setState(
                        () => _source = OnlineBookSource.internetArchive,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('Wikisource'),
                      selected: _source == OnlineBookSource.wikisource,
                      onSelected: (_) =>
                          setState(() => _source = OnlineBookSource.wikisource),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.discoverBooksSourceLabel,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_searchError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.discoverBooksSearchError(_searchError!),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    if (!_searched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(l10n.discoverBooksEmptyHint, textAlign: TextAlign.center),
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(child: Text(l10n.discoverBooksNoResults));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _results.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _results.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: _loadingMore
                  ? const CircularProgressIndicator()
                  : OutlinedButton(
                      onPressed: _loadMore,
                      child: Text(l10n.discoverBooksLoadMore),
                    ),
            ),
          );
        }
        final book = _results[index];
        final downloading = _downloadingId == book.id;
        return ListTile(
          leading: SizedBox(
            width: 40,
            height: 56,
            child: book.coverUrl != null
                ? Image.network(
                    book.coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.menu_book_outlined),
                  )
                : const Icon(Icons.menu_book_outlined),
          ),
          title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: downloading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.download_outlined),
                  tooltip: l10n.download,
                  onPressed: _downloadingId == null
                      ? () => _download(book)
                      : null,
                ),
        );
      },
    );
  }
}
