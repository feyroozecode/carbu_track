import 'dart:io';

import 'package:carbu_track/src/features/home/favorite/infrastructure/domain/favorite.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/app.dart';
import 'src/config/supabase_config.dart';
import 'src/exceptions/async_error_logger.dart';
import 'src/exceptions/error_handler.dart';
import 'src/exceptions/error_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive
    ..init(Directory.current.path)
    ..registerAdapter(FavoriteAdapter());

  final container = ProviderContainer(
    overrides: [], // define overrides scope for porviders
    observers: [AsyncErrorLogger()],
  );
  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);
  //await dotenv.load(fileName: ".env");
  initSupabase();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
