import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';

import '../../domain/entities/filter_profile.dart';

/// Percorso A dello schema di progetto: colore pagina e leggibilità del testo
/// EPUB passano dal tema/CSS del motore di rendering, perché richiedono un
/// vero reflow del contenuto (non ottenibile con un overlay Flutter sopra
/// una WebView opaca).
EpubTheme buildEpubTheme(FilterProfile profile) {
  return EpubTheme.custom(
    backgroundDecoration: BoxDecoration(color: profile.backgroundColor),
    foregroundColor: _readableForeground(profile.backgroundColor),
  );
}

Color _readableForeground(Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Colors.white
      : Colors.black;
}
