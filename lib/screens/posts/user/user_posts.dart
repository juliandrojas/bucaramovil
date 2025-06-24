import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserPostsPage extends StatelessWidget {
  final String userId;
  final String userName;

  const UserPostsPage({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Publicaciones de $userName")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar tus publicaciones."));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tienes publicaciones aún."));
          }

          // Mostrar cada post como tarjeta
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // Formatear fecha si existe
              String formattedDate = "Fecha desconocida";
              if (data['createdAt'] is Timestamp) {
                formattedDate = DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).format((data['createdAt'] as Timestamp).toDate());
              } else if (data['createdAt'] is String) {
                try {
                  formattedDate = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(DateTime.parse(data['createdAt']));
                } catch (e) {
                  debugPrint("Error formateando fecha: $e");
                }
              }

              return ListTile(
                title: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del autor
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Descripción del post
                        if (data['description'] != null &&
                            data['description'].isNotEmpty)
                          Text(
                            data['description'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),

                        const SizedBox(height: 12),

                        // Fecha de creación
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => _showEditPostDialog(context, data, document.id),
                onLongPress: () => _showDeletePostDialog(context, document.id),
              );
            },
          );
        },
      ),
    );
  }

  // Diálogo para editar el post
  void _showEditPostDialog(
    BuildContext context,
    Map<String, dynamic> postData,
    String postId,
  ) {
    final TextEditingController _controller = TextEditingController(
      text: postData['description'],
    );
    //final String? severity = postData['severity'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Publicación"),
          content: TextField(
            controller: _controller,
            maxLines: 4,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Escribe tu nueva descripción',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                final newDescription = _controller.text.trim();
                if (newDescription.isNotEmpty &&
                    newDescription != postData['description']) {
                  _updatePostDescription(context, postId, newDescription);
                  Navigator.pop(context); // Cerrar diálogo
                } else {
                  Navigator.pop(context); // Cerrar sin hacer nada
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  // Función para actualizar la descripción del post
  Future<void> _updatePostDescription(
    BuildContext context,
    String postId,
    String newDescription,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'description': newDescription,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Descripción actualizada')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
    }
  }

  // Diálogo para eliminar el post
  void _showDeletePostDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar Publicación"),
          content: const Text(
            "¿Estás seguro de querer eliminar esta publicación?",
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _deletePost(postId)
                    .then((_) {
                      Navigator.pop(context); // Cerrar diálogo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Publicación eliminada')),
                      );
                    })
                    .catchError((error) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al eliminar: $error')),
                      );
                    });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  // Función para eliminar el post
  Future<void> _deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (e) {
      debugPrint("Error al eliminar el post: $e");
      rethrow;
    }
  }
}
