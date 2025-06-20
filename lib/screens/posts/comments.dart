import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsPage extends StatelessWidget {
  final String postId;

  const CommentsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Comentarios'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_comment', arguments: postId);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<String>>(
        future: _getPostComments(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay comentarios.'));
          } else {
            final comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(comments[index]),
                    subtitle: Text('Comentario #${index + 1}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _getPostComments(String postId) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();

      if (!document.exists) return [];

      final data = document.data() as Map<String, dynamic>;
      List<dynamic> comments = data['comments'] ?? [];

      return comments.cast<String>();
    } catch (e) {
      debugPrint("Error obteniendo comentarios: $e");
      return [];
    }
  }
}
