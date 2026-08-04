/// Statistiche di lettura aggregate su tutta la libreria, calcolate dalla
/// percentuale letta di ciascun libro.
class GlobalReadingStats {
  final int totalBooks;
  final int completedBooks;
  final int inProgressBooks;

  const GlobalReadingStats({
    required this.totalBooks,
    required this.completedBooks,
    required this.inProgressBooks,
  });
}
