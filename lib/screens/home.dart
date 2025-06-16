import 'package:bucaramovil/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostsHomePage extends StatelessWidget {
  final User? user;
  const PostsHomePage({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen del perfil
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                ),
                const SizedBox(height: 10),

                // Nombre de usuario
                Text(
                  "Bienvenido: ${user?.displayName ?? 'No disponible'}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Email
                Text(
                  "Email: ${user?.email ?? 'No disponible'}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Botón para posts
                ElevatedButton.icon(
                  onPressed: () {
                    if (ModalRoute.of(context)?.settings.name !=
                        '/posts/home') {
                      debugPrint("Navegando a la pantalla de posts");
                      //debugPrint("Navegando al inicio de los test");
                      Navigator.pushNamed(context, '/posts/home');
                      // Navigator.pushNamed(context, '/test/home');
                    }
                  },
                  icon: const Icon(Icons.article),
                  label: const Text('Ver Posts'),
                ),
                const SizedBox(height: 15),

                // Botón para cerrar sesión
                ElevatedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
