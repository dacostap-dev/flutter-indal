part of 'student_notifier.dart';

abstract class StudentState {}

class StudentIntitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;

  StudentLoaded(this.students);
}

class StudentLoadFailed extends StudentState {}

//BY PROMOTION

class StudentByPromotionLoading extends StudentState {}

class StudentByPromotionLoaded extends StudentState {
  final List<Student> students;

  StudentByPromotionLoaded(this.students);
}

class StudentByPromotionLoadFailed extends StudentState {}

//ADD
class StudentAddSuccess extends StudentState {}

class StudentAddFailed extends StudentState {
  final String message;

  StudentAddFailed({required this.message});
}

//UPDATE
class StudentUpdateSuccess extends StudentState {}

class StudentUpdateFailed extends StudentState {
  final String message;

  StudentUpdateFailed({required this.message});
}

//DELETE
class StudentDeleteSuccess extends StudentState {}

class StudentDeleteFailed extends StudentState {
  final String message;

  StudentDeleteFailed({required this.message});
}
