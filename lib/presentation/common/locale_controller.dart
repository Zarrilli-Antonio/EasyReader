import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

/// Lingua scelta dall'utente, persistita in `shared_preferences`. `null`
/// significa "segui la lingua del sistema" — `MaterialApp.locale` accetta
/// `null` con lo stesso significato, quindi non serve tradurlo qui.
class LocaleController extends StateNotifier<Locale?> {
  final SharedPreferences _prefs;

  LocaleController(this._prefs) : super(_readInitial(_prefs));

  static Locale? _readInitial(SharedPreferences prefs) {
    final code = prefs.getString(_localeKey);
    return code == null ? null : Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.languageCode);
    }
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider deve essere sovrascritto in main() con '
    'l\'istanza già inizializzata prima di runApp',
  );
});

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale?>(
      (ref) => LocaleController(ref.watch(sharedPreferencesProvider)),
    );
