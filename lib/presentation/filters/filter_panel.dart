import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/book_format.dart';
import 'filter_providers.dart';

/// Pannello filtri di Fase 1: colore pagina, dimensione testo (solo EPUB,
/// richiedono reflow), overlay colorato e luminosità (universali). Ogni
/// slider aggiorna subito l'anteprima e salva solo al rilascio del gesto.
class FilterPanel extends ConsumerWidget {
  final BookFormat bookFormat;

  const FilterPanel({super.key, required this.bookFormat});

  static const _backgroundPresets = <String, Color>{
    'Giorno': Colors.white,
    'Seppia': Color(0xFFECDCB8),
    'Notte': Color(0xFF14161A),
  };

  static const _overlayPresets = <String, Color>{
    'Giallo': Color(0xFFFFF176),
    'Verde': Color(0xFFAED581),
    'Azzurro': Color(0xFF81D4FA),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterAsync = ref.watch(activeFilterProvider);
    final notifier = ref.read(activeFilterProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: filterAsync.when(
          data: (profile) => Column(
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
                'Filtri di lettura',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              if (bookFormat == BookFormat.epub) ...[
                const _SectionLabel('Colore pagina'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _backgroundPresets.entries.map((entry) {
                    final selected = profile.backgroundColor == entry.value;
                    return ChoiceChip(
                      label: Text(entry.key),
                      selected: selected,
                      onSelected: (_) {
                        notifier.preview(
                          (p) => p.copyWith(backgroundColor: entry.value),
                        );
                        notifier.commit();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _SectionLabel('Dimensione testo · ${profile.fontSize.round()}'),
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
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel('Filtro carta'),
                  Switch(
                    value: profile.paperFilterEnabled,
                    onChanged: (value) {
                      notifier.preview(
                        (p) => p.copyWith(paperFilterEnabled: value),
                      );
                      notifier.commit();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const _SectionLabel('Overlay colorato'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Nessuno'),
                    selected: profile.overlayOpacity == 0,
                    onSelected: (_) {
                      notifier.preview((p) => p.copyWith(overlayOpacity: 0));
                      notifier.commit();
                    },
                  ),
                  ..._overlayPresets.entries.map((entry) {
                    final selected =
                        profile.overlayColor == entry.value &&
                        profile.overlayOpacity > 0;
                    return ChoiceChip(
                      label: Text(entry.key),
                      selected: selected,
                      onSelected: (_) {
                        notifier.preview(
                          (p) => p.copyWith(
                            overlayColor: entry.value,
                            overlayOpacity: p.overlayOpacity > 0
                                ? p.overlayOpacity
                                : 0.15,
                          ),
                        );
                        notifier.commit();
                      },
                    );
                  }),
                ],
              ),
              if (profile.overlayOpacity > 0) ...[
                const SizedBox(height: 12),
                _SectionLabel(
                  'Intensità overlay · ${(profile.overlayOpacity * 100).round()}%',
                ),
                Slider(
                  value: profile.overlayOpacity,
                  min: 0.05,
                  max: 0.5,
                  onChanged: (value) => notifier.preview(
                    (p) => p.copyWith(overlayOpacity: value),
                  ),
                  onChangeEnd: (_) => notifier.commit(),
                ),
              ],
              const SizedBox(height: 12),
              _SectionLabel(
                'Luminosità · ${profile.brightness.toStringAsFixed(2)}',
              ),
              Slider(
                value: profile.brightness,
                min: -0.6,
                max: 0.6,
                onChanged: (value) =>
                    notifier.preview((p) => p.copyWith(brightness: value)),
                onChangeEnd: (_) => notifier.commit(),
              ),
            ],
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text('Errore filtri: $error'),
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
