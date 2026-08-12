import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;

/// Ricerca full-text per il motore nativo Windows: `epub_view` non la
/// fornisce, quindi cerchiamo a mano nel testo semplice di ogni capitolo
/// (estratto dall'HTML già caricato in memoria) e saltiamo all'inizio del
/// capitolo trovato — non al punto esatto come nel motore epub.js, perché
/// qui non esiste un equivalente di un CFI generato dalla ricerca.
class EpubNativeSearchSheet extends StatefulWidget {
  final EpubController controller;

  const EpubNativeSearchSheet({super.key, required this.controller});

  @override
  State<EpubNativeSearchSheet> createState() => _EpubNativeSearchSheetState();
}

class _ChapterMatch {
  final String title;
  final String excerpt;
  final int startIndex;

  _ChapterMatch({
    required this.title,
    required this.excerpt,
    required this.startIndex,
  });
}

class _EpubNativeSearchSheetState extends State<EpubNativeSearchSheet> {
  final _queryController = TextEditingController();
  List<_ChapterMatch> _results = const [];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      setState(() => _results = const []);
      return;
    }
    final toc = widget.controller.tableOfContents();
    final chapters = widget.controller.document;
    chapters.then((book) {
      if (!mounted) return;
      final flatChapters = _flatten(book.Chapters ?? const []);
      final results = <_ChapterMatch>[];
      for (var i = 0; i < flatChapters.length && i < toc.length; i++) {
        final html = flatChapters[i].HtmlContent;
        if (html == null) continue;
        final text = html_parser.parse(html).body?.text ?? '';
        final matchIndex = text.toLowerCase().indexOf(needle);
        if (matchIndex == -1) continue;
        final excerptStart = (matchIndex - 40).clamp(0, text.length);
        final excerptEnd = (matchIndex + needle.length + 40).clamp(
          0,
          text.length,
        );
        results.add(
          _ChapterMatch(
            title: toc[i].title ?? 'Capitolo ${i + 1}',
            excerpt: text.substring(excerptStart, excerptEnd).trim(),
            startIndex: toc[i].startIndex,
          ),
        );
      }
      setState(() => _results = results);
    });
  }

  List<EpubChapter> _flatten(List<EpubChapter> chapters) {
    final flat = <EpubChapter>[];
    for (final chapter in chapters) {
      flat.add(chapter);
      flat.addAll(_flatten(chapter.SubChapters ?? const []));
    }
    return flat;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _queryController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cerca nel libro (per capitolo)…',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _search,
            ),
            const SizedBox(height: 12),
            if (_results.isEmpty && _queryController.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Nessun risultato'),
              ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _results.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return ListTile(
                    title: Text(result.title),
                    subtitle: Text(
                      result.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      widget.controller.jumpTo(index: result.startIndex);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
