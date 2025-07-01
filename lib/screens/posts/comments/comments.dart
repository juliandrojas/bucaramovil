import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentsPage extends StatelessWidget {
  final String postId;

  const CommentsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: CustomAppBar(title: 'Comentarios'),
      body: _buildCommentsBody(context, currentUser),
      floatingActionButton: _buildAddCommentButton(
        context,
        postId,
        currentUser,
      ),
    );
  }

  Widget _buildCommentsBody(BuildContext context, User? currentUser) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No hay comentarios.'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        List<dynamic> commentsDynamic = data['comments'] ?? [];
        if (commentsDynamic.isEmpty) {
          return const Center(child: Text('No hay comentarios.'));
        }
        return ListView.builder(
          itemCount: commentsDynamic.length,
          itemBuilder: (context, index) {
            final comment = commentsDynamic[index];
            return ListTile(
              title: Text(comment['commentText'] ?? ''),
              subtitle: Text(comment['userName'] ?? ''),
              trailing: comment['timestamp'] != null
                  ? Text(
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format((comment['timestamp'] as Timestamp).toDate()),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  Widget _buildAddCommentButton(
    BuildContext context,
    String postId,
    User? currentUser,
  ) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getPostData(postId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final data = snapshot.data!;
        final String authorId = data['userId'] ?? '';
        final bool isAuthor = currentUser?.uid == authorId;

        return Visibility(
          visible: isAuthor,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/create_comment',
                arguments: {'postId': postId}, // <-- Así debe ser
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> getPostData(String postId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }
}
