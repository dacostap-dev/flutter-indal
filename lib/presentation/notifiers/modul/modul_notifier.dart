import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Modul.dart';

import 'package:indal/domain/repository/modul_repository.dart';
import 'package:indal/providers/dependencies_provider.dart';
part 'modul_state.dart';

final errorProvider = StateProvider<String?>((ref) => null);

final modulCubit =
    StateNotifierProvider<ModulNotifier, AsyncValue<List<Modul>>>(
  (ref) => ModulNotifier(ref.read(modulRepository), ref),
);

class ModulNotifier extends StateNotifier<AsyncValue<List<Modul>>> {
  final ModulRepository _modulRepository;
  final Ref ref;

  ModulNotifier(
    this._modulRepository,
    this.ref,
  ) : super(const AsyncValue.loading());

  //List<Modul> moduls = [];

  void getModulsByStudent(String studentId) {
    state = const AsyncValue.loading();

    _modulRepository.getModulsByStudent(studentId).then(
      (res) {
        //moduls = res;

        state = AsyncValue.data(res);
      },
    ).catchError((e) {
      print(e);
      ref.read(errorProvider.notifier).state = 'Algo salio Mal';
      state = AsyncValue.error(e);
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
        //    moduls.insertAll(0, [value]);

        state.whenData(
            (items) => state = AsyncValue.data(items..insertAll(0, [value])));
      },
    ).catchError((e) {
      print(e);

      ref.read(errorProvider.notifier).state = 'Algo salio Mal';
      state = AsyncValue.error(e);
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
        state.whenData((items) {
          state = AsyncValue.data([
            for (final item in items)
              if (item.id == modulId)
                item.copyWith(
                  id: modulId,
                  name: name,
                  informe: informe,
                  memorandum: memorandum,
                  solicitud: solicitud,
                  studentId: 'studentId',
                  updatedAt: DateTime.now(),
                )
              else
                item
          ]);
        });
        /*   final modul = moduls.where((element) => element.id == modulId).first;

        final modulEdited = modul.copyWith(
          name: name,
          informe: informe,
          memorandum: memorandum,
          solicitud: solicitud,
        ); */
      },
    ).catchError((e) {
      print(e);
      ref.read(errorProvider.notifier).state = 'Algo salio Mal';
      state = AsyncValue.error(e);
    });
  }

  void deleteModul({
    required String modulId,
  }) {
    _modulRepository.deleteModul(modulId: modulId).then((value) {
      state.whenData((items) => state =
          AsyncValue.data(items..removeWhere((item) => item.id == modulId)));
    }).catchError((e) {
      ref.read(errorProvider.notifier).state = 'Algo salio Mal';
      state = AsyncValue.error(e);
    });
  }
}
