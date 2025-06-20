import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = '/comments';

  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recibir los datos del post desde Navigator.pushNamed()
    final Map<String, dynamic>? post =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Datos del post
    final String nombre = post?['nombre'] ?? 'Anónimo';
    final String descripcion = post?['description'] ?? 'Sin descripción';
    final String ubicacion = post?['location'] ?? 'Sin ubicación';
    final String gravedad = post?['severity'] ?? 'Sin gravedad';
    final String imageUrl = post?['imageUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta del post
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.7),
                          radius: 20,
                          child: Text(
                            nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(descripcion),
                    if (imageUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ubicacion,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          gravedad,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Título de comentarios
            const Text(
              'Comentarios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Lista de comentarios (simulada por ahora)
            _buildComment(
              'Juan Pérez',
              'Buena observación, gracias por reportarlo.',
            ),
            _buildComment(
              'María López',
              'Estoy de acuerdo, hay que solucionarlo pronto.',
            ),
            _buildComment('Anónimo', 'Interesante.', isAnonymous: true),

            const SizedBox(height: 30),

            // Campo para agregar comentario
            const Text(
              'Escribe un comentario:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe aquí...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Aquí puedes integrar Firebase para guardar el comentario
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comentario enviado')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar un comentario individual
  Widget _buildComment(String autor, String texto, {bool isAnonymous = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 18,
            child: Text(
              isAnonymous ? '?' : autor[0].toUpperCase(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAnonymous ? 'Anónimo' : autor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(texto, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
