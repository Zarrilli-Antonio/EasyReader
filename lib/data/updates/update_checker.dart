import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class UpdateInfo {
  final String version;
  final String releaseUrl;

  const UpdateInfo({required this.version, required this.releaseUrl});
}

/// Interroga le GitHub Releases del progetto per capire se è disponibile una
/// versione più recente di quella installata. Nessuna azione automatica:
/// solo un controllo silenzioso, best-effort, che non deve mai bloccare
/// l'avvio dell'app né mostrare errori se offline o se l'API non risponde.
class UpdateChecker {
  static const _repo = 'Zarrilli-Antonio/EasyReader';

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final response = await http
          .get(
            Uri.https('api.github.com', '/repos/$_repo/releases/latest'),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = json['tag_name'];
      final releaseUrl = json['html_url'];
      if (tagName is! String || releaseUrl is! String) return null;

      final latestVersion = tagName.replaceFirst(RegExp('^v'), '');
      final currentVersion = (await PackageInfo.fromPlatform()).version;

      if (!_isNewer(latestVersion, currentVersion)) return null;
      return UpdateInfo(version: latestVersion, releaseUrl: releaseUrl);
    } catch (_) {
      return null;
    }
  }

  /// Confronto semver semplice (major.minor.patch), senza pacchetti esterni:
  /// sufficiente per il proprio schema di versioning, senza pre-release tag.
  bool _isNewer(String remote, String local) {
    final remoteParts = _parseVersion(remote);
    final localParts = _parseVersion(local);
    for (var i = 0; i < 3; i++) {
      if (remoteParts[i] != localParts[i]) {
        return remoteParts[i] > localParts[i];
      }
    }
    return false;
  }

  List<int> _parseVersion(String version) {
    final parts = version.split('+').first.split('.');
    return List.generate(3, (i) {
      if (i >= parts.length) return 0;
      return int.tryParse(parts[i]) ?? 0;
    });
  }
}
