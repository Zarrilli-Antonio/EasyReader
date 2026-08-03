/// Un intervallo di tempo in cui l'utente ha tenuto aperto un libro nel
/// reader, usato per calcolare le statistiche di lettura (tempo totale,
/// numero di sessioni) sia per singolo libro che in totale.
class ReadingSession {
  final String id;
  final String bookId;
  final DateTime startedAt;
  final DateTime endedAt;

  const ReadingSession({
    required this.id,
    required this.bookId,
    required this.startedAt,
    required this.endedAt,
  });

  Duration get duration => endedAt.difference(startedAt);
}
