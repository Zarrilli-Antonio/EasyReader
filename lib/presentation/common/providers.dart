import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/covers/cover_extractor.dart';
import '../../data/local/database/app_database.dart';
import '../../data/repositories/drift_book_repository.dart';
import '../../data/repositories/drift_filter_profile_repository.dart';
import '../../data/repositories/drift_reading_progress_repository.dart';
import '../../data/repositories/drift_shelf_repository.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/reading_progress.dart';
import '../../domain/entities/reading_stats.dart';
import '../../domain/entities/shelf.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/repositories/cover_extractor.dart';
import '../../domain/repositories/filter_profile_repository.dart';
import '../../domain/repositories/reading_progress_repository.dart';
import '../../domain/repositories/shelf_repository.dart';
import '../../domain/usecases/delete_book_usecase.dart';
import '../../domain/usecases/delete_shelf_usecase.dart';
import '../../domain/usecases/import_book_usecase.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => DriftBookRepository(ref.watch(databaseProvider)),
);

final filterProfileRepositoryProvider = Provider<FilterProfileRepository>(
  (ref) => DriftFilterProfileRepository(ref.watch(databaseProvider)),
);

final readingProgressRepositoryProvider = Provider<ReadingProgressRepository>(
  (ref) => DriftReadingProgressRepository(ref.watch(databaseProvider)),
);

final shelfRepositoryProvider = Provider<ShelfRepository>(
  (ref) => DriftShelfRepository(ref.watch(databaseProvider)),
);

final coverExtractorProvider = Provider<CoverExtractor>(
  (ref) => ArchiveCoverExtractor(),
);

final importBookUseCaseProvider = Provider<ImportBookUseCase>(
  (ref) => ImportBookUseCase(
    ref.watch(bookRepositoryProvider),
    ref.watch(coverExtractorProvider),
  ),
);

final deleteBookUseCaseProvider = Provider<DeleteBookUseCase>(
  (ref) => DeleteBookUseCase(
    ref.watch(bookRepositoryProvider),
    ref.watch(readingProgressRepositoryProvider),
  ),
);

final deleteShelfUseCaseProvider = Provider<DeleteShelfUseCase>(
  (ref) => DeleteShelfUseCase(
    ref.watch(shelfRepositoryProvider),
    ref.watch(bookRepositoryProvider),
  ),
);

final booksProvider = StreamProvider<List<Book>>(
  (ref) => ref.watch(bookRepositoryProvider).watchAll(),
);

final shelvesProvider = StreamProvider<List<Shelf>>(
  (ref) => ref.watch(shelfRepositoryProvider).watchAll(),
);

final readingProgressProvider = StreamProvider.family<ReadingProgress?, String>(
  (ref, bookId) => ref.watch(readingProgressRepositoryProvider).watch(bookId),
);

final globalReadingStatsProvider = Provider<GlobalReadingStats>((ref) {
  final books = ref.watch(booksProvider).valueOrNull ?? const <Book>[];

  var completed = 0;
  var inProgress = 0;
  for (final book in books) {
    final percentage =
        ref.watch(readingProgressProvider(book.id)).valueOrNull?.percentage ??
        0;
    if (percentage >= 0.98) {
      completed++;
    } else if (percentage > 0) {
      inProgress++;
    }
  }

  return GlobalReadingStats(
    totalBooks: books.length,
    completedBooks: completed,
    inProgressBooks: inProgress,
  );
});
