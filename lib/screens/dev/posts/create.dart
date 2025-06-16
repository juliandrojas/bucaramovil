import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
class CreatePostPagextends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final lat = args['latitude'];
    final lng = args['longitude'];
    // Formulario para crear el post, usando lat/lng
    // Al guardar, navega a detalles o regresa al mapa
  }
}*/

class CreatePostPage extends StatefulWidget {
  final Map<String, double>? initialLocation;

  const CreatePostPage({Key? key, this.initialLocation}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  String _severity = 'red';

  // Variables para lat/long (no se muestran en UI)
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();

    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();

    // Cargar lat/long si vienen de la navegación
    if (widget.initialLocation != null) {
      _latitude = widget.initialLocation!['latitude'];
      _longitude = widget.initialLocation!['longitude'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Crear Post"),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Descripción"),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: "URL de la imagen"),
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Gravedad:"),
                DropdownButton<String>(
                  value: _severity,
                  onChanged: (value) {
                    setState(() {
                      _severity = value!;
                    });
                  },
                  items: ['red', 'yellow', 'green'].map((String color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: _getSeverityColor(color),
                          ),
                          SizedBox(width: 8),
                          Text(color.toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _submitPost,
              icon: Icon(Icons.save),
              label: Text("Publicar"),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _submitPost() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('La descripción es obligatoria')));
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No hay usuario autenticado.");

      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'description': _descriptionController.text,
        'imageUrl': _imageUrlController.text.isNotEmpty
            ? _imageUrlController.text
            : '',
        'location': {
          'latitude':
              _latitude ?? FieldValue.serverTimestamp(), // Ejemplo de fallback
          'longitude': _longitude ?? FieldValue.serverTimestamp(),
        },
        'severity': _severity,
        'comments': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('¡Post creado exitosamente!')));

      Navigator.pop(context); // Regresar a la página anterior
    } catch (e) {
      debugPrint("Error al crear el post: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hubo un error al crear el post')));
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
