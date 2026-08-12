import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/comics/comic_extractor.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/filter_profile.dart';
import '../../domain/entities/reading_progress.dart';
import '../common/providers.dart';
import 'reader_progress_bar.dart';

/// Visualizzatore CBZ/CBR: le pagine sono semplici immagini estratte
/// dall'archivio, sfogliate con uno swipe orizzontale (come i lettori di
/// fumetti standard) invece del layout a scroll continuo dell'EPUB.
class ComicReaderView extends ConsumerStatefulWidget {
  final Book book;
  final FilterProfile profile;

  const ComicReaderView({super.key, required this.book, required this.profile});

  @override
  ConsumerState<ComicReaderView> createState() => _ComicReaderViewState();
}

class _ComicReaderViewState extends ConsumerState<ComicReaderView> {
  final _comicExtractor = ComicExtractor();
  late final PageController _controller;
  List<File> _pages = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      final pages = await _comicExtractor.extractPages(
        bookId: widget.book.id,
        archivePath: widget.book.filePath,
        format: widget.book.format,
      );
      final progress = await ref
          .read(readingProgressRepositoryProvider)
          .watch(widget.book.id)
          .first;
      if (!mounted) return;
      // Salvata come "pagina N" 1-based, come il PDF, per coerenza con
      // l'etichetta "Pagina X di Y" di ReaderProgressBar.
      final initialIndex = (int.tryParse(progress?.position ?? '') ?? 1) - 1;
      setState(() {
        _pages = pages;
        _loading = false;
      });
      if (initialIndex > 0 && initialIndex < pages.length) {
        _controller.jumpToPage(initialIndex);
      }
    } on UnsupportedError catch (error) {
      if (!mounted) return;
      setState(() {
        _error =
            error.message ?? 'Formato non supportato su questa piattaforma';
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Impossibile aprire questo fumetto';
        _loading = false;
      });
    }
  }

  void _onPageChanged(int index) {
    ref
        .read(readingProgressRepositoryProvider)
        .save(
          ReadingProgress(
            bookId: widget.book.id,
            position: '${index + 1}',
            percentage: _pages.isEmpty ? 0 : (index + 1) / _pages.length,
            totalUnits: _pages.length,
            updatedAt: DateTime.now(),
          ),
        );
  }

  void _goToPage(int delta) {
    _controller.animateToPage(
      (_controller.page!.round() + delta).clamp(0, _pages.length - 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null || _pages.isEmpty) {
      return Center(child: Text(_error ?? 'Nessuna pagina trovata'));
    }
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) => InteractiveViewer(
              maxScale: 4,
              child: Center(child: Image.file(_pages[index])),
            ),
          ),
        ),
        ReaderProgressBar(
          bookId: widget.book.id,
          onPrevious: () => _goToPage(-1),
          onNext: () => _goToPage(1),
        ),
      ],
    );
  }
}
