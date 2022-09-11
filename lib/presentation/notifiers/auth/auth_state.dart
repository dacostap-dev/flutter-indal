part of 'auth_notifier.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed({required this.message});
}

class AuthLogout extends AuthState {}
