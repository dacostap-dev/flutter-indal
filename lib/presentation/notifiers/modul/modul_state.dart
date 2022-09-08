part of 'modul_notifier.dart';

abstract class ModulState {}

class ModulIntitial extends ModulState {}

class ModulLoading extends ModulState {}

class ModulLoaded extends ModulState {
  final List<Modul> moduls;

  ModulLoaded(this.moduls);
}

class ModulLoadFailed extends ModulState {}

//ADD

class ModulAddSuccess extends ModulState {}

class ModulAddFailed extends ModulState {
  final String message;

  ModulAddFailed({required this.message});
}

//ADD

class ModulUpdateSuccess extends ModulState {}

class ModulUpdateFailed extends ModulState {
  final String message;

  ModulUpdateFailed({required this.message});
}

//DELETE
class ModulDeleteSuccess extends ModulState {}

class ModulDeleteFailed extends ModulState {
  final String message;

  ModulDeleteFailed({required this.message});
}
