import 'package:firebase_auth/firebase_auth.dart';
import 'package:indal/domain/models/auth_user.dart';
import 'package:indal/domain/repository/auth_repository.dart';

class AuthLocalImplementation extends AuthRepository {
  @override
  Future<void> login() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> register() {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  // TODO: implement onAuthStateChanged
  Stream<AuthUser?> get onAuthStateChanged => throw UnimplementedError();
  
  @override
  Future<UserCredential ?> createUserWithEmailAndPassword(String email, String password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }
  
  @override
  Future<UserCredential ?> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }
}
