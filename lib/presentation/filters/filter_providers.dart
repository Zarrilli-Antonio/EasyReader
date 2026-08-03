import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/filter_profile.dart';
import '../../domain/repositories/filter_profile_repository.dart';
import '../common/providers.dart';

/// Stato in memoria del profilo filtro globale: si aggiorna a ogni tocco
/// dello slider per l'anteprima live, e si salva su drift solo quando il
/// gesto termina — niente scritture DB a ogni frame di trascinamento.
class ActiveFilterNotifier extends StateNotifier<AsyncValue<FilterProfile>> {
  final FilterProfileRepository _repository;
  late final StreamSubscription<FilterProfile> _subscription;

  ActiveFilterNotifier(this._repository) : super(const AsyncValue.loading()) {
    _subscription = _repository.watchGlobal().listen(
      (profile) => state = AsyncValue.data(profile),
      onError: (Object error, StackTrace stack) =>
          state = AsyncValue.error(error, stack),
    );
  }

  void preview(FilterProfile Function(FilterProfile current) transform) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(transform(current));
  }

  Future<void> commit() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _repository.saveGlobal(current);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final activeFilterProvider =
    StateNotifierProvider<ActiveFilterNotifier, AsyncValue<FilterProfile>>(
      (ref) => ActiveFilterNotifier(ref.watch(filterProfileRepositoryProvider)),
    );
