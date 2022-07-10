part of 'modul_notifier.dart';

abstract class ModulState {}

class ModulIntitial extends ModulState {}

class ModulLoading extends ModulState {}

class ModulLoaded extends ModulState {
  final List<Modul> moduls;

  ModulLoaded(this.moduls);
}

class ModulLoadFailed extends ModulState {}
