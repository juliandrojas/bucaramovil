import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:bucaramovil/screens/components/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageDev extends StatelessWidget {
  const HomePageDev({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: CustomAppBar(title: 'BucaraMóvil - Entorno de Desarrollo'),
      body: NavigationBarHome(user: user), // ✅ Usamos NavigationBarHome aquí
    );
    /*return Scaffold(
      appBar: CustomAppBar(title: 'BucaraMóvil - Entorno de Desarrollo'),
      body: NavigationBarHome(user: ,),
       Center(
        child: Column(
          children: [
            Text(
              'Bienvenido a BucaraMóvil - Entorno de Desarrollo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Icon(Icons.developer_mode, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Esta es la pantalla de inicio del entorno de desarrollo.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPageDev()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ), 
    );*/
  }
}
