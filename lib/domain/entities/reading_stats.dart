/// Statistiche di lettura calcolate per un singolo libro a partire dalle
/// sue sessioni registrate.
class BookReadingStats {
  final Duration totalReadingTime;
  final int sessionCount;

  const BookReadingStats({
    required this.totalReadingTime,
    required this.sessionCount,
  });

  static const empty = BookReadingStats(
    totalReadingTime: Duration.zero,
    sessionCount: 0,
  );
}

/// Statistiche di lettura aggregate su tutta la libreria.
class GlobalReadingStats {
  final int totalBooks;
  final int completedBooks;
  final int inProgressBooks;
  final Duration totalReadingTime;

  const GlobalReadingStats({
    required this.totalBooks,
    required this.completedBooks,
    required this.inProgressBooks,
    required this.totalReadingTime,
  });
}
