
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  // GitHub Personal Access Token with repo scope
  static  String githubToken = dotenv.env['GITHUB_TOKEN'] ?? '';
}