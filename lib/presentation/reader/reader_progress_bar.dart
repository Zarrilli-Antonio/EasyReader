import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/providers.dart';

/// Barra di avanzamento persistente in fondo al reader, comune a EPUB e PDF
/// (il PDF ha già un indicatore nativo di Syncfusion durante lo scroll, ma
/// solo temporaneo: questa resta sempre visibile). Per l'EPUB aggiunge anche
/// le frecce per cambiare pagina, per chi non usa lo swipe.
class ReaderProgressBar extends ConsumerWidget {
  final String bookId;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ReaderProgressBar({
    super.key,
    required this.bookId,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(readingProgressProvider(bookId)).valueOrNull;
    final percentage = (progress?.percentage ?? 0).clamp(0.0, 1.0);
    final totalUnits = progress?.totalUnits;
    // "Pagina X di Y" ha senso solo per i formati a layout fisso (PDF): per
    // l'EPUB il motore di lettura non espone un conteggio pagine reale.
    final label = totalUnits != null
        ? 'Pagina ${progress!.position} di $totalUnits · ${(percentage * 100).round()}%'
        : '${(percentage * 100).round()}%';

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPrevious,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(label, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
