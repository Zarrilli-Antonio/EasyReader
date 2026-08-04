import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/filters/epub_theme_builder.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/filter_profile.dart';
import '../../domain/entities/reading_progress.dart';
import '../common/providers.dart';
import 'reader_progress_bar.dart';

class EpubReaderView extends ConsumerStatefulWidget {
  final Book book;
  final FilterProfile profile;

  const EpubReaderView({super.key, required this.book, required this.profile});

  @override
  ConsumerState<EpubReaderView> createState() => _EpubReaderViewState();
}

class _EpubReaderViewState extends ConsumerState<EpubReaderView> {
  final _controller = EpubController();
  bool _epubLoaded = false;

  // Caricati una sola volta in initState: l'istanza di EpubSource deve
  // restare stabile fra un rebuild e l'altro, altrimenti ogni tocco dello
  // slider filtri (che rifà il build di questo widget) ricaricherebbe da
  // zero il contenuto nella WebView.
  String? _initialCfi;
  EpubSource? _epubSource;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final progress = await ref
        .read(readingProgressRepositoryProvider)
        .watch(widget.book.id)
        .first;
    if (!mounted) return;
    setState(() {
      _initialCfi = (progress?.position.isNotEmpty ?? false)
          ? progress!.position
          : null;
      // Percorso principale del pacchetto per i file locali. L'analizzatore
      // segnala un mismatch di tipo su `File` perché risolve l'import
      // condizionale del pacchetto sulla variante web anziché io — un
      // falso positivo confermato: la build Android reale compila ed è
      // proprio questo il costruttore, non fromData, quello testato dal
      // pacchetto per file locali.
      // ignore: argument_type_not_assignable
      _epubSource = EpubSource.fromFile(File(widget.book.filePath));
      _ready = true;
    });
  }

  @override
  void didUpdateWidget(covariant EpubReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_epubLoaded) return;
    if (oldWidget.profile.backgroundColor != widget.profile.backgroundColor ||
        oldWidget.profile.lineHeight != widget.profile.lineHeight ||
        oldWidget.profile.useDyslexiaFont != widget.profile.useDyslexiaFont) {
      _controller.updateTheme(theme: buildEpubTheme(widget.profile));
    }
    if (oldWidget.profile.fontSize != widget.profile.fontSize) {
      _controller.setFontSize(fontSize: widget.profile.fontSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: EpubViewer(
            epubController: _controller,
            epubSource: _epubSource!,
            initialCfi: _initialCfi,
            displaySettings: EpubDisplaySettings(
              fontSize: widget.profile.fontSize.round(),
              // Espliciti (anche se coincidono con i default del pacchetto)
              // per garantire lo sfoglio a pagine invece dello scroll
              // continuo: manager continuo che precarica i capitoli,
              // ma li mostra impaginati uno schermo alla volta.
              flow: EpubFlow.paginated,
              manager: EpubManager.continuous,
              snap: true,
              theme: buildEpubTheme(widget.profile),
            ),
            onEpubLoaded: () => setState(() => _epubLoaded = true),
            onRelocated: (location) {
              ref
                  .read(readingProgressRepositoryProvider)
                  .save(
                    ReadingProgress(
                      bookId: widget.book.id,
                      position: location.startCfi,
                      percentage: location.progress,
                      updatedAt: DateTime.now(),
                    ),
                  );
            },
          ),
        ),
        ReaderProgressBar(
          bookId: widget.book.id,
          onPrevious: _epubLoaded ? _controller.prev : null,
          onNext: _epubLoaded ? _controller.next : null,
        ),
      ],
    );
  }
}
