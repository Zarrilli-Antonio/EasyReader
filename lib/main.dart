import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/filters/dyslexia_font_asset.dart';
import 'presentation/filters/filter_providers.dart';
import 'presentation/library/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DyslexiaFontAsset.preload();
  runApp(const ProviderScope(child: EasyReaderApp()));
}

/// Scritto a mano invece di `ColorScheme.fromSeed(seedColor: Colors.grey)`:
/// l'algoritmo HCT di Material 3 lascia comunque una leggera dominante
/// bluastra anche partendo da un grigio puro, percettibile proprio
/// sull'interfaccia (non sul contenuto del libro, già desaturato a parte).
/// Qui invece ogni colore è un grigio neutro vero (R=G=B).
const _eInkColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF404040),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD6D6D6),
  onPrimaryContainer: Color(0xFF1A1A1A),
  secondary: Color(0xFF5C5C5C),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE0E0E0),
  onSecondaryContainer: Color(0xFF1A1A1A),
  tertiary: Color(0xFF4D4D4D),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD9D9D9),
  onTertiaryContainer: Color(0xFF1A1A1A),
  error: Color(0xFF3D3D3D),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFD6D6D6),
  onErrorContainer: Color(0xFF1A1A1A),
  surface: Color(0xFFF7F7F5),
  onSurface: Color(0xFF1A1A1A),
  surfaceDim: Color(0xFFD9D9D7),
  surfaceBright: Color(0xFFF7F7F5),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  surfaceContainerLow: Color(0xFFF0F0EE),
  surfaceContainer: Color(0xFFEBEBEB),
  surfaceContainerHigh: Color(0xFFE6E6E6),
  surfaceContainerHighest: Color(0xFFE0E0E0),
  onSurfaceVariant: Color(0xFF444444),
  outline: Color(0xFF757575),
  outlineVariant: Color(0xFFC4C4C4),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF2E2E2E),
  onInverseSurface: Color(0xFFF5F5F5),
  inversePrimary: Color(0xFFD6D6D6),
  surfaceTint: Color(0xFF404040),
);

class EasyReaderApp extends ConsumerWidget {
  const EasyReaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Con la modalità e-reader attiva, il tema di tutta l'app (non solo il
    // lettore) passa a uno schema neutro/grigio: le pagine del libro sono
    // già desaturate dai filtri del lettore, ma senza questo anche libreria,
    // impostazioni e dialoghi resterebbero colorati, rompendo l'effetto.
    final eInkModeEnabled =
        ref.watch(activeFilterProvider).valueOrNull?.eInkModeEnabled ?? false;

    return MaterialApp(
      title: 'EasyReader',
      theme: ThemeData(
        colorScheme: eInkModeEnabled
            ? _eInkColorScheme
            : ColorScheme.fromSeed(seedColor: const Color(0xFF9C6A24)),
      ),
      home: const LibraryScreen(),
    );
  }
}
