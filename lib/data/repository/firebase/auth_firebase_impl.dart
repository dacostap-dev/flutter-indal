import 'package:firebase_auth/firebase_auth.dart';
import 'package:indal/domain/models/auth_user.dart';
import 'package:indal/domain/models/custom_exception.dart';
import 'package:indal/domain/repository/auth_repository.dart';

class AuthFirebaseImplementation extends AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<AuthUser?> get onAuthStateChanged =>
      _firebaseAuth.userChanges().asyncMap(_userFromFirebase);

  AuthUser? _userFromFirebase(User? user) =>
      user == null ? null : setUser(user);

  AuthUser setUser(User user) {
    //print(user);
    print('set-user-imple');
    return AuthUser(
      uid: user.uid,
      email: user.email ?? user.providerData[0].email ?? '',
      name: user.displayName ?? '',
      photo: user.photoURL ??
          'https://firebasestorage.googleapis.com/v0/b/traumateam-f80e7.appspot.com/o/public%2Fdefault-avatar.jpeg?alt=media&token=bd02f88f-e031-4f04-b69d-00c43cff6471',
      provider: user.providerData[0].providerId,
    );
  }

  @override
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return authResult;
  }

  @override
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //_userFromFirebase(authResult.user); //NO ES NECESARIO PORQ LO MAPEA _userFromFirebase AL NOTAR EL CHANGE
    } on FirebaseAuthException catch (e) {
      print('mensaje: ${e.message}');
      print('code: ${e.code}');
      throw MyCustomException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
