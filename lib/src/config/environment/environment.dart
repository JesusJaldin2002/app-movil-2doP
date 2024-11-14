import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> initEnvironment() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print('Error loading .env file: $e');
    }
  }

  static String get apiUrl => dotenv.env['API_URL'] ?? 'No está configurado el API_URL';
}
