abstract class AuthRepository {
  Future<void> login();
  Future<void> logout();
  Future<void> register();
}