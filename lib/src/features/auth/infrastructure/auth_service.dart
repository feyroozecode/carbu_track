import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailAndPassword(
      String email, String password) async {
    final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.session == null) {
      throw Exception(response);
    }
    return response;
  }

  Future<AuthResponse> signUpWithEmailAndPassword(
      String email, String password) async {
    final AuthResponse response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
    if (response.session == null) {
      
      throw Exception(response);
    }
    return response;
  }


  // signout
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  // get current email 
  String getCurrentEmail() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.email ?? '';
  }

  // get user name 
  String getUserName() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.userMetadata!['full_name']?? '';
  }

// get session 
  Session? getSession() {
    return _supabaseClient.auth.currentSession;
  }
}
