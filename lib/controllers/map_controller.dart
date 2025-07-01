import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  final initialCameraPosition = CameraPosition(
    target: LatLng(7.1254, -73.1198),
    zoom: 15,
  );

  void onTapTest(LatLng position, BuildContext context) async {
    final double lat = position.latitude;
    final double lng = position.longitude;
    debugPrint('Coordenadas tocadas: $lat, $lng');
    await Navigator.pushNamed(
      context,
      '/create_post',
      arguments: {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
    );
    // Al volver, recarga los marcadores
    await cargarMarcadoresDesdeFirestore(context);
  }

  List<Map<String, dynamic>> serializarPosts(List<Map<String, dynamic>> posts) {
    return posts.map((post) {
      final newPost = Map<String, dynamic>.from(post);

      // Convierte createdAt
      if (newPost['createdAt'] != null && newPost['createdAt'] is Timestamp) {
        newPost['createdAt'] = (newPost['createdAt'] as Timestamp)
            .toDate()
            .toIso8601String();
      }

      // Serializa comentarios si existen y son mapas
      final commentsList = (newPost['comments'] is List)
          ? newPost['comments'] as List
          : <dynamic>[];
      newPost['comments'] = commentsList.whereType<Map<String, dynamic>>().map((
        comment,
      ) {
        final c = Map<String, dynamic>.from(comment);
        if (c['timestamp'] != null && c['timestamp'] is Timestamp) {
          c['timestamp'] = (c['timestamp'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        return c;
      }).toList();

      // Asegura campos mínimos y tipos
      newPost['description'] =
          newPost['description']?.toString() ?? 'Sin descripción';
      newPost['author'] = newPost['author']?.toString() ?? 'Anónimo';
      newPost['severity'] = newPost['severity']?.toString() ?? '';
      newPost['location'] =
          (newPost['location'] is Map && newPost['location'] != null)
          ? newPost['location']
          : {'latitude': 0.0, 'longitude': 0.0};
      newPost['uid'] = newPost['uid']?.toString() ?? '';

      return newPost;
    }).toList();
  }

  void onMarkerTapped(BuildContext context, LatLng position) async {
    debugPrint("Function onMarkerTapped at: $position");
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Crear Comentario en esta ubicación"),
                onTap: () async {
                  debugPrint("Navegando a crear comentario en esta ubicación");
                  final posts = await buscarPostsPorUbicacion(
                    position.latitude,
                    position.longitude,
                  );
                  if (posts.isNotEmpty) {
                    final postId = posts.first['uid'];
                    Navigator.pop(context); // Cierra el modal antes de navegar
                    Navigator.pushNamed(
                      context,
                      '/create_comment',
                      arguments: {'postId': postId},
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No hay post en esta ubicación'),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                title: const Text("Ver Comentarios en esta ubicación"),
                onTap: () async {
                  debugPrint("Navegando a ver comentarios en esta ubicación");
                  final posts = await buscarPostsPorUbicacion(
                    position.latitude,
                    position.longitude,
                  );
                  if (posts.isNotEmpty) {
                    final postId = posts.first['uid'];
                    Navigator.pop(context); // Cierra el modal antes de navegar
                    Navigator.pushNamed(
                      context,
                      '/comments',
                      arguments: {'postId': postId},
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No hay post en esta ubicación'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onTap(LatLng position, BuildContext context, post) async {
    debugPrint("Tapped at: $position, navegando a comentarios...");
  }

  Future<Map<String, dynamic>?> buscarPostPorUbicacion(
    LatLng position, {
    double tolerancia = 0.001,
  }) async {
    final snapshot = await FirebaseFirestore.instance.collection('posts').get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final loc = data['location'];
      if (loc != null &&
          (loc['latitude'] - position.latitude).abs() < tolerancia &&
          (loc['longitude'] - position.longitude).abs() < tolerancia) {
        return {...data, 'uid': doc.id};
      }
    }
    return null;
  }

  Future<void> cargarMarcadoresDesdeFirestore(BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance.collection('posts').get();
    _markers.clear();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final loc = data['location'];
      if (loc != null) {
        final position = LatLng(loc['latitude'], loc['longitude']);
        final markerId = MarkerId(doc.id);
        //final post = {...data, 'uid': doc.id};
        _markers[markerId] = Marker(
          markerId: markerId,
          position: position,
          onTap: () => onMarkerTapped(context, position),
        );
      }
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> buscarPostsPorUbicacion(
    double latitude,
    double longitude, {
    double tolerancia = 0.001, // tolerancia más amplia
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .get();
      List<Map<String, dynamic>> posts = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final loc = data['location'];
        if (loc != null &&
            (loc['latitude'] - latitude).abs() < tolerancia &&
            (loc['longitude'] - longitude).abs() < tolerancia) {
          posts.add({...data, 'uid': doc.id});
        }
      }
      return posts;
    } catch (e) {
      debugPrint('Error al buscar posts por ubicación: $e');
      return [];
    }
  }
}
