import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:segundo_parcial_movil/src/config/environment/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:segundo_parcial_movil/src/config/graphql_service.dart';

class UsersProvider extends GetConnect {
  String url = Environment.apiUrl;

  final GraphQLService _graphqlService = GraphQLService();

  Future<Map<String, dynamic>> authenticate(
      String email, String password) async {
    const String mutation = """
      mutation Authenticate(\$identifier: String!, \$password: String!) {
        authenticate(input: { identifier: \$identifier, password: \$password }) {
          jwt
          role
          doctorId
          patientId
        }
      }
    """;

    final variables = {
      'identifier': email.trim(),
      'password': password.trim(),
    };

    final result =
        await _graphqlService.performMutation(mutation, variables: variables);

    if (result.hasException) {
      print('Error de autenticación: ${result.exception.toString()}');
      throw Exception(result.exception.toString());
    }

    print('Respuesta de autenticación: ${result.data}');
    return result.data?['authenticate'] ?? {};
  }

  Future<String> getUserName() async {
    // Obtener el token almacenado en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      return 'Usuario desconocido';
    }

    // Definir la consulta GraphQL
    const String query = """
      query FindMyProfile {
        findMyProfile {
          id
          username
          email
          name
          role
          authorities
        }
      }
    """;

    // Realizar la consulta con el token de autorización
    final result = await _graphqlService.performQuery(
      query,
      variables: {},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Manejar el resultado de la consulta
    if (result.hasException) {
      print(
          'Error al obtener el perfil del usuario: ${result.exception.toString()}');
      return 'Usuario desconocido';
    }

    // Extraer el nombre del usuario
    final data = result.data?['findMyProfile'];
    String userName = data != null && data['name'] != null
        ? data['name']
        : 'Usuario desconocido';

    // Guardar el nombre en SharedPreferences si es necesario
    await prefs.setString('user_name', userName);

    return userName;
  }

  Future<void> logout() async {
    // Obtener el token almacenado en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      Get.snackbar(
          'Error de Sesión', 'No hay token disponible para cerrar sesión',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Definir la mutación de logout
    const String mutation = """
      mutation Logout {
        logout {
          message
        }
      }
    """;

    try {
      // Realizar la mutación con el token de autorización
      final result = await _graphqlService.performMutation(
        mutation,
        variables: {},
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Manejar la respuesta
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      // Opcional: Mostrar el mensaje de respuesta de la mutación
      final message =
          result.data?['logout']?['message'] ?? 'Sesión cerrada correctamente';
      Get.snackbar('Sesión cerrada', message,
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error de Logout', 'No se pudo cerrar sesión: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      // Eliminar el token y otros datos almacenados
      await prefs.remove('token');

      // Redirigir al usuario a la página de inicio de sesión
      Get.offAllNamed('/login');
    }
  }
}
