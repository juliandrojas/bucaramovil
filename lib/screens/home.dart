import 'package:bucaramovil/controllers/db_firebase_dev.dart';
import 'package:bucaramovil/screens/components/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Layout());
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home de ${user?.displayName ?? 'Usuario'}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_post');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                // Formatear createdAt
                String formattedDate = "Fecha desconocida";
                if (post['createdAt'] is Timestamp) {
                  formattedDate = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format((post['createdAt'] as Timestamp).toDate());
                } else if (post['createdAt'] is DateTime) {
                  formattedDate = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(post['createdAt']);
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/comments',
                      arguments: {'postId': post['uid']},
                    );
                  },
                  onLongPress: () {
                    _showEditSeverityDialog(context, post);
                  },
                  child: Card(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fila superior: Avatar + Autor
                          Row(
                            children: [
                              // Avatar del autor
                              CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.7),
                                radius: 20,
                                child: Text(
                                  (post['author'] != null &&
                                          post['author'].isNotEmpty)
                                      ? post['author'][0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nombre del autor
                                    Text(
                                      user?.displayName ??
                                          post['author'] ??
                                          'Anónimo',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // Fecha de creación
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Imagen del post
                          if (post['imageUrl'] != null &&
                              post['imageUrl'].isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                post['imageUrl'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            )
                          else
                            const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 12),
                          // Descripción del post
                          Text(
                            post['description'] ?? 'Sin descripción',
                            style: const TextStyle(fontSize: 15, height: 1.5),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          // Ubicación
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post['location'] != null &&
                                        post['location']['latitude'] != null &&
                                        post['location']['longitude'] != null
                                    ? 'Latitud: ${post['location']['latitude']}, Longitud: ${post['location']['longitude']}'
                                    : 'Sin ubicación',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Gravedad
                          Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post['severity']?.toString() ?? 'Sin gravedad',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          // Botón de comentarios
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/comments',
                                  arguments: post,
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
                          ),
                        ],
                      ),
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

  // Diálogo para editar la severidad
  void _showEditSeverityDialog(
    BuildContext context,
    Map<String, dynamic> post,
  ) {
    String selectedSeverity = post['severity'] ?? 'low'; // Valor predeterminado
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Severidad"),
          content: DropdownButtonFormField<String>(
            value: selectedSeverity,
            items: <String>['low', 'medium', 'high'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toUpperCase()),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                selectedSeverity = newValue;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _updatePostSeverity(context, post['uid'], selectedSeverity);
                Navigator.pop(context); // Cerrar diálogo
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  // Función para actualizar la severidad del post
  Future<void> _updatePostSeverity(
    BuildContext context,
    String? postId,
    String newSeverity,
  ) async {
    if (postId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ID del post no válido')));
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'severity': newSeverity,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Severidad actualizada')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar severidad: $e')),
      );
    }
  }
}
