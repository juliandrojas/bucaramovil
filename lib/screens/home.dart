import 'package:bucaramovil/controllers/db_firebase_dev.dart';
import 'package:bucaramovil/controllers/utils/widgets/colors.dart';

import 'package:bucaramovil/screens/components/layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageDev extends StatelessWidget {
  const HomePageDev({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Layout());
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actual
    final User? user = FirebaseAuth.instance.currentUser;
    // Obtener el correo y la foto del usuario
    //final String correo = user?.email ?? 'Sin correo registrado';
    final String photoUrl = user?.photoURL ?? '';
    return Scaffold(
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_post');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ), */
      body: FutureBuilder(
        future: getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay publicaciones disponibles.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar del autor
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                        const SizedBox(width: 12),
                        // Contenido principal (nombre y descripción)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fila: Autor
                              Row(
                                children: [
                                  const Text('Autor: '),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      user?.displayName ?? 'Anónimo',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Fila: Descripción
                              Row(
                                children: [
                                  const Text('Descripción: '),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      snapshot.data![index]['description'] ??
                                          'Sin descripción',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Fila: Severidad
                              Row(
                                children: [
                                  const Text('Severidad: '),
                                  const SizedBox(width: 8),
                                  SeverityDot(
                                    severity:
                                        snapshot.data![index]['severity'] ??
                                        'gray',
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      snapshot.data![index]['severity'] ??
                                          'Sin definir',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  final postId = snapshot
                                      .data![index]['uid']; // <-- Aquí obtienes el ID
                                  Navigator.pushNamed(
                                    context,
                                    '/comments',
                                    arguments: postId,
                                  );
                                },
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  size: 16,
                                ),
                                label: const Text("Ver comentarios"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Función para formatear fechas
  String formatDate(DateTime date) {
    return DateFormat('dd \\de MMMM \\de yyyy, hh:mm:ss a').format(date);
  }
}
