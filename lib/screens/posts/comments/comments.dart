import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bucaramovil/controllers/db_firebase_dev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsPage extends StatelessWidget {
  final String postId;

  const CommentsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No hay comentarios.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String authorId = data['userId'] ?? '';
          final bool isAuthor = currentUser?.uid == authorId;

          List<dynamic> commentsDynamic = data['comments'] ?? [];
          List<String> comments = commentsDynamic
              .map((item) => item.toString())
              .toList();

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              String comment = comments[index];

              return ListTile(
                title: Text(comment),
                subtitle: Text('Comentario #${index + 1}'),
                onTap: () {
                  _showCommentActions(context, index, comment, isAuthor);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: _buildAddCommentButton(
        context,
        postId,
        currentUser,
      ),
    );
  }

  // Botón para agregar comentarios (solo visible si es el autor)
  Widget _buildAddCommentButton(
    BuildContext context,
    String postId,
    User? currentUser,
  ) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getPostData(postId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final data = snapshot.data!;
        final String authorId = data['userId'] ?? '';
        final bool isAuthor = currentUser?.uid == authorId;

        return Visibility(
          visible: isAuthor,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/create_comment',
                arguments: postId,
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> getPostData(String postId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  // Mostrar diálogo con opciones al pulsar un comentario
  void _showCommentActions(
    BuildContext context,
    int index,
    String comment,
    bool isAuthor,
  ) {
    if (isAuthor) {
      // Si es el autor del post, mostrar editar y eliminar
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Opciones del comentario"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(comment),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Cerrar diálogo
                          _showEditDialog(context, index, comment);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Editar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Cerrar diálogo
                          _showDeleteDialog(context, index, comment);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Eliminar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Cerrar"),
              ),
            ],
          );
        },
      );
    } else {
      // Si no es el autor, solo mostrar el comentario
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Comentario"),
            content: Text(comment),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }

  // Diálogo para editar comentario
  void _showEditDialog(BuildContext context, int index, String oldComment) {
    final TextEditingController _controller = TextEditingController(
      text: oldComment,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Comentario'),
          content: TextField(
            controller: _controller,
            maxLines: 3,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Escribe tu nuevo comentario',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final newComment = _controller.text.trim();
                if (newComment.isNotEmpty && newComment != oldComment) {
                  updateComment(postId, index, newComment)
                      .then((_) {
                        Navigator.pop(context); // Cerrar diálogo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Comentario actualizado'),
                          ),
                        );
                      })
                      .catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al actualizar: $error'),
                          ),
                        );
                      });
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Diálogo para eliminar comentario
  void _showDeleteDialog(BuildContext context, int index, String comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Comentario'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este comentario?',
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                deleteComment(postId, index)
                    .then((_) {
                      Navigator.pop(context); // Cierra el diálogo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comentario eliminado')),
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
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
