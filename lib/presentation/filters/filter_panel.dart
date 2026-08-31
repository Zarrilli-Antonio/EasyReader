import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/book_format.dart';
import '../../l10n/app_localizations.dart';
import 'filter_providers.dart';

/// Pannello filtri del lettore: solo slider per la regolazione rapida
/// mentre si legge — dimensione testo e interlinea (solo EPUB, richiedono
/// reflow), luminosità, contrasto e temperatura colore (universali, EPUB e
/// PDF). I filtri "da impostare una volta" (colore pagina, filtro carta,
/// filtro luce blu, overlay colorato, font per dislessia, modalità
/// e-reader) vivono nelle Impostazioni globali, non qui. Ogni slider
/// aggiorna subito l'anteprima e salva solo al rilascio del gesto.
class FilterPanel extends ConsumerWidget {
  final BookFormat bookFormat;

  const FilterPanel({super.key, required this.bookFormat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filterAsync = ref.watch(activeFilterProvider);
    final notifier = ref.read(activeFilterProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: filterAsync.when(
          data: (profile) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.readingFilters,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                if (bookFormat == BookFormat.epub) ...[
                  _SectionLabel(l10n.textSizeLabel(profile.fontSize.round())),
                  Slider(
                    value: profile.fontSize,
                    min: 12,
                    max: 28,
                    divisions: 16,
                    onChanged: (value) =>
                        notifier.preview((p) => p.copyWith(fontSize: value)),
                    onChangeEnd: (_) => notifier.commit(),
                  ),
                  const SizedBox(height: 12),
                  _SectionLabel(
                    l10n.lineHeightLabel(profile.lineHeight.toStringAsFixed(1)),
                  ),
                  Slider(
                    value: profile.lineHeight,
                    min: 1.0,
                    max: 2.2,
                    divisions: 12,
                    onChanged: (value) =>
                        notifier.preview((p) => p.copyWith(lineHeight: value)),
                    onChangeEnd: (_) => notifier.commit(),
                  ),
                  const SizedBox(height: 12),
                ],
                _SectionLabel(
                  l10n.brightnessLabel(profile.brightness.toStringAsFixed(2)),
                ),
                Slider(
                  value: profile.brightness,
                  min: -0.6,
                  max: 0.6,
                  onChanged: (value) =>
                      notifier.preview((p) => p.copyWith(brightness: value)),
                  onChangeEnd: (_) => notifier.commit(),
                ),
                const SizedBox(height: 12),
                _SectionLabel(
                  l10n.contrastLabel(profile.contrast.toStringAsFixed(2)),
                ),
                Slider(
                  value: profile.contrast,
                  min: 0.5,
                  max: 1.8,
                  onChanged: (value) =>
                      notifier.preview((p) => p.copyWith(contrast: value)),
                  onChangeEnd: (_) => notifier.commit(),
                ),
                const SizedBox(height: 12),
                _SectionLabel(
                  l10n.colorTemperatureLabel(
                    profile.colorTemperature > 0
                        ? l10n.warm
                        : profile.colorTemperature < 0
                        ? l10n.cool
                        : l10n.neutral,
                  ),
                ),
                Slider(
                  value: profile.colorTemperature,
                  min: -1,
                  max: 1,
                  onChanged: (value) => notifier.preview(
                    (p) => p.copyWith(colorTemperature: value),
                  ),
                  onChangeEnd: (_) => notifier.commit(),
                ),
              ],
            ),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text(l10n.filtersErrorMessage('$error')),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(letterSpacing: 0.6),
    );
  }
}
