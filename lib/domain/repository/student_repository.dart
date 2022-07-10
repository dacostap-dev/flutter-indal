import 'package:indal/domain/models/Student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents();
  Future<List<Student>> getStudentsByPromotion(String promotionId);
  Future<Student> addStudent();
  Future<Student> updateStudent();
  Future<void> deleteStudent();
}
