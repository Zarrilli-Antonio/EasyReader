import 'dart:io';

import 'package:epub_view/epub_view.dart' as native;
import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/filters/filter_overlay.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/book_format.dart';
import '../../l10n/app_localizations.dart';
import '../common/providers.dart';
import '../filters/filter_panel.dart';
import '../filters/filter_providers.dart';
import 'comic_reader_view.dart';
import 'epub_native_reader_view.dart';
import 'epub_native_search_sheet.dart';
import 'epub_reader_view.dart';
import 'epub_search_sheet.dart';
import 'pdf_reader_view.dart';

/// `flutter_epub_viewer` (WebView + epub.js) dichiara esplicitamente di non
/// supportare Windows nel proprio pubspec, quindi lì si usa `epub_view`
/// (rendering nativo a widget Flutter) al suo posto. Le altre piattaforme
/// restano sul motore epub.js, già collaudato.
bool get _useNativeEpubEngine => Platform.isWindows;

class ReaderScreen extends ConsumerStatefulWidget {
  final Book book;

  const ReaderScreen({super.key, required this.book});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  // Vivono qui, non dentro le view di lettura, perché il pannello di ricerca
  // è aperto da questa barra in alto e deve poter chiamare `search`/`jumpTo`
  // sulla stessa istanza collegata al motore di rendering.
  EpubController? _epubController;
  native.EpubController? _nativeEpubController;
  bool _epubLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.book.format == BookFormat.epub) {
      if (_useNativeEpubEngine) {
        _nativeEpubController = native.EpubController(
          document: native.EpubReader.readBook(
            File(widget.book.filePath).readAsBytes(),
          ),
        );
      } else {
        _epubController = EpubController();
      }
    }
    Future.microtask(
      () => ref
          .read(bookRepositoryProvider)
          .markOpened(widget.book.id, DateTime.now()),
    );
  }

  @override
  void dispose() {
    _nativeEpubController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filterAsync = ref.watch(activeFilterProvider);

    final appBar = AppBar(
      title: Text(widget.book.title, overflow: TextOverflow.ellipsis),
      actions: [
        if (_epubController != null || _nativeEpubController != null)
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.searchInBook,
            onPressed: _epubLoaded
                ? () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => _epubController != null
                        ? EpubSearchSheet(controller: _epubController!)
                        : EpubNativeSearchSheet(
                            controller: _nativeEpubController!,
                          ),
                  )
                : null,
          ),
        IconButton(
          icon: const Icon(Icons.tune),
          tooltip: l10n.readingFilters,
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => FilterPanel(bookFormat: widget.book.format),
          ),
        ),
      ],
    );

    // Il filtro avvolge tutta la schermata (barra in alto e barra di
    // progresso comprese), non solo il contenuto: altrimenti con luminosità
    // o temperatura colore accentuate resterebbero delle zone dell'interfaccia
    // fuori tono rispetto alla pagina, proprio l'effetto fastidioso da evitare.
    return filterAsync.when(
      data: (profile) => FilterOverlay(
        profile: profile,
        child: Scaffold(
          appBar: appBar,
          body: switch (widget.book.format) {
            BookFormat.epub =>
              _useNativeEpubEngine
                  ? EpubNativeReaderView(
                      book: widget.book,
                      profile: profile,
                      controller: _nativeEpubController!,
                      onLoaded: () => setState(() => _epubLoaded = true),
                    )
                  : EpubReaderView(
                      book: widget.book,
                      profile: profile,
                      controller: _epubController!,
                      onLoaded: () => setState(() => _epubLoaded = true),
                    ),
            BookFormat.pdf => PdfReaderView(
              book: widget.book,
              profile: profile,
            ),
            BookFormat.cbz || BookFormat.cbr => ComicReaderView(
              book: widget.book,
              profile: profile,
            ),
          },
        ),
      ),
      loading: () => Scaffold(
        appBar: appBar,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: appBar,
        body: Center(child: Text(l10n.filtersErrorMessage('$error'))),
      ),
    );
  }
}
