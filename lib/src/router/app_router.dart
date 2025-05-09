import 'package:carbu_track/src/features/auth/presentation/auth_gate.dart';
import 'package:carbu_track/src/features/auth/presentation/signup_screen.dart';
import 'package:carbu_track/src/features/home/settings/presentation/feedback_screen.dart';
import 'package:carbu_track/src/features/home/settings/presentation/profile_screen.dart';
import 'package:carbu_track/src/features/home/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/home/core/presentation/home_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

enum AppRoutes {
  initial(
    name: '/',
    path: '/',
  ),
  home(name: 'home', path: '/home'),
  gate(name: 'gate', path: '/gate'),
  signIn(name: 'signin', path: '/signin'),
  signUP(name: 'signup', path: '/signup'),
  splash(name: 'splash', path: '/splash'),
  setting(name: 'setting', path: '/setting'),
  feedback(name: 'feedback', path: '/feedback'),
  profile(name: 'profile', path: '/profile');

  String get getName => toString().split('.').last;
  String get getPath => '/$name';

  const AppRoutes({required this.name, required this.path});

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
    name: AppRoutes.gate.name,
    path: AppRoutes.gate.path,
    builder: (context, state) => AuthGateScreen(),
  ),
  GoRoute(
    name: AppRoutes.signIn.name,
    path: AppRoutes.signIn.path,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: AppRoutes.signUP.name,
    path: AppRoutes.signUP.path,
    builder: (context, state) => const SignupScreen(),
  ),
  GoRoute(
    name: AppRoutes.splash.name,
    path: AppRoutes.splash.path,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    name: AppRoutes.setting.name,
    path: AppRoutes.setting.path,
    builder: (context, state) => SettingsScreen(),
  ),
  GoRoute(
    name: AppRoutes.feedback.name,
    path: AppRoutes.feedback.path,
    builder: (context, state) => FeedbackScreen(),
  ),
  GoRoute(
    name: AppRoutes.profile.name,
    path: AppRoutes.profile.path,
    builder: (context, state) => ProfileScreen(),
  ),
];

final appRouter = GoRouter(
    initialLocation:
        '/splash', // Define initial route to start with splash screen
    routes: routes);
