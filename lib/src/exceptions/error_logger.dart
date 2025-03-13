import 'package:flutter/foundation.dart';
import 'app_exception.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stack) {
    debugPrint('$error, $stack');
  }

  void logAppException(AppException exception) {
    debugPrint('$exception');
  }
}

@riverpod
ErrorLogger errorLogger(Ref ref) => ErrorLogger();
