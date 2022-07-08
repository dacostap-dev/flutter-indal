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
}
