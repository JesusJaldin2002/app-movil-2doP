import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:segundo_parcial_movil/src/config/environment/environment.dart';
import 'package:segundo_parcial_movil/src/config/theme/app_theme.dart';
import 'package:segundo_parcial_movil/src/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Environment.initEnvironment();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'College',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen(), middlewares: [AuthMiddleware()]),
        GetPage(name: '/medical-record', page: () => MedicalRecordScreen(), middlewares: [AuthMiddleware()]),
      ],
      navigatorKey: Get.key,
    );
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Utiliza un futuro síncrono para cargar SharedPreferences
    final prefs = SharedPreferences.getInstance();
    prefs.then((prefsInstance) {
      String? token = prefsInstance.getString('token');
      // Si no hay token, redirigir a la pantalla de inicio de sesión
      if (token == null || token.isEmpty) {
        print('No token found, redirecting to /');
        Get.offAllNamed('/'); // Redirige al usuario usando GetX
      }
    });
    // No hay redirección (permite acceso) si hay un token válido
    return null;
  }
}