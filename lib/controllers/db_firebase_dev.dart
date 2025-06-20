import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Instancia de Firestore
FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> createPost(
  String author,
  String userId,
  String description,
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
      'author': user.displayName ?? 'Anónimo',
      'userId': user.uid,
      'description': description,
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
    CollectionReference collection = FirebaseFirestore.instance.collection(
      'posts',
    );
    QuerySnapshot queryPost = await collection.get();

    queryPost.docs.forEach((document) {
      final data = document.data() as Map<String, dynamic>;
      // Añadimos el ID del documento al mapa
      posts.add({
        ...data,
        'uid': document.id, // <-- Aquí añadimos el ID del post
      });
    });
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
