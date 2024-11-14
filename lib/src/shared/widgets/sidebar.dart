import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:segundo_parcial_movil/src/providers/users_provider.dart';

class Sidebar extends StatelessWidget {
  Sidebar({super.key});
  final UsersProvider usersProvider = UsersProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: usersProvider.getUserName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 19, 53, 47),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          snapshot.data!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Color(0xFF004D40)),
                  title: const Text('Inicio'),
                  onTap: () => _onItemTapped(0),
                ),
                ListTile(
                  leading: const Icon(Icons.book_online_rounded, color: Color(0xFF004D40)),
                  title: const Text('Historia Clinica'),
                  onTap: () => _onItemTapped(1),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Color(0xFF004D40)),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _onItemTapped(2),
                ),
              ],
            ),
          );
        } else {
          return const Drawer();
        }
      },
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/home');
        break;
      case 1:
        Get.offAllNamed('/medical-record');
        break;
      case 2:
        usersProvider.logout();
        break;
    }
  }
}
