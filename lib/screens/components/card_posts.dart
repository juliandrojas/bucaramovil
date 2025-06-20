import 'package:bucaramovil/screens/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = formatDate(post.createdAt);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/comments', arguments: post);
      },
      onLongPress: () {
        Navigator.pushNamed(context, '/edit_post', arguments: post);
      },
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
              // Fila superior: Autor + Nombre
              Row(
                children: [
                  // Avatar del autor
                  CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.7),
                    radius: 20,
                    child: Text(
                      post.userId.isNotEmpty
                          ? post.userId[0].toUpperCase()
                          : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      post.userId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Imagen del post
              if (post.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post.imageUrl,
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
                ),
              const SizedBox(height: 12),

              // Descripción del post
              Text(
                post.description,
                style: const TextStyle(fontSize: 15, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Fecha de creación
              Row(
                children: [
                  const Icon(Icons.create, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Ubicación e icono
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    post.location,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),

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
                    post.severity,
                    style: const TextStyle(fontSize: 14, color: Colors.orange),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Botón de comentarios
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/comments', arguments: post);
                  },
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

  // Función para formatear fechas
  String formatDate(DateTime date) {
    return DateFormat('dd \\de MMMM \\de yyyy, hh:mm:ss a').format(date);
  }
}
