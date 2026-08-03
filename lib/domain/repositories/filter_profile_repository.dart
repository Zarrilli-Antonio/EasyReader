import '../entities/filter_profile.dart';

abstract class FilterProfileRepository {
  /// Fase 1 lavora su un unico profilo globale: lo crea se non esiste ancora.
  Stream<FilterProfile> watchGlobal();
  Future<void> saveGlobal(FilterProfile profile);
}
