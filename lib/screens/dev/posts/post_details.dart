import 'package:bucaramovil/controllers/db_firebase_dev.dart';
import 'package:flutter/material.dart';

class PostDetailsPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailsPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late Future<List<String>> _commentsFuture;

  @override
  void initState() {
    super.initState();

    // Validar que widget.post contenga 'uid'
    if (widget.post.containsKey('uid')) {
      String postId = widget.post['uid']; // 👈 Usa 'uid' como identificador
      _commentsFuture = getPostComments(postId);
    } else {
      debugPrint("El campo 'uid' no existe en widget.post");
      _commentsFuture = Future.value(
        [],
      ); // Devuelve una lista vacía si no hay comentarios
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalles del Post")),
      body: FutureBuilder<List<String>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final comments = snapshot.data ?? [];
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(comments[index]));
            },
          );
        },
      ),
    );
  }
}
