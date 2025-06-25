import 'package:flutter/material.dart';

class PostDetailsPage extends StatelessWidget {
  final Map<String, dynamic> post;
  const PostDetailsPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['description'] ?? 'Sin descripción',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Autor: ${post['author'] ?? 'Anónimo'}'),
            const SizedBox(height: 8),
            Text('Gravedad: ${post['severity'] ?? 'Sin gravedad'}'),
            const SizedBox(height: 8),
            Text(
              post['location'] != null
                  ? 'Ubicación: Lat ${post['location']['latitude']}, Lng ${post['location']['longitude']}'
                  : 'Sin ubicación',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/comments',
                  arguments: {'postId': post['uid']},
                );
              },
              icon: const Icon(Icons.comment),
              label: const Text('Ver comentarios'),
            ),
          ],
        ),
      ),
    );
  }
}
