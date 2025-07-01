import 'package:bucaramovil/controllers/db_firebase_dev.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';
import 'package:bucaramovil/screens/components/post_card.dart';

class LocationPostsPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  //final List posts;

  const LocationPostsPage({
    super.key,
    required this.latitude,
    required this.longitude,
    //required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Publicaciones cercanas"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getPostsForLatLong(),
        builder: (context, snapshot) {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Text(post['description'] ?? 'Sin descripción');
            },
          );
        },
      ),
    );
  }
}
