import 'dart:convert';

import 'package:flutter/services.dart';

/// Carica e cache-a in base64 il font OpenDyslexic, per poterlo iniettare
/// come `@font-face` nella WebView dell'EPUB (che non ha accesso ai font
/// nativi di Flutter). Va precaricato una sola volta all'avvio dell'app:
/// caricare/decodificare ~280KB ogni volta che si apre un profilo filtro
/// sarebbe uno spreco inutile.
class DyslexiaFontAsset {
  static String? _regularBase64;
  static String? _boldBase64;

  static bool get isReady => _regularBase64 != null && _boldBase64 != null;

  static Future<void> preload() async {
    if (isReady) return;
    final regular = await rootBundle.load(
      'assets/fonts/OpenDyslexic-Regular.ttf',
    );
    final bold = await rootBundle.load('assets/fonts/OpenDyslexic-Bold.ttf');
    _regularBase64 = base64Encode(regular.buffer.asUint8List());
    _boldBase64 = base64Encode(bold.buffer.asUint8List());
  }

  /// Due dichiarazioni `@font-face` (normale e bold) da iniettare nel CSS
  /// dell'EPUB. Le chiavi della mappa devono essere diverse fra loro (una
  /// mappa Dart non può avere due chiavi uguali), ma il testo prodotto è
  /// comunque `@font-face{...}` valido in entrambi i casi: lo spazio finale
  /// nella seconda chiave è ignorato dal parser CSS.
  static Map<String, Map<String, String>>? fontFaceRules() {
    if (!isReady) return null;
    return {
      '@font-face': {
        'font-family': "'OpenDyslexic'",
        'font-weight': 'normal',
        'src':
            "url(data:font/truetype;base64,$_regularBase64) format('truetype')",
      },
      '@font-face ': {
        'font-family': "'OpenDyslexic'",
        'font-weight': 'bold',
        'src': "url(data:font/truetype;base64,$_boldBase64) format('truetype')",
      },
    };
  }
}
