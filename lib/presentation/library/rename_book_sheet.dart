import 'package:flutter/material.dart';

/// Foglio di rinomina libro. Deliberatamente un bottom sheet e non un
/// `AlertDialog`: quest'ultimo, con un `TextField` autofocus dentro, ha
/// scatenato più volte un assert interno di Flutter sugli InheritedWidget
/// alla chiusura (tastiera + transizione del dialog in corsa tra loro). Lo
/// stesso schema di bottom sheet è già usato per creare/modificare una
/// libreria, senza mai lo stesso problema.
Future<void> showRenameBookSheet(
  BuildContext context, {
  required String currentTitle,
  required Future<void> Function(String newTitle) onSave,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        _RenameBookSheet(currentTitle: currentTitle, onSave: onSave),
  );
}

class _RenameBookSheet extends StatefulWidget {
  final String currentTitle;
  final Future<void> Function(String newTitle) onSave;

  const _RenameBookSheet({required this.currentTitle, required this.onSave});

  @override
  State<_RenameBookSheet> createState() => _RenameBookSheetState();
}

class _RenameBookSheetState extends State<_RenameBookSheet> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTitle)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = !_saving && _controller.text.trim().isNotEmpty;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
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
            Text(
              'Rinomina libro',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canSave ? _save : null,
                child: const Text('Salva'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final title = _controller.text.trim();
    if (title.isEmpty || _saving) return;
    setState(() => _saving = true);
    // Aspetta che la scrittura sia completata (e quindi la ricostruzione
    // della griglia sottostante già avvenuta) prima di chiudere il foglio,
    // così la transizione di chiusura non deve competere con un rebuild.
    await widget.onSave(title);
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }
}
