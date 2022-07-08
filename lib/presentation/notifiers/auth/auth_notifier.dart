import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthInitial());

  init() async {
    await _authRepository.login();
    state = AuthSuccess();
  }

  void login() async {
    state = AuthLoading();
    await _authRepository.login();

    state = AuthSuccess();
  }

  void logout() async {
    await _authRepository.logout();
    state = AuthLogout();
  }
}
