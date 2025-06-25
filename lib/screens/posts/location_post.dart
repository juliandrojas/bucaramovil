import 'package:flutter/material.dart';

class LocationPostsPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final List posts;

  const LocationPostsPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Publicaciones en este lugar')),
        body: const Center(
          child: Text('No hay publicaciones en esta ubicación.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones en este lugar')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index] as Map<String, dynamic>;
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(post['description'] ?? 'Sin descripción'),
              subtitle: Text('Autor: ${post['author'] ?? 'Anónimo'}'),
              trailing: Text(post['severity'] ?? ''),
              onTap: () {
                Navigator.pushNamed(context, '/post_details', arguments: post);
              },
            ),
          );
        },
      ),
    );
  }
}