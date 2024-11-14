import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:segundo_parcial_movil/src/providers/medical_record_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordController extends GetxController {
  final MedicalRecordProvider medicalRecordProvider = MedicalRecordProvider();
  var medicalRecordDetails = {}.obs;
  var isLoading = false.obs;
  var userProfile = {}.obs;
  var pdfUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchMedicalRecordDetails();
  }

  Future<void> fetchMedicalRecordDetails() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? patientIdString = prefs.getString('patientId');
      int? patientId =
          patientIdString != null ? int.tryParse(patientIdString) : null;
      if (patientId == null) throw Exception('No se encontró un patientId');

      final medicalRecord =
          await medicalRecordProvider.getMedicalRecordByPatient(patientId);
      if (medicalRecord.isNotEmpty) {
        int medicalRecordId = medicalRecord['id'];
        final details = await medicalRecordProvider
            .getMedicalRecordDetails(medicalRecordId);
        medicalRecordDetails.value = details;
      } else {
        throw Exception('No se encontró el registro médico para el paciente');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final profile = await medicalRecordProvider.findMyProfile();
      userProfile.value = profile;
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Función para generar y enviar JSON para el PDF
  Future<void> generateAndSendPdf() async {
    // Construir el JSON con la clave `data`
    final jsonData = {
      'data': {
        'patientId': userProfile['id'] ?? 'N/A',
        'name': userProfile['name'] ?? 'N/A',
        'email': userProfile['email'] ?? 'N/A',
        'medicalRecord': {
          'id': medicalRecordDetails['id'] ?? 'N/A',
          'allergies': medicalRecordDetails['allergies'] ?? 'N/A',
          'chronicConditions':
              medicalRecordDetails['chronicConditions'] ?? 'N/A',
          'medications': medicalRecordDetails['medications'] ?? 'N/A',
          'bloodType': medicalRecordDetails['bloodType'] ?? 'N/A',
          'familyHistory': medicalRecordDetails['familyHistory'] ?? 'N/A',
          'height': medicalRecordDetails['height']?.toString() ?? 'N/A',
          'weight': medicalRecordDetails['weight']?.toString() ?? 'N/A',
          'vaccinationHistory':
              medicalRecordDetails['vaccinationHistory'] ?? 'N/A',
          'medicalNotes': medicalRecordDetails['medicalNotes'] ?? [],
          'consults': medicalRecordDetails['consults'] ?? [],
        },
      },
    };

    print('Datos JSON generados para el PDF con clave `data`: $jsonData');

    try {
      final response =
          await medicalRecordProvider.sendDataToGeneratePdf(jsonData);
      print('Respuesta de la API: ${response.toString()}');
      String fileUrl = response['fileUrl'] ?? 'No disponible';
      pdfUrl.value = fileUrl; // Actualiza la URL observable
      Get.snackbar(
          'PDF Generado', 'El archivo se generó correctamente: $fileUrl',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print('Error al generar el PDF: $e');
      pdfUrl.value = 'Error al generar el PDF'; // Muestra un mensaje de error
      Get.snackbar('Error', 'No se pudo generar el PDF',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
