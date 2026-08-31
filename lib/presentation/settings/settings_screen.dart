import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filters/filter_providers.dart';

/// Impostazioni globali dell'app: qui vivono la modalità e-reader (che
/// cambia il tema di tutta l'app, non solo la pagina in lettura) e tutti i
/// filtri "da impostare una volta" — colore pagina, filtro carta, filtro
/// luce blu, overlay colorato, font per dislessia. Gli slider per la
/// regolazione rapida mentre si legge restano invece nel pannello del
/// lettore (`FilterPanel`).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: filterAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text('Aspetto', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Modalità e-reader'),
              subtitle: const Text(
                'Tutta l\'app diventa in scala di grigi, come lo schermo '
                'di un e-reader',
              ),
              value: profile.eInkModeEnabled,
              onChanged: (value) {
                notifier.preview((p) => p.copyWith(eInkModeEnabled: value));
                notifier.commit();
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Filtri avanzati',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Per la regolazione rapida mentre leggi, usa gli slider nel '
              'pannello filtri del libro.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            const _SectionLabel('Colore pagina (EPUB)'),
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
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Font per dislessia (EPUB)'),
              value: profile.useDyslexiaFont,
              onChanged: (value) {
                notifier.preview((p) => p.copyWith(useDyslexiaFont: value));
                notifier.commit();
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Filtro carta'),
              value: profile.paperFilterEnabled,
              onChanged: (value) {
                notifier.preview((p) => p.copyWith(paperFilterEnabled: value));
                notifier.commit();
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Filtro luce blu'),
              value: profile.blueLightFilterEnabled,
              onChanged: (value) {
                notifier.preview(
                  (p) => p.copyWith(blueLightFilterEnabled: value),
                );
                notifier.commit();
              },
            ),
            const SizedBox(height: 12),
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
                onChanged: (value) =>
                    notifier.preview((p) => p.copyWith(overlayOpacity: value)),
                onChangeEnd: (_) => notifier.commit(),
              ),
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Errore filtri: $error')),
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
