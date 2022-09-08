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

  List<Modul> moduls = [];

  void getModulsByStudent(String studentId) {
    state = ModulLoading();

    _modulRepository.getModulsByStudent(studentId).then(
      (res) {
        moduls = res;
        state = ModulLoaded(res);
      },
    ).catchError((e) {
      print(e);
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

    _modulRepository
        .addModul(
      name: name,
      informe: informe,
      memorandum: memorandum,
      solicitud: solicitud,
      studentId: studentId,
    )
        .then(
      (value) {
        moduls.insertAll(0, [value]);
        state = ModulLoaded(moduls);
      },
    ).catchError((e) {
      print(e);
      state = ModulAddFailed(message: e.toString());
    });
  }

  void updateModul({
    required String modulId,
    required String name,
    required String informe,
    required String memorandum,
    required String solicitud,
  }) {
    print('updateModul');

    _modulRepository
        .updateModul(
      modulId: modulId,
      name: name,
      informe: informe,
      memorandum: memorandum,
      solicitud: solicitud,
    )
        .then(
      (value) {
      /*   final modul = moduls.where((element) => element.id == modulId).first;

        final modulEdited = modul.copyWith(
          name: name,
          informe: informe,
          memorandum: memorandum,
          solicitud: solicitud,
        ); */

        state = ModulUpdateSuccess();
      },
    ).catchError((e) {
      print(e);
      state = ModulUpdateFailed(message: e.toString());
    });
  }

  void deleteModul({
    required String modulId,
  }) {
    _modulRepository.deleteModul(modulId: modulId).then((value) {
      moduls.removeWhere((element) => element.id == modulId);
      state = ModulDeleteSuccess();
      state = ModulLoaded(moduls);
    }).catchError((e) {
      state = ModulDeleteFailed(message: e.toString());
    });
  }
}
