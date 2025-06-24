import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bucaramovil/controllers/db_firebase_dev.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  late double _latitude;
  late double _longitude;
  String _severity = "low"; // Puedes cambiar por valores reales más adelante

  final List<String> severities = ['low', 'medium', 'high'];

  Future<void> _submitPost(BuildContext context) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final double? _latitude = args?['latitude'];
    final double? _longitude = args?['longitude'];
    final description = _descriptionController.text.trim();

    // Valida que haya texto
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La descripción no puede estar vacía')),
      );
      return;
    }

    try {
      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se recibieron coordenadas válidas')),
        );
        return;
      }

      await createPost(
        'Anónimo',
        FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
        description,
        _latitude!,
        _longitude!,
        _severity,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicación creada correctamente')),
      );

      Navigator.pop(context); // Volver a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al crear publicación: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Crear Publicación'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de descripción
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Escribe una descripción del problema',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, escribe una descripción.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Selector de gravedad
            const Text("Gravedad del problema"),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _severity,
              items: severities.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _severity = newValue;
                  });
                }
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 24),

            // Botón para enviar el post
            ElevatedButton.icon(
              onPressed: () => _submitPost(context),
              icon: const Icon(Icons.send),
              label: const Text("Publicar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
