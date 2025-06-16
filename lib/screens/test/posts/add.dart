import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNameTestPage extends StatefulWidget {
  const AddNameTestPage({Key? key});

  @override
  _AddNameTestPageState createState() => _AddNameTestPageState();
}

class _AddNameTestPageState extends State<AddNameTestPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _severity = 'red'; // Valor por defecto

  void _submitPost() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('La descripción es obligatoria')));
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No hay usuario autenticado.");
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'description': _descriptionController.text,
        'imageUrl': _imageUrlController.text.isNotEmpty
            ? _imageUrlController.text
            : '',
        'location': _locationController.text.isNotEmpty
            ? _locationController.text
            : 'Desconocido',
        'severity': _severity,
        'comments': [], // Inicialmente sin comentarios
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('¡Post creado exitosamente!')));

      Navigator.pop(context); // Regresa a la página anterior
    } catch (e) {
      debugPrint("Error al crear el post: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hubo un error al crear el post')));
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Post"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: "URL de la imagen",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Ubicación",
                border: OutlineInputBorder(),
              ),
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
}
