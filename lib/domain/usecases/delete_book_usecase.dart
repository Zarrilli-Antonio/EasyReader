import 'dart:io';

import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../repositories/reading_progress_repository.dart';
import '../repositories/reading_session_repository.dart';

/// Rimuove un libro dalla libreria: record in libreria, progresso di
/// lettura e sessioni associate, il file copiato nello storage privato
/// dell'app e la relativa copertina estratta.
class DeleteBookUseCase {
  final BookRepository _bookRepository;
  final ReadingProgressRepository _progressRepository;
  final ReadingSessionRepository _sessionRepository;

  DeleteBookUseCase(
    this._bookRepository,
    this._progressRepository,
    this._sessionRepository,
  );

  Future<void> call(Book book) async {
    await _bookRepository.delete(book.id);
    await _progressRepository.deleteFor(book.id);
    await _sessionRepository.deleteForBook(book.id);
    final file = File(book.filePath);
    if (await file.exists()) {
      await file.delete();
    }
    final coverPath = book.coverPath;
    if (coverPath != null) {
      final coverFile = File(coverPath);
      if (await coverFile.exists()) {
        await coverFile.delete();
      }
    }
  }
}
