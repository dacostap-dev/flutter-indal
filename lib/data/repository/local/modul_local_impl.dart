import 'package:indal/domain/models/Modul.dart';
import 'package:indal/domain/repository/modul_repository.dart';

class ModulLocalImplementation extends ModulRepository {
  @override
  Future<Modul> addModul({
    required String name,
    required String informe,
    required String memorandum,
    required String solicitud,
    required String studentId,
  }) {
    // TODO: implement addStudent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteModul({required String modulId}) {
    // TODO: implement deleteModul
    throw UnimplementedError();
  }

  @override
  Future<List<Modul>> getModulsByStudent(String studentId) async {
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(
      5,
      (index) => Modul(
        id: index.toString(),
        name: 'Modul ${index + 1}',
        studentId: index.toString(),
        informe: '',
        memorandum: '',
        solicitud: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> updateModul({
        required String modulId,
    required String name,
    required String informe,
    required String memorandum,
    required String solicitud,
  }) {
    // TODO: implement updateModul
    throw UnimplementedError();
  }
}
