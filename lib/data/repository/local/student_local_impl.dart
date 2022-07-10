import 'package:indal/domain/models/Student.dart';
import 'package:indal/domain/repository/student_repository.dart';

class StudentLocalImplementation extends StudentRepository {
  @override
  Future<Student> addStudent() {
    // TODO: implement addStudent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStudent() {
    // TODO: implement deleteStudent
    throw UnimplementedError();
  }

  @override
  Future<List<Student>> getStudents() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      15,
      (index) => Student(
        id: index.toString(),
        name: 'Student $index',
        email: 'un email',
        gender: 'H',
        promocionId: index.toString(),
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
        promocionId: index.toString(),
      ),
    );
  }

  @override
  Future<Student> updateStudent() {
    // TODO: implement updateStudent
    throw UnimplementedError();
  }
}
