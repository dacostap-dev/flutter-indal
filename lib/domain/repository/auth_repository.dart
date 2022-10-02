import 'package:firebase_auth/firebase_auth.dart';
import 'package:indal/domain/models/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get onAuthStateChanged;

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  );


  Future<void> logout();

}
