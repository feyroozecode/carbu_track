sealed class AppException implements Exception {
  AppException({required this.code, required this.message});

  final String code;
  final String message;

  @override
  toString() => 'AppException(code: $code, message: $message)';
}

// Auth 