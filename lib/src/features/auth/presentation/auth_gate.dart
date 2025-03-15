import 'package:carbu_track/src/common/common_import.dart';
import 'package:carbu_track/src/features/auth/presentation/login_screen.dart';
import 'package:carbu_track/src/features/home/core/presentation/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const CircularProgressIndicator();

            final session = snapshot.hasData ? snapshot.data!.session : null;
            if (session != null) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          } else {
            return const LoginScreen();
          }
        });
  }
}
