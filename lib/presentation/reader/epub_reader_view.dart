import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/filters/epub_theme_builder.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/filter_profile.dart';
import '../../domain/entities/reading_progress.dart';
import '../common/providers.dart';
import 'reader_progress_bar.dart';

class EpubReaderView extends ConsumerStatefulWidget {
  final Book book;
  final FilterProfile profile;

  /// Il controller vive in [EpubReaderView] ma è passato dall'esterno perché
  /// il pannello di ricerca, aperto dalla barra in alto in `ReaderScreen`,
  /// deve poter chiamare `search`/`display` sulla stessa istanza collegata
  /// alla WebView, non su un controller separato e "muto".
  final EpubController controller;

  /// Notificato quando l'epub ha finito il caricamento iniziale: `ReaderScreen`
  /// lo usa per abilitare i pulsanti di ricerca e lettura vocale solo a quel
  /// punto, prima la WebView non risponderebbe alle richieste.
  final VoidCallback? onLoaded;

  const EpubReaderView({
    super.key,
    required this.book,
    required this.profile,
    required this.controller,
    this.onLoaded,
  });

  @override
  ConsumerState<EpubReaderView> createState() => _EpubReaderViewState();
}

class _EpubReaderViewState extends ConsumerState<EpubReaderView> {
  EpubController get _controller => widget.controller;
  final _tts = FlutterTts();
  bool _epubLoaded = false;
  bool _isSpeaking = false;

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
    _tts.awaitSpeakCompletion(true);
    _bootstrap();
  }

  @override
  void dispose() {
    _isSpeaking = false;
    _tts.stop();
    super.dispose();
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

  Future<void> _toggleReadAloud() async {
    if (_isSpeaking) {
      setState(() => _isSpeaking = false);
      await _tts.stop();
      return;
    }
    setState(() => _isSpeaking = true);
    while (_isSpeaking && mounted) {
      final extracted = await _controller.extractCurrentPageText();
      final text = extracted.text?.trim() ?? '';
      if (!_isSpeaking || !mounted) break;
      if (text.isNotEmpty) {
        await _tts.speak(text);
      }
      if (!_isSpeaking || !mounted) break;
      final location = await _controller.getCurrentLocation();
      if (location.progress >= 0.999) break;
      _controller.next();
      // Lascia il tempo alla WebView di completare il cambio pagina prima
      // di estrarre il testo della pagina successiva, altrimenti si rischia
      // di leggere ancora il contenuto di quella appena lasciata.
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (mounted) setState(() => _isSpeaking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              EpubViewer(
                epubController: _controller,
                epubSource: _epubSource!,
                initialCfi: _initialCfi,
                displaySettings: EpubDisplaySettings(
                  fontSize: widget.profile.fontSize.round(),
                  // Espliciti (anche se coincidono con i default del
                  // pacchetto) per garantire lo sfoglio a pagine invece dello
                  // scroll continuo: manager continuo che precarica i
                  // capitoli, ma li mostra impaginati uno schermo alla volta.
                  flow: EpubFlow.paginated,
                  manager: EpubManager.continuous,
                  snap: true,
                  theme: buildEpubTheme(widget.profile),
                ),
                onEpubLoaded: () {
                  setState(() => _epubLoaded = true);
                  widget.onLoaded?.call();
                },
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
              if (_epubLoaded)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    tooltip: _isSpeaking
                        ? 'Interrompi lettura vocale'
                        : 'Leggi ad alta voce',
                    onPressed: _toggleReadAloud,
                    child: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
                  ),
                ),
            ],
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
