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

  List<Map<String, dynamic>> serializarPosts(List<Map<String, dynamic>> posts) {
    return posts.map((post) {
      final newPost = Map<String, dynamic>.from(post);
      // Convierte Timestamp a String si existe
      if (newPost['createdAt'] != null && newPost['createdAt'] is Timestamp) {
        newPost['createdAt'] = (newPost['createdAt'] as Timestamp)
            .toDate()
            .toIso8601String();
      }
      // Si tienes otros campos tipo Timestamp, conviértelos aquí también
      return newPost;
    }).toList();
  }

  void onMarkerTapped(
    BuildContext context,
    LatLng position,
    Map<String, dynamic>? post,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Ver post'),
                onTap: () async {
                  Navigator.pop(context);
                  // Busca todos los posts de esa ubicación
                  final posts = await buscarPostsPorUbicacion(
                    position.latitude,
                    position.longitude,
                  );
                  if (posts.isNotEmpty) {
                    final serializados = serializarPosts(posts);
                    Navigator.pushNamed(
                      context,
                      '/location_posts',
                      arguments: {
                        'latitude': position.latitude,
                        'longitude': position.longitude,
                        'posts': serializados,
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No hay publicaciones en esta ubicación.',
                        ),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Crear uno nuevo'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/create_post',
                    arguments: {
                      'latitude': position.latitude,
                      'longitude': position.longitude,
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onTap(LatLng position, BuildContext context) async {
    debugPrint("Tapped at: $position");

    // Si el usuario crea un post, espera a que termine y recarga los marcadores
    final post = await buscarPostPorUbicacion(position);

    if (post == null) {
      // Navega a crear post y espera a que regrese
      await Navigator.pushNamed(
        context,
        '/create_post',
        arguments: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );
      // Recarga los marcadores desde Firestore
      await cargarMarcadoresDesdeFirestore(context);
    }

    // Busca el post actualizado después de recargar
    final updatedPost = await buscarPostPorUbicacion(position);

    // Abre el modal con el post actualizado (si existe)
    onMarkerTapped(context, position, updatedPost);
  }

  Future<Map<String, dynamic>?> buscarPostPorUbicacion(
    LatLng position, {
    double tolerancia = 0.0005,
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
        final post = {...data, 'uid': doc.id};
        _markers[markerId] = Marker(
          markerId: markerId,
          position: position,
          onTap: () => onMarkerTapped(context, position, post),
        );
      }
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> buscarPostsPorUbicacion(
    double latitude,
    double longitude, {
    double tolerancia = 0.0005,
  }) async {
    final snapshot = await FirebaseFirestore.instance.collection('posts').get();
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
  }
}
