import 'package:indal/domain/models/Student.dart';
import 'package:indal/domain/repository/student_repository.dart';

class StudentLocalImplementation extends StudentRepository {
  @override
  Future<Student> addStudent({
    required String name,
    required String email,
    required String gender,
    required String promotionId,
  }) {
    // TODO: implement addStudent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStudent({required String id}) {
    // TODO: implement deleteStudent
    throw UnimplementedError();
  }

  @override
  Future<List<Student>> getStudents({Student? lastStudent}) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      15,
      (index) => Student(
        id: index.toString(),
        name: 'Student $index',
        email: 'un email',
        gender: 'H',
        promotionId: index.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<Student>> getStudentsByPromotion(String promotionId) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      8,
      (index) => Student(
        id: index.toString(),
        name: 'Student ${index + 1}',
        email: 'un email',
        gender: 'H',
        promotionId: index.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> updateStudent({required Student student}) {
    // TODO: implement updateStudent
    throw UnimplementedError();
  }
}
