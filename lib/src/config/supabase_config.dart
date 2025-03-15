import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void initSupabase() async {
  await Supabase.initialize(
      url: String.fromEnvironment(
          'SUPABASE_URL'), // dotenv.env['SUPABASE_URL']!,
      anonKey: String.fromEnvironment(
          'SUPABASE_ANON_KEY') //dotenv.env['SUPABASE_ANON_KEY']!
      );
}
