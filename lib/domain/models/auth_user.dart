class AuthUser {
  final String uid;
  final String email;
  final String name;
  final String photo;
  final String provider;

  AuthUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.photo,
    required this.provider,
  });
}
