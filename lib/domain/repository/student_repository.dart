import 'package:indal/domain/models/Student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents({Student? lastStudent});
  Future<List<Student>> getStudentsByPromotion(String promotionId);
  Future<Student> addStudent({
    required String name,
    required String email,
    required String gender,
    required String promotionId,
  });
  Future<void> updateStudent({required Student student});
  Future<void> deleteStudent({required String id});
}
