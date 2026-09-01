import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_controller.dart';

const _discoverBooksUnlockedKey = 'discover_books_unlocked';

/// Se la sezione "Scopri libri online" è visibile in libreria: nascosta di
/// default, sbloccabile toccando 10 volte di fila il nome e la versione
/// dell'app in fondo alle Impostazioni (vedi `SettingsScreen`) — lo stesso
/// gesto, ripetuto a sblocco già attivo, la nasconde di nuovo.
class DiscoverBooksUnlockController extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  DiscoverBooksUnlockController(this._prefs)
    : super(_prefs.getBool(_discoverBooksUnlockedKey) ?? false);

  Future<void> toggle() async {
    state = !state;
    await _prefs.setBool(_discoverBooksUnlockedKey, state);
  }
}

final discoverBooksUnlockedProvider =
    StateNotifierProvider<DiscoverBooksUnlockController, bool>(
      (ref) =>
          DiscoverBooksUnlockController(ref.watch(sharedPreferencesProvider)),
    );
