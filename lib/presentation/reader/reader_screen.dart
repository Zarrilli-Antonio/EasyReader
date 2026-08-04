import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/filters/filter_overlay.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/book_format.dart';
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
  Widget build(BuildContext context) {
    final filterAsync = ref.watch(activeFilterProvider);

    final appBar = AppBar(
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
            BookFormat.epub => EpubReaderView(
              book: widget.book,
              profile: profile,
            ),
            BookFormat.pdf => PdfReaderView(
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
        body: Center(child: Text('Errore filtri: $error')),
      ),
    );
  }
}
