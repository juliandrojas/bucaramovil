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
                enabled: post != null,
                onTap: post != null
                    ? () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/comments',
                          arguments: {'postId': post['uid']},
                        );
                      }
                    : null,
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

    // Busca si ya existe un post en esa ubicación
    final post = await buscarPostPorUbicacion(position);

    final markerId = MarkerId(position.toString());
    final marker = Marker(
      markerId: markerId,
      position: position,
      onTap: () => onMarkerTapped(context, position, post),
    );
    _markers[markerId] = marker;
    notifyListeners();

    // Abre el modal automáticamente después de agregar el marcador
    onMarkerTapped(context, position, post);
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
}
