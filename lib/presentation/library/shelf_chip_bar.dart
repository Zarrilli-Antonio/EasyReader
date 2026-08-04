import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/shelf.dart';
import '../common/overlay_utils.dart';
import '../common/providers.dart';
import 'shelf_editor_sheet.dart';

/// Riga orizzontale di filtri: "Tutti i libri", una chip per ogni libreria
/// creata (tocco = filtra, pressione lunga = modifica/elimina) e una chip
/// finale per crearne una nuova.
class ShelfChipBar extends ConsumerWidget {
  final String? selectedShelfId;
  final ValueChanged<String?> onSelect;

  const ShelfChipBar({
    super.key,
    required this.selectedShelfId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelvesAsync = ref.watch(shelvesProvider);
    final shelves = shelvesAsync.valueOrNull ?? const <Shelf>[];

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ChoiceChip(
            label: const Text('Tutti i libri'),
            selected: selectedShelfId == null,
            onSelected: (_) => onSelect(null),
          ),
          const SizedBox(width: 8),
          for (final shelf in shelves) ...[
            GestureDetector(
              onLongPress: () => _showShelfActions(context, ref, shelf),
              // Click destro del mouse su desktop = pressione prolungata su mobile.
              onSecondaryTap: () => _showShelfActions(context, ref, shelf),
              child: ChoiceChip(
                avatar: Icon(shelf.icon.data, size: 18, color: shelf.color),
                label: Text(shelf.name),
                selected: selectedShelfId == shelf.id,
                onSelected: (_) => onSelect(shelf.id),
              ),
            ),
            const SizedBox(width: 8),
          ],
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: const Text('Nuova libreria'),
            onPressed: () => showShelfEditorSheet(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _showShelfActions(
    BuildContext context,
    WidgetRef ref,
    Shelf shelf,
  ) async {
    final action = await showModalBottomSheet<_ShelfAction>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Modifica libreria'),
              onTap: () => Navigator.of(sheetContext).pop(_ShelfAction.rename),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(
                'Elimina libreria',
                style: TextStyle(
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
              ),
              onTap: () => Navigator.of(sheetContext).pop(_ShelfAction.delete),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || action == null) return;
    await settleAfterOverlayClose();
    if (!context.mounted) return;
    switch (action) {
      case _ShelfAction.rename:
        await showShelfEditorSheet(context, ref, existing: shelf);
      case _ShelfAction.delete:
        await _confirmDeleteShelf(context, ref, shelf);
    }
  }

  Future<void> _confirmDeleteShelf(
    BuildContext context,
    WidgetRef ref,
    Shelf shelf,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminare la libreria?'),
        content: Text(
          '"${shelf.name}" verrà eliminata. I libri al suo interno restano nella libreria generale, senza essere cancellati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (selectedShelfId == shelf.id) {
        onSelect(null);
      }
      await settleAfterOverlayClose();
      await ref.read(deleteShelfUseCaseProvider)(shelf.id);
    }
  }
}

enum _ShelfAction { rename, delete }
