import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AgregarComentarioWidget extends StatefulWidget {
  final String postId;
  const AgregarComentarioWidget({required this.postId});

  @override
  State<AgregarComentarioWidget> createState() =>
      _AgregarComentarioWidgetState();
}

class _AgregarComentarioWidgetState extends State<AgregarComentarioWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextField(controller: controller)),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && controller.text.isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .update({
                    'comments': FieldValue.arrayUnion([
                      {
                        'userId': user.uid,
                        'userName': user.displayName ?? 'Anónimo',
                        'commentText': controller.text,
                        'timestamp': FieldValue.serverTimestamp(),
                      },
                    ]),
                  });
              controller.clear();
            }
          },
        ),
      ],
    );
  }
}
