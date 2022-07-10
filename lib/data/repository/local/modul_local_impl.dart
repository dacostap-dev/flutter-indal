import 'package:indal/domain/models/Modul.dart';
import 'package:indal/domain/repository/modul_repository.dart';

class ModulLocalImplementation extends ModulRepository {
  @override
  Future<Modul> addStudent() {
    // TODO: implement addStudent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteModul() {
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
        name: 'Modul ${index+1}',
        studentId: index.toString(),
        informe: '',
        memorandum: '',
        solicitud: '',
      ),
    );
  }

  @override
  Future<Modul> updateModul() {
    // TODO: implement updateModul
    throw UnimplementedError();
  }
}
