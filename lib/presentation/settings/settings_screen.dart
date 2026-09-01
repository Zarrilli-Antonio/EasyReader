import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../l10n/app_localizations.dart';
import '../common/discover_books_unlock_controller.dart';
import '../common/locale_controller.dart';
import '../filters/filter_providers.dart';

/// Impostazioni globali dell'app: qui vivono la lingua, la modalità
/// e-reader (che cambia il tema di tutta l'app, non solo la pagina in
/// lettura) e tutti i filtri "da impostare una volta" — colore pagina,
/// filtro carta, filtro luce blu, overlay colorato, font per dislessia. Gli
/// slider per la regolazione rapida mentre si legge restano invece nel
/// pannello del lettore (`FilterPanel`).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _backgroundPresetKeys = <String, Color>{
    'presetDay': Colors.white,
    'presetSepia': Color(0xFFECDCB8),
    'presetNight': Color(0xFF14161A),
  };

  static const _overlayPresetKeys = <String, Color>{
    'overlayYellow': Color(0xFFFFF176),
    'overlayGreen': Color(0xFFAED581),
    'overlayBlue': Color(0xFF81D4FA),
  };

  String _label(AppLocalizations l10n, String key) => switch (key) {
    'presetDay' => l10n.presetDay,
    'presetSepia' => l10n.presetSepia,
    'presetNight' => l10n.presetNight,
    'overlayYellow' => l10n.overlayYellow,
    'overlayGreen' => l10n.overlayGreen,
    'overlayBlue' => l10n.overlayBlue,
    _ => key,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filterAsync = ref.watch(activeFilterProvider);
    final notifier = ref.read(activeFilterProvider.notifier);
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: filterAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.language),
              trailing: DropdownButton<Locale?>(
                value: locale,
                onChanged: (value) => ref
                    .read(localeControllerProvider.notifier)
                    .setLocale(value),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.languageSystem),
                  ),
                  DropdownMenuItem(
                    value: const Locale('it'),
                    child: Text(l10n.languageItalian),
                  ),
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text(l10n.languageEnglish),
                  ),
                  DropdownMenuItem(
                    value: const Locale('es'),
                    child: Text(l10n.languageSpanish),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.appearance,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.eReaderMode),
              subtitle: Text(l10n.eReaderModeSubtitle),
              value: profile.eInkModeEnabled,
              onChanged: (value) {
                notifier.preview((p) => p.copyWith(eInkModeEnabled: value));
                notifier.commit();
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.advancedFilters,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.advancedFiltersHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            _SectionLabel(l10n.pageColorLabel),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _backgroundPresetKeys.entries.map((entry) {
                final selected = profile.backgroundColor == entry.value;
                return ChoiceChip(
                  label: Text(_label(l10n, entry.key)),
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
              title: Text(l10n.dyslexiaFont),
              value: profile.useDyslexiaFont,
              onChanged: (value) {
                notifier.preview((p) => p.copyWith(useDyslexiaFont: value));
                notifier.commit();
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.paperFilter),
              value: profile.paperFilterEnabled,
              onChanged: (value) {
                notifier.preview((p) => p.copyWith(paperFilterEnabled: value));
                notifier.commit();
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.blueLightFilter),
              value: profile.blueLightFilterEnabled,
              onChanged: (value) {
                notifier.preview(
                  (p) => p.copyWith(blueLightFilterEnabled: value),
                );
                notifier.commit();
              },
            ),
            const SizedBox(height: 12),
            _SectionLabel(l10n.colorOverlay),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.none),
                  selected: profile.overlayOpacity == 0,
                  onSelected: (_) {
                    notifier.preview((p) => p.copyWith(overlayOpacity: 0));
                    notifier.commit();
                  },
                ),
                ..._overlayPresetKeys.entries.map((entry) {
                  final selected =
                      profile.overlayColor == entry.value &&
                      profile.overlayOpacity > 0;
                  return ChoiceChip(
                    label: Text(_label(l10n, entry.key)),
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
                l10n.overlayIntensityLabel(
                  (profile.overlayOpacity * 100).round(),
                ),
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
            const SizedBox(height: 32),
            const _AppVersionFooter(),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(l10n.filtersErrorMessage('$error'))),
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

/// Nome e versione dell'app: toccarlo 10 volte di fila (entro pochi secondi
/// l'una dall'altra, altrimenti il conteggio riparte da zero) attiva o
/// disattiva la sezione "Scopri libri online" — nascosta di default perché
/// è una funzione sperimentale, non pensata per l'uso quotidiano.
class _AppVersionFooter extends ConsumerStatefulWidget {
  const _AppVersionFooter();

  @override
  ConsumerState<_AppVersionFooter> createState() => _AppVersionFooterState();
}

class _AppVersionFooterState extends ConsumerState<_AppVersionFooter> {
  static const _tapsRequired = 10;
  static const _tapTimeout = Duration(seconds: 2);

  PackageInfo? _packageInfo;
  int _tapCount = 0;
  DateTime? _lastTapAt;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _packageInfo = info);
    });
  }

  Future<void> _handleTap() async {
    final now = DateTime.now();
    if (_lastTapAt == null || now.difference(_lastTapAt!) > _tapTimeout) {
      _tapCount = 0;
    }
    _lastTapAt = now;
    _tapCount++;
    if (_tapCount < _tapsRequired) return;
    _tapCount = 0;

    await ref.read(discoverBooksUnlockedProvider.notifier).toggle();
    if (!mounted) return;
    final unlocked = ref.read(discoverBooksUnlockedProvider);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          unlocked
              ? l10n.discoverBooksUnlockedMessage
              : l10n.discoverBooksHiddenMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _packageInfo;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            info == null ? '' : '${info.appName} v${info.version}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
