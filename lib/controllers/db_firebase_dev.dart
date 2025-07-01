import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Instancia de Firestore
FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference posts = FirebaseFirestore.instance.collection(
  'posts',
);

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
      'comments': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    debugPrint("Publicación creada exitosamente");
  } catch (e) {
    debugPrint("Error al crear el post: $e");
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getPosts() async {
  List<Map<String, dynamic>> posts = [];
  try {
    QuerySnapshot queryPost = await FirebaseFirestore.instance
        .collection('posts')
        .get();

    for (var document in queryPost.docs) {
      final data = document.data() as Map<String, dynamic>;
      posts.add({...data, 'uid': document.id});
    }
  } catch (e) {
    debugPrint("Error al obtener los posts: $e");
  }
  return posts;
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

Future<List<Map<String, dynamic>>> getPostsForLatLong() async {
  List<Map<String, dynamic>> posts = [];
  try {
    QuerySnapshot queryPost = await FirebaseFirestore.instance
        .collection('posts')
        .get();

    for (var document in queryPost.docs) {
      final data = document.data() as Map<String, dynamic>;
      if (data.containsKey('location') &&
          data['location'] is Map<String, dynamic> &&
          data['location'].containsKey('latitude') &&
          data['location'].containsKey('longitude')) {
        posts.add({...data, 'uid': document.id});
      }
    }
  } catch (e) {
    debugPrint("Error al obtener los posts por ubicación: $e");
  }
  return posts;
}

/// Añade un comentario al post especificado
Future<void> addCommentToPost(
  String postId,
  Map<String, dynamic> comment,
) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([comment]),
    });
  } catch (e) {
    throw Exception("Error al guardar el comentario: $e");
  }
}

Future<void> updateComment(
  String postId,
  int commentIndex,
  String newComment,
) async {
  DocumentReference postRef = posts.doc(postId);

  return await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(postRef);
    if (!snapshot.exists) throw Exception("El post no existe");

    List<dynamic> comments =
        (snapshot.data() as Map<String, dynamic>)['comments'];

    if (commentIndex >= comments.length || commentIndex < 0) {
      throw Exception("Índice de comentario inválido");
    }

    comments[commentIndex] = newComment;

    transaction.update(postRef, {'comments': comments});
  });
}

Future<void> deleteComment(String postId, int commentIndex) async {
  DocumentReference postRef = posts.doc(postId);

  return await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(postRef);
    if (!snapshot.exists) throw Exception("El post no existe");

    List<dynamic> comments =
        (snapshot.data() as Map<String, dynamic>)['comments'];

    if (commentIndex >= comments.length || commentIndex < 0) {
      throw Exception("Índice de comentario inválido");
    }

    // Eliminamos el comentario
    comments.removeAt(commentIndex);

    transaction.update(postRef, {'comments': comments});
  });
}

Future<void> deletePost(String uid) async {
  await db.collection('people').doc(uid).delete();
}
