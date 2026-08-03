import '../entities/reading_progress.dart';

abstract class ReadingProgressRepository {
  Stream<ReadingProgress?> watch(String bookId);
  Future<void> save(ReadingProgress progress);
  Future<void> deleteFor(String bookId);
}
