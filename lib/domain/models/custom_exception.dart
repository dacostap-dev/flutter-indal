class MyCustomException {
  final String code;
  final String? message;

  MyCustomException({
    required this.code,
    this.message,
  });
}

class ErrorCodes {
  ErrorCodes._();

  static const Map<String, String> codes = {
    'invalid-email': 'El email es inválido',
    'wrong-password': 'La contraseña es incorrecta',
  };

  static String getMessage(String code) => codes[code] ?? 'Error desconocido';
}
