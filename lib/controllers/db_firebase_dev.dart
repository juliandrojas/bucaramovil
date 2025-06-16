import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Instancia de Firestore
FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> createPost(
  String description,
  String? imageUrl,
  double latitude,
  double longitude,
  String severity,
) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No hay usuario autenticado.");
    }

    await FirebaseFirestore.instance.collection('posts').add({
      'userId': user.uid,
      'description': description,
      'imageUrl': imageUrl ?? '',
      'location': {'latitude': latitude, 'longitude': longitude},
      'severity': severity,
      'comments': [], // Inicialmente sin comentarios
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Error al crear el post: $e");
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getPosts() async {
  List<Map<String, dynamic>> posts = [];
  try {
    CollectionReference collection = db.collection('ejemplo');
    QuerySnapshot queryPost = await collection.get();
    for (var doc in queryPost.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Agrega el UID del documento a los datos
      final document = {
        'nombre': data['nombre'] ?? '',
        /*'createdAt': data['createdAt'] ?? '',
        'description': data['description'] ?? '',
        'imageUrl': data['imageUrl'] ?? '',
        'location': data['location'] ?? {},
        'severity': data['severity'] ?? '',
        'comments': data['comments'] ?? [],
        'userId': data['userId'] ?? '',*/
        "uid": doc.id, // Usa el ID del documento como identificador
      };
      posts.add(document);
    }
  } catch (e) {
    debugPrint("Error al obtener la colección: $e");
  }
  return posts;
}

Future<void> deletePost(String uid) async {
  await db.collection('people').doc(uid).delete();
}

Future<List<String>> getPostComments(String postId) async {
  try {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get();
    if (!document.exists) {
      return [];
    }

    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    List<dynamic> comments =
        data['comments'] ?? []; // Asegúrate de que 'comments' sea una lista
    return comments.cast<String>();
  } catch (e) {
    debugPrint("Error al obtener los comentarios: $e");
    return [];
  }
}
