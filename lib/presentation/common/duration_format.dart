/// Formatta una durata in modo leggibile per le statistiche di lettura,
/// es. "2h 15min", "45min", "meno di 1 min".
String formatReadingDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0) {
    return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
  }
  if (minutes > 0) {
    return '$minutes min';
  }
  return 'meno di 1 min';
}
