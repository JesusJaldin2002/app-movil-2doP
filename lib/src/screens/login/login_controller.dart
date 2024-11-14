import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:segundo_parcial_movil/src/providers/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UsersProvider usersProvider = UsersProvider();

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (isValidForm(email, password)) {
      try {
        // Llamamos a la mutación de autenticación
        final response = await usersProvider.authenticate(email, password);

        // Verificamos la respuesta y almacenamos el token
        if (response.isNotEmpty) {
          String jwt = response['jwt'] ?? '';
          String role = response['role'] ?? 'unknown';
          String? doctorId = response['doctorId'];
          int? patientId = response['patientId']; // Aquí estaba el problema: es int

          // Guarda los valores en el almacenamiento local
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', jwt);
          await prefs.setString('role', role);
          if (doctorId != null) await prefs.setString('doctorId', doctorId.toString());
          if (patientId != null) await prefs.setString('patientId', patientId.toString());

          Get.snackbar('Inicio de Sesión Exitoso', 'Bienvenido',
              backgroundColor: Colors.green, colorText: Colors.white);

          print('Redirigiendo a /home');
          Get.offAllNamed('/home'); // Verifica si esta línea se ejecuta
        } else {
          Get.snackbar('Error de Login', 'Datos incorrectos',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (e) {
        print('Error de Login: $e');
        Get.snackbar('Error de Login', 'Por favor vuelve a intentarlo',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  bool isValidForm(String email, String password) {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Email no válido', 'Por favor ingrese un email válido',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Formulario no válido', 'Por favor ingrese todos los campos',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }
}
