import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Modul.dart';

import 'package:indal/domain/repository/modul_repository.dart';
import 'package:indal/providers/dependencies_provider.dart';
part 'modul_state.dart';

final modulCubit = StateNotifierProvider<ModulNotifier, ModulState>((ref) {
  //O pasar directamente el ref para que busque los repositorios que necesita

  return ModulNotifier(ref.read(modulRepository));
});

class ModulNotifier extends StateNotifier<ModulState> {
  final ModulRepository _modulRepository;
  ModulNotifier(this._modulRepository) : super(ModulIntitial());

  void getModulsByStudent(String studentId) {
    state = ModulLoading();

    _modulRepository
        .getModulsByStudent(studentId)
        .then(
          (res) => state = ModulLoaded(res),
        )
        .catchError((e) {
      state = ModulLoadFailed();
    });
  }

  void addModul({
    required String name,
    required String studentId,
    required String informe,
    required String memorandum,
    required String solicitud,
  }) {
    print('addPromotion');
    final currentState = state;

    if (currentState is ModulLoaded) {
      state = ModulLoaded([
        ...currentState.moduls,
        Modul(
          id: 'id',
          name: name,
          studentId: studentId,
          informe: informe,
          memorandum: memorandum,
          solicitud: solicitud,
        ),
      ]);
    }
  }
}
