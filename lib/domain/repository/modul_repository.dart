import 'package:indal/domain/models/Modul.dart';
import 'package:indal/domain/models/Student.dart';

abstract class ModulRepository {
  Future<List<Modul>> getModulsByStudent(String studentId);
  Future<Modul> addStudent();
  Future<Modul> updateModul();
  Future<void> deleteModul();
}
