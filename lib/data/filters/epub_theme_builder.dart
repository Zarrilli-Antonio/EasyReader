import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';

import '../../domain/entities/filter_profile.dart';
import 'dyslexia_font_asset.dart';

/// Percorso A dello schema di progetto: colore pagina e leggibilità del testo
/// EPUB passano dal tema/CSS del motore di rendering, perché richiedono un
/// vero reflow del contenuto (non ottenibile con un overlay Flutter sopra
/// una WebView opaca).
EpubTheme buildEpubTheme(FilterProfile profile) {
  final customCss = <String, dynamic>{
    'body': {'line-height': '${profile.lineHeight}'},
    'p': {'line-height': '${profile.lineHeight}'},
  };

  if (profile.useDyslexiaFont) {
    final fontFaceRules = DyslexiaFontAsset.fontFaceRules();
    if (fontFaceRules != null) {
      customCss.addAll(fontFaceRules);
      // !important perché molti EPUB impostano il proprio font-family
      // direttamente su paragrafi/titoli, con una specificità che altrimenti
      // vincerebbe sulla nostra regola su "body".
      const dyslexiaSelectors =
          'body, p, li, span, div, h1, h2, h3, h4, h5, h6, blockquote';
      customCss[dyslexiaSelectors] = {
        'font-family': "'OpenDyslexic', sans-serif !important",
      };
    }
  }

  return EpubTheme.custom(
    backgroundDecoration: BoxDecoration(color: profile.backgroundColor),
    foregroundColor: _readableForeground(profile.backgroundColor),
    customCss: customCss,
  );
}

Color _readableForeground(Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Colors.white
      : Colors.black;
}
