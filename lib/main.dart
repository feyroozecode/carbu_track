
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/app.dart';
import 'src/exceptions/async_error_logger.dart';
import 'src/exceptions/error_handler.dart';
import 'src/exceptions/error_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.load(fileName: '.env');
  final container = ProviderContainer(
    overrides: [], // define overrides scope for porviders
    observers: [AsyncErrorLogger()],
  );
  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);
  //await dotenv.load(fileName: ".env");
  //initSupabase();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

