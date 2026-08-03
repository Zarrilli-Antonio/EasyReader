class ReadingProgress {
  final String bookId;
  final String position;
  final double percentage;

  /// Numero totale di pagine, disponibile solo per i formati a layout
  /// fisso (PDF). L'EPUB è testo scorrevole senza un conteggio pagine
  /// fisso, quindi resta `null`.
  final int? totalUnits;
  final DateTime updatedAt;

  const ReadingProgress({
    required this.bookId,
    required this.position,
    required this.percentage,
    this.totalUnits,
    required this.updatedAt,
  });
}
