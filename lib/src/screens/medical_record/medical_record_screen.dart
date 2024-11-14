import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:segundo_parcial_movil/src/screens/medical_record/medical_record_controller.dart';
import 'package:segundo_parcial_movil/src/shared/shared.dart';

class MedicalRecordScreen extends StatelessWidget {
  final MedicalRecordController controller = Get.put(MedicalRecordController());

  MedicalRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historia Clínica',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF004D40),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generar PDF con IA',
            onPressed: () {
              // Llamar a la función para generar el JSON y enviar a la API para generar el PDF
              controller.generateAndSendPdf();
            },
          ),
        ],
      ),
      drawer: Sidebar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.medicalRecordDetails.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron detalles de la historia clínica',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        }

        final details = controller.medicalRecordDetails;
        final profile = controller.userProfile;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView(
            children: [
              if (profile.isNotEmpty) ...[
                _buildSectionHeader('Información del Paciente'),
                _buildInfoTile('Nombre', profile['name'] ?? 'N/A'),
                _buildInfoTile('Email', profile['email'] ?? 'N/A'),
                const SizedBox(height: 16),
              ],
              _buildSectionHeader('Información General'),
              _buildInfoTile('ID', details['id'].toString()),
              _buildInfoTile('Alergias', details['allergies'] ?? 'N/A'),
              _buildInfoTile('Condiciones Crónicas', details['chronicConditions'] ?? 'N/A'),
              _buildInfoTile('Medicaciones', details['medications'] ?? 'N/A'),
              _buildInfoTile('Tipo de Sangre', details['bloodType'] ?? 'N/A'),
              _buildInfoTile('Historial Familiar', details['familyHistory'] ?? 'N/A'),
              _buildInfoTile('Altura', details['height']?.toString() ?? 'N/A'),
              _buildInfoTile('Peso', details['weight']?.toString() ?? 'N/A'),
              _buildInfoTile('Historial de Vacunas', details['vaccinationHistory'] ?? 'N/A'),
              const SizedBox(height: 16),
              _buildSectionHeader('Notas Médicas'),
              _buildMedicalNotes(details['medicalNotes']),
              const SizedBox(height: 16),
              _buildSectionHeader('Consultas'),
              _buildConsults(details['consults']),
              const SizedBox(height: 16),
              // Sección para mostrar la URL del PDF generado
              Obx(() {
                if (controller.pdfUrl.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'URL del PDF generado:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        controller.pdfUrl.value,
                        style: const TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink(); // No muestra nada si no hay URL
                }
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalNotes(List<dynamic>? medicalNotes) {
    if (medicalNotes == null || medicalNotes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No se encontraron notas médicas.',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: medicalNotes.map((note) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nota ID: ${note['id']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text('Tipo: ${note['noteType'] ?? 'N/A'}'),
                Text('Detalles: ${note['details'] ?? 'N/A'}'),
                Text('Fecha: ${note['date'] ?? 'N/A'}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConsults(List<dynamic>? consults) {
    if (consults == null || consults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No se encontraron consultas.',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: consults.map((consult) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consulta ID: ${consult['id']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text('Fecha: ${consult['date'] ?? 'N/A'}'),
                Text('Diagnóstico: ${consult['diagnosis'] ?? 'N/A'}'),
                Text('Tratamiento: ${consult['treatment'] ?? 'N/A'}'),
                Text('Observaciones: ${consult['observations'] ?? 'N/A'}'),
                Text('Peso Actual: ${consult['currentWeight'] ?? 'N/A'}'),
                Text('Altura Actual: ${consult['currentHeight'] ?? 'N/A'}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
