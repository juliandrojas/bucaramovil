import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ComentariosWidget extends StatelessWidget {
  final String postId;
  const ComentariosWidget({required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final comments = data['comments'] as List<dynamic>? ?? [];
        return ListView(
          children: comments
              .map(
                (c) => ListTile(
                  title: Text(c['userName'] ?? ''),
                  subtitle: Text(c['commentText'] ?? ''),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
