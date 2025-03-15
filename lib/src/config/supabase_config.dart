import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void initSupabase() async {
  await Supabase.initialize(
      url:
          'https://gdedpsoysuluuekqiglq.supabase.co', // dotenv.env['SUPABASE_URL']!,
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdkZWRwc295c3VsdXVla3FpZ2xxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIwMjYzOTYsImV4cCI6MjA1NzYwMjM5Nn0.0fwjIcT2zxMaVqH-QST_EgxyIxsLt9G7DCB3tIYBJ1Y' //dotenv.env['SUPABASE_ANON_KEY']!
      );
}
