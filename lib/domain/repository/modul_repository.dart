import 'package:indal/domain/models/Modul.dart';


abstract class ModulRepository {
  Future<List<Modul>> getModulsByStudent(String studentId);

  Future<Modul> addModul({
    required String name,
    required String informe,
    required String memorandum,
    required String solicitud,
    required String studentId,
  });

  Future<void> updateModul({
    required String modulId,
    required String name,
    required String informe,
    required String memorandum,
    required String solicitud,
  });

  Future<void> deleteModul({required String modulId});
}
