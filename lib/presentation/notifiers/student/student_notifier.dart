import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/data/repository/firebase/students_firebase_impl.dart';
import 'package:indal/domain/models/Student.dart';
import 'package:indal/domain/repository/student_repository.dart';
import 'package:indal/providers/dependencies_provider.dart';
part 'student_state.dart';

enum StudentQuery {
  name,
  createdAt,
}

final filterStudentProvider = StateProvider((ref) => StudentQuery.name);

final studentCubit =
    StateNotifierProvider<StudentNotifier, StudentState>((ref) {
  //O pasar directamente el ref para que busque los repositorios que necesita

  return StudentNotifier(ref.read(studentRepository));
});

class StudentNotifier extends StateNotifier<StudentState> {
  final StudentRepository _studentRepository;
  StudentNotifier(this._studentRepository) : super(StudentIntitial());

  final List<Student> _students = [];
  List<Student> studentsByPromotion = [];

  void clearStudents() {
    _students.clear();
  }

  void getStudents({
    int offset = 0,
    Student? lastStudent,
  }) {
    if (offset == 0) {
      state = StudentLoading();
    }

    _studentRepository.getStudents(lastStudent: lastStudent).then((res) {
      _students.addAll(res);
      state = StudentLoaded(_students);
    }).catchError((e) {
      print(e);
      state = StudentLoadFailed();
    });
  }

  void getStudentsByPromotion(String promotinId) {
    print('getStudentsByPromotion');

    state = StudentByPromotionLoading();

    _studentRepository.getStudentsByPromotion(promotinId).then(
      (res) {
        studentsByPromotion = res;
        state = StudentByPromotionLoaded(studentsByPromotion);
      },
    ).catchError((e) {
      state = StudentByPromotionLoadFailed();
    });
  }

  void addStudent({
    required String name,
    required String email,
    required String gender,
    required String promotionId,
  }) {
    print('addStudent');

    _studentRepository
        .addStudent(
      name: name,
      email: email,
      gender: gender,
      promotionId: promotionId,
    )
        .then(
      (value) {
        //   state = PromotionAddSuccess();
        _students.insertAll(0, [value]);
        state = StudentLoaded(_students);
      },
    ).catchError((e) {
      print(e);
      state = StudentAddFailed(message: e.toString());
    });
  }

  void updateStudent({
    required Student student,
  }) {
    print('addStudent');

    _studentRepository
        .updateStudent(
          student: student,
        )
        .then((value) => state = StudentUpdateSuccess())
        .catchError((e) {
      print(e);
      state = StudentAddFailed(message: e.toString());
    });
  }

  void deleteStudent(Student student) {
    print('deleteStudent');

    _studentRepository.deleteStudent(id: student.id).then(
      (value) {
        _students.removeWhere((element) => element.id == student.id);
        state = StudentLoaded(_students);
      },
    ).catchError((e) {
      print(e);
      state = StudentDeleteFailed(message: e.toString());
    });
  }
}
