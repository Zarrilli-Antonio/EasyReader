import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/shelf.dart';
import '../../domain/entities/shelf_icon.dart';
import '../../l10n/app_localizations.dart';
import '../common/providers.dart';

/// Apre il foglio di creazione/modifica di una libreria. Passare [existing]
/// per modificarne una già esistente.
Future<void> showShelfEditorSheet(
  BuildContext context,
  WidgetRef ref, {
  Shelf? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ShelfEditorSheet(existing: existing),
  );
}

class _ShelfEditorSheet extends ConsumerStatefulWidget {
  final Shelf? existing;
  const _ShelfEditorSheet({this.existing});

  @override
  ConsumerState<_ShelfEditorSheet> createState() => _ShelfEditorSheetState();
}

class _ShelfEditorSheetState extends ConsumerState<_ShelfEditorSheet> {
  late final TextEditingController _nameController;
  late Color _selectedColor;
  late ShelfIcon _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '')
      ..addListener(() => setState(() {}));
    _selectedColor = widget.existing?.color ?? shelfColorPalette.first;
    _selectedIcon = widget.existing?.icon ?? ShelfIcon.book;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.existing != null;
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
              isEditing ? l10n.editShelf : l10n.newShelf,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              autofocus: !isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.shelfNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.colorLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: shelfColorPalette.map((color) {
                final selected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 3,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(l10n.iconLabel, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ShelfIcon.values.map((icon) {
                final selected = icon == _selectedIcon;
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? _selectedColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: selected ? _selectedColor : Colors.grey.shade400,
                      ),
                    ),
                    child: Icon(
                      icon.data,
                      color: selected ? _selectedColor : Colors.grey.shade600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _nameController.text.trim().isEmpty ? null : _save,
                child: Text(isEditing ? l10n.save : l10n.createShelf),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final repository = ref.read(shelfRepositoryProvider);
    final existing = widget.existing;
    if (existing != null) {
      await repository.update(
        existing.copyWith(
          name: name,
          color: _selectedColor,
          icon: _selectedIcon,
        ),
      );
    } else {
      await repository.add(
        Shelf(
          id: const Uuid().v4(),
          name: name,
          color: _selectedColor,
          icon: _selectedIcon,
        ),
      );
    }
    if (mounted) {
      // Vedi commento analogo per il dialog di rinomina: evita di chiudere
      // il foglio mentre il campo nome ha ancora la tastiera aperta.
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    }
  }
}
