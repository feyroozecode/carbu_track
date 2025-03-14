import 'package:go_router/go_router.dart';

import '../features/auth/signin/presentation/sigin_screen.dart';
import '../features/home/core/presentation/home_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

enum AppRoutes {
  initial(
    name: '/',
    path: '/',
  ),
  home(
    name: 'home',
    path: '/home'
  ),
  signIn(
    name: 'signin',
    path: '/signin'
  ),
  splash(
    name: 'splash',
    path: '/splash'
  );

  String get getName => toString().split('.').last;
  String get getPath => '/$name';

  const AppRoutes({
    required this.name,
    required this.path
  });

  final String name;
  final String path;
}

List<RouteBase> routes = [
  GoRoute(
    name: AppRoutes.initial.name,
    path: AppRoutes.initial.path,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    name: AppRoutes.home.name,
    path: AppRoutes.home.path,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    name: AppRoutes.signIn.name,
    path: AppRoutes.signIn.path,
    builder: (context, state) => const SignInScreen(),
  ),
  GoRoute(
    name: AppRoutes.splash.name,
    path: AppRoutes.splash.path,
    builder: (context, state) => const SplashScreen(),
  ),
];

final appRouter = GoRouter(
  initialLocation: '/splash', // Define initial route to start with splash screen
  routes: routes
);
