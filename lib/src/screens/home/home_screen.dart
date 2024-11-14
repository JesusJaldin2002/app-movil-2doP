import 'package:flutter/material.dart';
import 'package:segundo_parcial_movil/src/shared/shared.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenido a la APP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF004D40),
      ),
      body: const Center(
        child: Text('Home'),
      ),
      drawer: Sidebar(),
    );
  }
}
