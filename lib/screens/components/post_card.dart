import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onComments;
  final VoidCallback? onTap;
  const PostCard({super.key, required this.post, this.onComments, this.onTap});

  @override
  Widget build(BuildContext context) {
    final location = post['location'];
    final lat = location != null && location['latitude'] != null
        ? location['latitude'].toStringAsFixed(4)
        : 'N/A';
    final lng = location != null && location['longitude'] != null
        ? location['longitude'].toStringAsFixed(4)
        : 'N/A';
    final author = post['author'] ?? 'Anónimo';
    final description = post['description'] ?? 'Sin descripción';
    final severity = post['severity']?.toString() ?? 'Sin gravedad';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Avatar + Autor
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.7),
                    radius: 20,
                    child: Text(
                      author.isNotEmpty ? author[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Puedes agregar fecha aquí si lo deseas
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(fontSize: 15, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Lat: $lat, Lng: $lng',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    severity,
                    style: const TextStyle(fontSize: 14, color: Colors.orange),
                  ),
                ],
              ),
              const Divider(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onComments,
                  icon: const Icon(Icons.comment_outlined, size: 16),
                  label: const Text("Ver comentarios"),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
