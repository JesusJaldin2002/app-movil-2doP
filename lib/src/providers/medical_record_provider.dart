import 'package:get/get.dart';
import 'package:segundo_parcial_movil/src/config/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordProvider extends GetConnect {
  final GraphQLService _graphqlService = GraphQLService();

  Future<Map<String, dynamic>> getMedicalRecordByPatient(int patientId) async {
    const String query = """
      query GetMedicalRecordByPatient(\$patientId: Int!) {
        getMedicalRecordByPatient(patientId: \$patientId) {
          id
          allergies
          chronicConditions
          medications
          bloodType
          familyHistory
          height
          weight
          vaccinationHistory
          patientId
        }
      }
    """;

    final variables = {
      'patientId': patientId,
    };

    // Obtener el token de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final result = await _graphqlService.performQuery(
      query,
      variables: variables,
      headers: token != null
          ? {
              'Authorization': 'Bearer $token',
            }
          : null,
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['getMedicalRecordByPatient'] ?? {};
  }

  Future<Map<String, dynamic>> getMedicalRecordDetails(
      int medicalRecordId) async {
    const String query = """
      query GetMedicalRecordDetails(\$medicalRecordId: Int!) {
        getMedicalRecordDetails(medicalRecordId: \$medicalRecordId) {
          id
          allergies
          chronicConditions
          medications
          bloodType
          familyHistory
          height
          weight
          vaccinationHistory
          patientId
          medicalNotes {
            id
            noteType
            details
            date
            medicalRecordId
          }
          consults {
            id
            date
            diagnosis
            treatment
            observations
            currentWeight
            currentHeight
            medicalRecordId
            appointmentId
            attentionTime
          }
        }
      }
    """;

    final variables = {
      'medicalRecordId': medicalRecordId,
    };

    // Obtener el token de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final result = await _graphqlService.performQuery(
      query,
      variables: variables,
      headers: token != null
          ? {
              'Authorization': 'Bearer $token',
            }
          : null,
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['getMedicalRecordDetails'] ?? {};
  }

  Future<Map<String, dynamic>> findMyProfile() async {
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

    // Obtener el token de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final result = await _graphqlService.performQuery(
      query,
      headers: token != null
          ? {
              'Authorization': 'Bearer $token',
            }
          : null,
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['findMyProfile'] ?? {};
  }

  Future<Map<String, dynamic>> sendDataToGeneratePdf(Map<String, dynamic> jsonData) async {
  print('Enviando datos a la API para generar PDF...');
  try {
    final response = await post(
      'http://3.15.3.204:3000/api/generate-chatgpt-pdf',
      jsonData,
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 25));;

    print('Código de respuesta de la API: ${response.statusCode}');
    print('Respuesta de la API: ${response.body}');

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al generar el PDF: ${response.statusText}');
    }
  } catch (e) {
    print('Excepción al enviar datos para generar PDF: $e');
    rethrow;
  }
}
}
