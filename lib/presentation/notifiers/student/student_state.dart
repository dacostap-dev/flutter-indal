part of 'student_notifier.dart';

abstract class StudentState {}

class StudentIntitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;

  StudentLoaded(this.students);
}

class StudentLoadFailed extends StudentState {}
