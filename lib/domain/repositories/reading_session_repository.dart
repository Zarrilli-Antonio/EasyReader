import '../entities/reading_session.dart';

abstract class ReadingSessionRepository {
  Future<void> record(ReadingSession session);
  Stream<List<ReadingSession>> watchForBook(String bookId);
  Stream<List<ReadingSession>> watchAll();
  Future<void> deleteForBook(String bookId);
}
