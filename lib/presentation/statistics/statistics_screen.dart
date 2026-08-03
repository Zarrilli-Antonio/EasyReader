import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/duration_format.dart';
import '../common/providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(globalReadingStatsProvider);
    final ranked = ref.watch(booksRankedByReadingTimeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiche di lettura')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _StatCard(
                icon: Icons.menu_book_outlined,
                label: 'Libri in libreria',
                value: '${stats.totalBooks}',
              ),
              _StatCard(
                icon: Icons.task_alt_outlined,
                label: 'Completati',
                value: '${stats.completedBooks}',
              ),
              _StatCard(
                icon: Icons.auto_stories_outlined,
                label: 'In lettura',
                value: '${stats.inProgressBooks}',
              ),
              _StatCard(
                icon: Icons.timer_outlined,
                label: 'Tempo di lettura totale',
                value: stats.totalReadingTime == Duration.zero
                    ? '—'
                    : formatReadingDuration(stats.totalReadingTime),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (ranked.isNotEmpty) ...[
            Text('Più letti', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...ranked.take(5).map((entry) {
              final (book, bookStats) = entry;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text(book.format.name.substring(0, 1).toUpperCase()),
                ),
                title: Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  formatReadingDuration(bookStats.totalReadingTime),
                ),
              );
            }),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'Leggi un libro per iniziare a vedere qui le tue statistiche.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
