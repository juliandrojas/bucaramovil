import 'package:bucaramovil/controllers/db_firebase_dev.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateCommentPage extends StatefulWidget {
  final String postId;

  const CreateCommentPage({super.key, required this.postId});

  @override
  State<CreateCommentPage> createState() => _CreateCommentPageState();
}

class _CreateCommentPageState extends State<CreateCommentPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addComment(String comment) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Debes iniciar sesión para comentar');
      }

      // Estructura recomendada para comentarios (ver structure_data.txt)
      final commentData = {
        'userId': user.uid,
        'userName': user.displayName ?? 'Anónimo',
        'commentText': comment,
        'timestamp': DateTime.now(),
      };

      await addCommentToPost(widget.postId, commentData);

      Navigator.pop(context); // Volver a CommentsPage
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Agregar Comentario'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Escribe tu comentario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  _addComment(text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El comentario no puede estar vacío'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.send),
              label: const Text("Enviar"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
