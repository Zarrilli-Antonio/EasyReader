import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/book.dart';
import '../common/duration_format.dart';
import '../common/providers.dart';

Future<void> showBookStatsSheet(BuildContext context, Book book) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _BookStatsSheet(book: book),
  );
}

class _BookStatsSheet extends ConsumerWidget {
  final Book book;
  const _BookStatsSheet({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(bookReadingStatsProvider(book.id));
    final progress = ref.watch(readingProgressProvider(book.id)).valueOrNull;
    final percentage = ((progress?.percentage ?? 0) * 100).round();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
              book.title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            _StatRow(
              icon: Icons.timer_outlined,
              label: 'Tempo di lettura',
              value: stats.totalReadingTime == Duration.zero
                  ? 'Non ancora iniziato'
                  : formatReadingDuration(stats.totalReadingTime),
            ),
            _StatRow(
              icon: Icons.menu_book_outlined,
              label: 'Sessioni di lettura',
              value: '${stats.sessionCount}',
            ),
            _StatRow(
              icon: Icons.donut_large_outlined,
              label: 'Letto',
              value: '$percentage%',
            ),
            _StatRow(
              icon: Icons.calendar_today_outlined,
              label: 'Aggiunto il',
              value: _formatDate(book.addedAt),
            ),
            _StatRow(
              icon: Icons.history_outlined,
              label: 'Ultima lettura',
              value: book.lastOpenedAt != null
                  ? _formatDate(book.lastOpenedAt!)
                  : 'Mai',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
