import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';

class PostDetailsPage extends StatelessWidget {
  final Map<String, dynamic> post;
  const PostDetailsPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final location = post['location'];
    final lat = location != null && location['latitude'] != null
        ? location['latitude'].toString()
        : 'N/A';
    final lng = location != null && location['longitude'] != null
        ? location['longitude'].toString()
        : 'N/A';

    return Scaffold(
      appBar: CustomAppBar(title: 'Detalles del Post'),
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
            Text('Ubicación: Lat $lat, Lng $lng'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: post['uid'] != null
                  ? () {
                      Navigator.pushNamed(
                        context,
                        '/comments',
                        arguments: {'postId': post['uid']},
                      );
                    }
                  : null,
              icon: const Icon(Icons.comment),
              label: const Text('Ver comentarios'),
            ),
          ],
        ),
      ),
    );
  }
}
