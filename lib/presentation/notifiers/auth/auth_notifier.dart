import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/auth_user.dart';
import 'package:indal/domain/models/custom_exception.dart';
import 'package:indal/domain/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription _streamSubscription;
  late AuthUser _authUser;

  AuthNotifier(this._authRepository) : super(AuthInitial());

  init() async {
    _streamSubscription =
        _authRepository.onAuthStateChanged.listen((AuthUser? user) {
      print(user);
      user == null ? state = AuthLogout() : setUser(user);
    });
  }

  AuthUser getAuthUser() => _authUser;

  void setUser(AuthUser user) async {
    _authUser = user;
    state = AuthSuccess();
  }

  void loginWithEmailAndPassword(String email, String password) {
    state = AuthLoading();

    _authRepository.signInWithEmailAndPassword(email, password).catchError((e) {
      state = AuthFailed(message: ErrorCodes.getMessage(e.code));
    });
  }

  void logout() async {
    print('logout');
    state = AuthLoading();
    await _authRepository.logout();
  }

  close() {
    _streamSubscription.cancel();
  }
}
