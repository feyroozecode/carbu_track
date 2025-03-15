import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/constants/app_colors.dart';
import 'features/home/settings/providers/setting_provider.dart';
import 'router/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'carbuTracker',
        theme: ref.watch(settingsProvider).theme == 'light'
            ? ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                useMaterial3: true,
              )
            : ThemeData.dark().copyWith(),
        routerConfig: appRouter);
  }
}
