import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String description;
  final String imageUrl;
  final String location;
  final String severity;
  final List<String> comments; // Si comments es un array en Firestore

  Post({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.severity,
    required this.comments,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? 'Desconocida',
      severity: data['severity'] ?? 'neutral',
      comments: List<String>.from(data['comments'] ?? []),
    );
  }
}
