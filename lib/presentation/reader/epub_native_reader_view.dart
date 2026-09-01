import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart' as html_parser;

import '../../domain/entities/book.dart';
import '../../domain/entities/filter_profile.dart';
import '../../domain/entities/reading_progress.dart';
import '../../l10n/app_localizations.dart';
import '../common/providers.dart';
import 'reader_progress_bar.dart';

/// Motore di lettura EPUB alternativo, usato solo su Windows: `flutter_epub_viewer`
/// (basato su WebView + epub.js) dichiara esplicitamente di non supportare
/// Windows nel proprio pubspec. `epub_view` renderizza invece i capitoli come
/// widget Flutter nativi (scroll continuo, non paginato), quindi qui i filtri
/// EPUB-specifici (colore pagina, dimensione testo, interlinea, font per
/// dislessia) si applicano via `TextStyle`/`Container` invece che via CSS
/// iniettato in una WebView, e ricerca/lettura vocale lavorano per capitolo
/// intero invece che per pagina.
class EpubNativeReaderView extends ConsumerStatefulWidget {
  final Book book;
  final FilterProfile profile;

  /// Come in `EpubReaderView`, il controller vive fuori da questo widget
  /// perché il pannello di ricerca aperto da `ReaderScreen` deve poter
  /// chiamare `jumpTo` sulla stessa istanza.
  final EpubController controller;
  final VoidCallback? onLoaded;

  const EpubNativeReaderView({
    super.key,
    required this.book,
    required this.profile,
    required this.controller,
    this.onLoaded,
  });

  @override
  ConsumerState<EpubNativeReaderView> createState() =>
      _EpubNativeReaderViewState();
}

class _EpubNativeReaderViewState extends ConsumerState<EpubNativeReaderView> {
  EpubController get _controller => widget.controller;
  final _tts = FlutterTts();
  bool _isSpeaking = false;
  bool _loaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tts.awaitSpeakCompletion(true);
    _controller.isBookLoaded.addListener(_onLoadStateChanged);
    // `isBookLoaded` resta `false` anche in caso di errore di parsing (vedi
    // `EpubController._loadDocument` nel package), quindi senza ascoltare
    // anche `loadingState` un fallimento lascerebbe lo spinner per sempre.
    _controller.loadingState.addListener(_onLoadingStateChanged);
    _controller.currentValueListenable.addListener(_saveProgress);
  }

  @override
  void dispose() {
    // Il plugin nativo Windows di `flutter_tts` chiama `speakResult->Success(1)`
    // dentro `stop()` quando `awaitSpeakCompletion` è true (impostato in
    // `initState`) — ma `speakResult` viene assegnato solo dentro `speak()`.
    // Se non si è mai usata la lettura vocale, quel puntatore è ancora nullo:
    // chiamare `stop()` qui incondizionatamente causa un crash nativo (non
    // intercettabile da Dart) ogni volta che si esce dal lettore EPUB senza
    // aver mai premuto "leggi ad alta voce".
    if (_isSpeaking) {
      _tts.stop();
    }
    _isSpeaking = false;
    _controller.isBookLoaded.removeListener(_onLoadStateChanged);
    _controller.loadingState.removeListener(_onLoadingStateChanged);
    _controller.currentValueListenable.removeListener(_saveProgress);
    super.dispose();
  }

  void _onLoadStateChanged() {
    if (!_controller.isBookLoaded.value || _loaded) return;
    _loaded = true;
    widget.onLoaded?.call();
    if (mounted) setState(() {});
  }

  void _onLoadingStateChanged() {
    if (_controller.loadingState.value != EpubViewLoadingState.error) return;
    _hasError = true;
    if (mounted) setState(() {});
  }

  void _saveProgress() {
    final cfi = _controller.generateEpubCfi();
    if (cfi == null) return;
    final chapters = _controller.tableOfContents();
    final chapterNumber = _controller.currentValue?.chapterNumber ?? 0;
    final percentage = chapters.isEmpty
        ? 0.0
        : (chapterNumber / chapters.length).clamp(0.0, 1.0);
    ref
        .read(readingProgressRepositoryProvider)
        .save(
          ReadingProgress(
            bookId: widget.book.id,
            position: cfi,
            percentage: percentage,
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> _toggleReadAloud() async {
    if (_isSpeaking) {
      setState(() => _isSpeaking = false);
      await _tts.stop();
      return;
    }
    setState(() => _isSpeaking = true);
    var chapterNumber = _controller.currentValue?.chapterNumber ?? 0;
    final toc = _controller.tableOfContents();
    while (_isSpeaking && mounted && chapterNumber < toc.length) {
      final chapter = _controller.currentValue?.chapter;
      final text = chapter?.HtmlContent != null
          ? html_parser.parse(chapter!.HtmlContent).body?.text.trim() ?? ''
          : '';
      if (!_isSpeaking || !mounted) break;
      if (text.isNotEmpty) {
        await _tts.speak(text);
      }
      if (!_isSpeaking || !mounted) break;
      chapterNumber++;
      if (chapterNumber >= toc.length) break;
      await _controller.scrollTo(index: toc[chapterNumber].startIndex);
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (mounted) setState(() => _isSpeaking = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = widget.profile;
    final textColor =
        ThemeData.estimateBrightnessForColor(profile.backgroundColor) ==
            Brightness.dark
        ? Colors.white
        : Colors.black;

    // `EpubView` va sempre montato: è il suo `initState` ad agganciare il
    // controller e avviare il parsing del libro. Nasconderlo finché
    // `_loaded` è false (come si faceva prima) crea uno stallo, perché quel
    // caricamento non parte mai senza il widget montato.
    return Column(
      children: [
        Expanded(
          child: Container(
            color: profile.backgroundColor,
            child: Stack(
              children: [
                EpubView(
                  controller: _controller,
                  builders: EpubViewBuilders<DefaultBuilderOptions>(
                    options: DefaultBuilderOptions(
                      textStyle: TextStyle(
                        fontSize: profile.fontSize,
                        height: profile.lineHeight,
                        color: textColor,
                        fontFamily: profile.useDyslexiaFont
                            ? 'OpenDyslexic'
                            : null,
                      ),
                    ),
                  ),
                ),
                if (!_loaded && !_hasError)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
        ReaderProgressBar(
          bookId: widget.book.id,
          trailing: IconButton(
            tooltip: _isSpeaking ? l10n.stopReadAloud : l10n.readAloud,
            icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
            onPressed: _loaded ? _toggleReadAloud : null,
          ),
        ),
      ],
    );
  }
}
