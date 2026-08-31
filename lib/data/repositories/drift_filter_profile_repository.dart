import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/filter_profile.dart';
import '../../domain/repositories/filter_profile_repository.dart';
import '../local/database/app_database.dart';

const kGlobalProfileId = 'global-profile';

class DriftFilterProfileRepository implements FilterProfileRepository {
  final AppDatabase _db;
  DriftFilterProfileRepository(this._db);

  @override
  Stream<FilterProfile> watchGlobal() {
    final query = _db.select(_db.filterProfiles)
      ..where((t) => t.id.equals(kGlobalProfileId));
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row != null) return _toEntity(row);
      final defaults = FilterProfile.standard(id: kGlobalProfileId);
      await saveGlobal(defaults);
      return defaults;
    });
  }

  @override
  Future<void> saveGlobal(FilterProfile profile) {
    return _db
        .into(_db.filterProfiles)
        .insertOnConflictUpdate(
          FilterProfilesCompanion.insert(
            id: kGlobalProfileId,
            name: profile.name,
            backgroundColor: profile.backgroundColor.toARGB32(),
            overlayColor: profile.overlayColor.toARGB32(),
            overlayOpacity: Value(profile.overlayOpacity),
            brightness: Value(profile.brightness),
            contrast: Value(profile.contrast),
            colorTemperature: Value(profile.colorTemperature),
            fontSize: Value(profile.fontSize),
            lineHeight: Value(profile.lineHeight),
            paperFilterEnabled: Value(profile.paperFilterEnabled),
            blueLightFilterEnabled: Value(profile.blueLightFilterEnabled),
            useDyslexiaFont: Value(profile.useDyslexiaFont),
            eInkModeEnabled: Value(profile.eInkModeEnabled),
            isDefault: const Value(true),
          ),
        );
  }

  FilterProfile _toEntity(FilterProfileRow row) => FilterProfile(
    id: row.id,
    name: row.name,
    backgroundColor: Color(row.backgroundColor),
    overlayColor: Color(row.overlayColor),
    overlayOpacity: row.overlayOpacity,
    brightness: row.brightness,
    contrast: row.contrast,
    colorTemperature: row.colorTemperature,
    fontSize: row.fontSize,
    lineHeight: row.lineHeight,
    paperFilterEnabled: row.paperFilterEnabled,
    blueLightFilterEnabled: row.blueLightFilterEnabled,
    useDyslexiaFont: row.useDyslexiaFont,
    eInkModeEnabled: row.eInkModeEnabled,
    isDefault: row.isDefault,
  );
}
