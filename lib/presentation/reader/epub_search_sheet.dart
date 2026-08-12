import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';

/// Ricerca full-text nel libro aperto, delegata a epub.js tramite lo stesso
/// [EpubController] collegato alla WebView del reader. Selezionando un
/// risultato si naviga al suo CFI e il pannello si chiude.
class EpubSearchSheet extends StatefulWidget {
  final EpubController controller;

  const EpubSearchSheet({super.key, required this.controller});

  @override
  State<EpubSearchSheet> createState() => _EpubSearchSheetState();
}

class _EpubSearchSheetState extends State<EpubSearchSheet> {
  final _queryController = TextEditingController();
  List<EpubSearchResult> _results = const [];
  bool _searching = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = const []);
      return;
    }
    setState(() => _searching = true);
    final results = await widget.controller.search(query: query.trim());
    if (!mounted) return;
    setState(() {
      _results = results;
      _searching = false;
    });
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
                hintText: 'Cerca nel libro…',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _search,
            ),
            const SizedBox(height: 12),
            if (_searching) const Center(child: CircularProgressIndicator()),
            if (!_searching &&
                _results.isEmpty &&
                _queryController.text.isNotEmpty)
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
                    title: Text(
                      result.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      widget.controller.display(cfi: result.cfi);
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
