import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../domain/entities/book.dart';
import '../../domain/entities/filter_profile.dart';
import '../../domain/entities/reading_progress.dart';
import '../common/providers.dart';
import 'reader_progress_bar.dart';

class PdfReaderView extends ConsumerStatefulWidget {
  final Book book;
  final FilterProfile profile;

  const PdfReaderView({super.key, required this.book, required this.profile});

  @override
  ConsumerState<PdfReaderView> createState() => _PdfReaderViewState();
}

class _PdfReaderViewState extends ConsumerState<PdfReaderView> {
  final _controller = PdfViewerController();
  int? _initialPage;
  bool _resolvedInitialPosition = false;

  @override
  void initState() {
    super.initState();
    ref
        .read(readingProgressRepositoryProvider)
        .watch(widget.book.id)
        .first
        .then((progress) {
          if (!mounted) return;
          setState(() {
            _initialPage = progress == null
                ? null
                : int.tryParse(progress.position);
            _resolvedInitialPosition = true;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (!_resolvedInitialPosition) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: SfPdfViewer.file(
            File(widget.book.filePath),
            controller: _controller,
            // Nessuna selezione/evidenziazione del testo: qui deve
            // restare un lettore, non un editor di annotazioni.
            enableTextSelection: false,
            canShowTextSelectionMenu: false,
            onDocumentLoaded: (details) {
              final target = _initialPage;
              if (target != null &&
                  target > 1 &&
                  target <= details.document.pages.count) {
                _controller.jumpToPage(target);
              }
            },
            onPageChanged: (details) {
              final total = _controller.pageCount;
              ref
                  .read(readingProgressRepositoryProvider)
                  .save(
                    ReadingProgress(
                      bookId: widget.book.id,
                      position: '${details.newPageNumber}',
                      percentage: total > 0 ? details.newPageNumber / total : 0,
                      totalUnits: total > 0 ? total : null,
                      updatedAt: DateTime.now(),
                    ),
                  );
            },
          ),
        ),
        ReaderProgressBar(bookId: widget.book.id),
      ],
    );
  }
}
