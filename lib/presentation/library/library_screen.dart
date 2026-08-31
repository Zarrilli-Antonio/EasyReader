import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/book.dart';
import '../../domain/entities/book_format.dart';
import '../../domain/entities/shelf.dart';
import '../../l10n/app_localizations.dart';
import '../common/overlay_utils.dart';
import '../common/providers.dart';
import '../reader/reader_screen.dart';
import '../settings/settings_screen.dart';
import '../statistics/statistics_screen.dart';
import 'book_stats_sheet.dart';
import 'rename_book_sheet.dart';
import 'shelf_chip_bar.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String? _selectedShelfId;
  StreamSubscription<List<SharedMediaFile>>? _shareSubscription;

  @override
  void initState() {
    super.initState();
    // receive_sharing_intent non supporta Windows/desktop in generale: la
    // condivisione da altre app è un concetto mobile, non chiamarlo altrove
    // per evitare una MissingPluginException all'avvio.
    if (Platform.isAndroid || Platform.isIOS) {
      _handleInitialShare();
      _shareSubscription = ReceiveSharingIntent.instance
          .getMediaStream()
          .listen(_handleSharedFiles);
    }
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    final update = await ref.read(updateCheckerProvider).checkForUpdate();
    if (!mounted || update == null) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 8),
        content: Text(l10n.updateAvailable(update.version)),
        action: SnackBarAction(
          label: l10n.download,
          onPressed: () => launchUrl(
            Uri.parse(update.releaseUrl),
            mode: LaunchMode.externalApplication,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shareSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleInitialShare() async {
    final initialFiles = await ReceiveSharingIntent.instance.getInitialMedia();
    if (initialFiles.isEmpty) return;
    await _handleSharedFiles(initialFiles);
    await ReceiveSharingIntent.instance.reset();
  }

  Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
    final booksToImport = files.where(
      (file) => file.type == SharedMediaType.file,
    );
    if (booksToImport.isEmpty) return;

    final importBook = ref.read(importBookUseCaseProvider);
    var imported = 0;
    for (final file in booksToImport) {
      final book = await importBook.importFromPath(
        file.path,
        shelfId: _selectedShelfId,
        mimeType: file.mimeType,
      );
      if (book != null) imported++;
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final message = imported == 0
        ? l10n.unsupportedFormatMessage
        : l10n.importedBooksMessage(imported);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final booksAsync = ref.watch(booksProvider);
    final shelvesAsync = ref.watch(shelvesProvider);

    Shelf? selectedShelf;
    final shelvesList = shelvesAsync.valueOrNull;
    if (shelvesList != null && _selectedShelfId != null) {
      for (final shelf in shelvesList) {
        if (shelf.id == _selectedShelfId) {
          selectedShelf = shelf;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedShelf?.name ?? l10n.myLibrary),
        actions: [
          IconButton(
            icon: const Icon(Icons.query_stats_outlined),
            tooltip: l10n.readingStats,
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const StatisticsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ShelfChipBar(
            selectedShelfId: _selectedShelfId,
            onSelect: (shelfId) => setState(() => _selectedShelfId = shelfId),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: booksAsync.when(
              data: (books) {
                final visibleBooks = _selectedShelfId == null
                    ? books
                    : books
                          .where((book) => book.shelfId == _selectedShelfId)
                          .toList();
                return visibleBooks.isEmpty
                    ? _EmptyLibrary(isFiltered: _selectedShelfId != null)
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        // Colonne in base allo spazio disponibile, non un
                        // numero fisso: su telefono restano 2, su una
                        // finestra desktop più larga se ne aggiungono altre.
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.6,
                            ),
                        itemCount: visibleBooks.length,
                        itemBuilder: (context, index) {
                          final book = visibleBooks[index];
                          return _LibraryGridTile(
                            key: ValueKey(book.id),
                            book: book,
                          );
                        },
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text(l10n.libraryErrorMessage('$error'))),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final importBook = ref.read(importBookUseCaseProvider);
          final book = await importBook(shelfId: _selectedShelfId);
          if (book == null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.importCancelledMessage)),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.importBook),
      ),
    );
  }
}

class _LibraryGridTile extends ConsumerWidget {
  final Book book;
  const _LibraryGridTile({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(readingProgressProvider(book.id));
    final percentage = (progressAsync.valueOrNull?.percentage ?? 0).clamp(
      0.0,
      1.0,
    );

    Shelf? shelf;
    if (book.shelfId != null) {
      for (final candidate
          in ref.watch(shelvesProvider).valueOrNull ?? const []) {
        if (candidate.id == book.shelfId) {
          shelf = candidate;
          break;
        }
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => ReaderScreen(book: book))),
      onLongPress: () => _showBookActions(context, ref, book),
      // Click destro del mouse su desktop = pressione prolungata su mobile.
      onSecondaryTap: () => _showBookActions(context, ref, book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CoverImage(book: book),
                  if (shelf != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: shelf.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Icon(
                          shelf.icon.data,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (percentage > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 4,
                        backgroundColor: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            book.format.name.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Future<void> _showBookActions(
    BuildContext context,
    WidgetRef ref,
    Book book,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showModalBottomSheet<_BookAction>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.rename),
              onTap: () => Navigator.of(sheetContext).pop(_BookAction.rename),
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move_outlined),
              title: Text(l10n.moveToShelf),
              onTap: () => Navigator.of(sheetContext).pop(_BookAction.move),
            ),
            ListTile(
              leading: const Icon(Icons.query_stats_outlined),
              title: Text(l10n.statsAction),
              onTap: () => Navigator.of(sheetContext).pop(_BookAction.stats),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(
                l10n.delete,
                style: TextStyle(
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
              ),
              onTap: () => Navigator.of(sheetContext).pop(_BookAction.delete),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || action == null) return;
    await settleAfterOverlayClose();
    if (!context.mounted) return;
    switch (action) {
      case _BookAction.rename:
        await _renameBook(context, ref, book);
      case _BookAction.move:
        await _moveToShelf(context, ref, book);
      case _BookAction.stats:
        await showBookStatsSheet(context, book);
      case _BookAction.delete:
        await _confirmDelete(context, ref, book);
    }
  }

  Future<void> _renameBook(
    BuildContext context,
    WidgetRef ref,
    Book book,
  ) async {
    await showRenameBookSheet(
      context,
      currentTitle: book.title,
      onSave: (newTitle) async {
        if (newTitle != book.title) {
          await ref.read(bookRepositoryProvider).rename(book.id, newTitle);
        }
      },
    );
  }

  Future<void> _moveToShelf(
    BuildContext context,
    WidgetRef ref,
    Book book,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final shelves = ref.read(shelvesProvider).valueOrNull ?? const <Shelf>[];
    await showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.clear),
              title: Text(l10n.noShelf),
              selected: book.shelfId == null,
              onTap: () async {
                await ref
                    .read(bookRepositoryProvider)
                    .assignShelf(book.id, null);
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              },
            ),
            for (final shelf in shelves)
              ListTile(
                leading: Icon(shelf.icon.data, color: shelf.color),
                title: Text(shelf.name),
                selected: book.shelfId == shelf.id,
                onTap: () async {
                  await ref
                      .read(bookRepositoryProvider)
                      .assignShelf(book.id, shelf.id);
                  if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                },
              ),
            if (shelves.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.noShelfCreatedHint),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Book book,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteBookTitle),
        content: Text(l10n.deleteBookMessage(book.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await settleAfterOverlayClose();
      await ref.read(deleteBookUseCaseProvider)(book);
    }
  }
}

enum _BookAction { rename, move, stats, delete }

class _CoverImage extends StatelessWidget {
  final Book book;
  const _CoverImage({required this.book});

  @override
  Widget build(BuildContext context) {
    final coverPath = book.coverPath;
    if (coverPath != null && File(coverPath).existsSync()) {
      return Image.file(File(coverPath), fit: BoxFit.cover);
    }
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        switch (book.format) {
          BookFormat.epub => Icons.menu_book_outlined,
          BookFormat.pdf => Icons.picture_as_pdf_outlined,
          BookFormat.cbz || BookFormat.cbr => Icons.auto_stories_outlined,
        },
        size: 40,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  final bool isFiltered;
  const _EmptyLibrary({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              isFiltered ? l10n.emptyShelfTitle : l10n.emptyLibraryTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered ? l10n.emptyShelfHint : l10n.emptyLibraryHint,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
