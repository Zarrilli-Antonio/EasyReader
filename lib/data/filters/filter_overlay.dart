import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/entities/filter_profile.dart';

/// Applica la parte "universale" del motore filtri — filtro carta, overlay
/// colorato e luminosità — sopra qualunque contenuto già renderizzato, che
/// sia la WebView dell'EPUB o la pagina PDF. Percorso B dello schema di
/// progetto: stesso widget per entrambi i formati, nessuna logica duplicata.
class FilterOverlay extends StatelessWidget {
  final FilterProfile profile;
  final Widget child;

  const FilterOverlay({super.key, required this.profile, required this.child});

  /// Tinta calda e tenue del filtro carta (~8% di opacità).
  static const _paperTintColor = Color(0x14F3E9D2);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(_buildColorMatrix(profile)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (profile.paperFilterEnabled) ...[
            const IgnorePointer(child: ColoredBox(color: _paperTintColor)),
            const IgnorePointer(
              child: CustomPaint(painter: _PaperGrainPainter()),
            ),
          ],
          if (profile.overlayOpacity > 0)
            IgnorePointer(
              child: ColoredBox(
                color: profile.overlayColor.withValues(
                  alpha: profile.overlayOpacity,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Combina luminosità, contrasto, temperatura colore e filtro luce blu in
  /// un'unica matrice, così tutti gli effetti si applicano insieme in un
  /// solo passaggio invece di annidare più `ColorFiltered` (più costoso e
  /// con un ordine di composizione meno prevedibile).
  ///
  /// - luminosità: -1 (più scuro) .. 1 (più chiaro), 0 = nessun effetto
  /// - contrasto: 0.5 (basso) .. 1.8 (alto), 1 = nessun effetto
  /// - temperatura: -1 (freddo/blu) .. 1 (caldo/ambra), 0 = nessun effetto
  /// - filtro luce blu: se attivo, riduce anche la trasmissione del canale
  ///   blu (non solo un'aggiunta di ambra come la temperatura), lo stesso
  ///   principio usato dai filtri per la luce blu serale
  List<double> _buildColorMatrix(FilterProfile profile) {
    final brightnessOffset = profile.brightness.clamp(-1.0, 1.0) * 255;
    final contrastFactor = profile.contrast.clamp(0.5, 1.8);
    final contrastOffset = (1 - contrastFactor) * 127.5;
    final warmOffset = profile.colorTemperature.clamp(-1.0, 1.0) * 40;
    final blueLightFactor = profile.blueLightFilterEnabled ? 0.7 : 1.0;

    final redOffset = contrastOffset + brightnessOffset + warmOffset;
    final greenOffset = contrastOffset + brightnessOffset;
    final blueOffset = contrastOffset + brightnessOffset - warmOffset;

    return <double>[
      contrastFactor, 0, 0, 0, redOffset, //
      0, contrastFactor, 0, 0, greenOffset, //
      0, 0, contrastFactor * blueLightFactor, 0, blueOffset, //
      0, 0, 0, 1, 0, //
    ];
  }
}

/// Texture statica e leggera che simula la grana della carta. I punti sono
/// generati una sola volta con un seed fisso: restano identici a ogni
/// rebuild, altrimenti sembrerebbero un rumore animato invece di una carta.
final List<Offset> _paperGrainSpecks = _generatePaperGrainSpecks();

List<Offset> _generatePaperGrainSpecks() {
  final random = Random(7);
  return List.generate(
    500,
    (_) => Offset(random.nextDouble(), random.nextDouble()),
  );
}

class _PaperGrainPainter extends CustomPainter {
  const _PaperGrainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.035);
    for (final speck in _paperGrainSpecks) {
      canvas.drawCircle(
        Offset(speck.dx * size.width, speck.dy * size.height),
        0.6,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PaperGrainPainter oldDelegate) => false;
}
