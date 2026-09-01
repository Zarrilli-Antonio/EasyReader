/// Un solo ritentativo per le chiamate a servizi online di terze parti che
/// si sono dimostrati inaffidabili (Gutendex risponde in meno di un decimo
/// di secondo per una ricerca già in cache, ma può non rispondere affatto
/// per svariati secondi su una non ancora cacheata) — un secondo tentativo
/// spesso basta perché nel frattempo la richiesta va a buon fine.
Future<T> withRetry<T>(Future<T> Function() action) async {
  try {
    return await action();
  } catch (_) {
    return await action();
  }
}
