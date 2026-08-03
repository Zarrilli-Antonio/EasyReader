import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/book.dart';
import '../../domain/entities/book_format.dart';
import '../../domain/entities/reading_session.dart';
import '../common/providers.dart';
import '../filters/filter_panel.dart';
import '../filters/filter_providers.dart';
import 'epub_reader_view.dart';
import 'pdf_reader_view.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final Book book;

  const ReaderScreen({super.key, required this.book});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  static const _uuid = Uuid();
  final DateTime _sessionStartedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(bookRepositoryProvider)
          .markOpened(widget.book.id, DateTime.now()),
    );
  }

  @override
  void dispose() {
    final endedAt = DateTime.now();
    // Aperture troppo brevi (tocco accidentale, torna subito indietro) non
    // vengono contate come una vera sessione di lettura.
    if (endedAt.difference(_sessionStartedAt) >= const Duration(seconds: 5)) {
      ref
          .read(readingSessionRepositoryProvider)
          .record(
            ReadingSession(
              id: _uuid.v4(),
              bookId: widget.book.id,
              startedAt: _sessionStartedAt,
              endedAt: endedAt,
            ),
          );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterAsync = ref.watch(activeFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filtri di lettura',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => FilterPanel(bookFormat: widget.book.format),
            ),
          ),
        ],
      ),
      body: filterAsync.when(
        data: (profile) => switch (widget.book.format) {
          BookFormat.epub => EpubReaderView(
            book: widget.book,
            profile: profile,
          ),
          BookFormat.pdf => PdfReaderView(book: widget.book, profile: profile),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Errore filtri: $error')),
      ),
    );
  }
}
