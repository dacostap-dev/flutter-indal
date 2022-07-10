import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Student.dart';
import 'package:indal/domain/repository/student_repository.dart';
import 'package:indal/providers/dependencies_provider.dart';
part 'student_state.dart';

final studentCubit =
    StateNotifierProvider<StudentNotifier, StudentState>((ref) {
  //O pasar directamente el ref para que busque los repositorios que necesita

  return StudentNotifier(ref.read(studentRepository));
});

class StudentNotifier extends StateNotifier<StudentState> {
  final StudentRepository _studentRepository;
  StudentNotifier(this._studentRepository) : super(StudentIntitial());

  void getStudents() {
    state = StudentLoading();

    _studentRepository
        .getStudents()
        .then(
          (res) => state = StudentLoaded(res),
        )
        .catchError((e) {
      state = StudentLoadFailed();
    });
  }

  void getStudentsByPromotion(String promotinId) {
    state = StudentLoading();

    _studentRepository
        .getStudentsByPromotion(promotinId)
        .then(
          (res) => state = StudentLoaded(res),
        )
        .catchError((e) {
      state = StudentLoadFailed();
    });
  }

  void addStudent({
    required String name,
    required String email,
    required String gender,
    required String promocionId,
  }) {
    print('addStudent');
    final currentState = state;
    if (currentState is StudentLoaded) {
      state = StudentLoaded([
        ...currentState.students,
        Student(
          id: '123213',
          name: name,
          email: email,
          gender: gender,
          promocionId: promocionId,
        ),
      ]);
    }
  }
}
