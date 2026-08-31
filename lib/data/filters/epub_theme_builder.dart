import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';

import '../../domain/entities/filter_profile.dart';
import 'dyslexia_font_asset.dart';

/// Percorso A dello schema di progetto: colore pagina, leggibilità del testo
/// e — per necessità, non per scelta — anche luminosità/contrasto/temperatura
/// colore/filtro luce blu/modalità e-reader passano dal tema/CSS del motore
/// di rendering invece che dall'overlay Flutter (`FilterOverlay`): la WebView
/// è una platform view nativa, e il `ColorFiltered` di Flutter non altera i
/// pixel già disegnati da una platform view — per questo, prima di questo
/// fix, quei filtri si vedevano sull'interfaccia (barra, progresso, testo
/// Flutter) ma non sulla pagina del libro vera e propria.
EpubTheme buildEpubTheme(FilterProfile profile) {
  final customCss = <String, dynamic>{
    'body': {'line-height': '${profile.lineHeight}'},
    'p': {'line-height': '${profile.lineHeight}'},
    'html': {'filter': _buildCssFilter(profile)},
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

/// Traduce luminosità/contrasto/temperatura/filtro luce blu/modalità
/// e-reader in una catena di funzioni CSS `filter`. Non è un'equivalenza
/// matematica esatta rispetto alla matrice colore usata per il resto
/// dell'interfaccia (le primitive CSS sono moltiplicative, quella è additiva
/// su un'unica matrice) — è un'approssimazione visiva ragionevole, che è
/// comunque l'unico modo per influenzare i pixel già disegnati dalla WebView.
String _buildCssFilter(FilterProfile profile) {
  final functions = <String>[
    'brightness(${(1 + profile.brightness.clamp(-1.0, 1.0)).toStringAsFixed(2)})',
    'contrast(${profile.contrast.clamp(0.5, 1.8).toStringAsFixed(2)})',
  ];

  if (profile.eInkModeEnabled) {
    functions.add('grayscale(1)');
  }

  final temperature = profile.colorTemperature.clamp(-1.0, 1.0);
  if (temperature > 0) {
    functions.add('sepia(${(temperature * 0.4).toStringAsFixed(2)})');
  } else if (temperature < 0) {
    functions.add('hue-rotate(${(-temperature * 15).toStringAsFixed(0)}deg)');
    functions.add('saturate(${(1 + -temperature * 0.15).toStringAsFixed(2)})');
  }

  if (profile.blueLightFilterEnabled) {
    functions.add('sepia(0.25)');
  }

  return functions.join(' ');
}
