import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends ChangeNotifier {
  // Controlador para manejar el estado del mapa
  final Map<MarkerId, Marker> _markers = {};
  // Lista de marcadores en el mapa
  Set<Marker> get markers => _markers.values.toSet();
  final initialCameraPosition = CameraPosition(
    target: LatLng(7.1254, -73.1198), // Coordenadas de Bucaramanga
    zoom: 45, // Nivel de zoom inicial
  );
  void onTap(
    LatLng position,
    //BuildContext context
  ) {
    debugPrint("Tapped at: $position");
    //Navigator.pushNamed(context, '/post/test', arguments: position);
  }

  /*void onTap(LatLng position) {
    final markerId = MarkerId(position.toString());
    final marker = Marker(markerId: markerId, position: position);
    _markers[markerId] = marker; // Agrega el marcador al mapa
    notifyListeners(); // Notifica a los oyentes que el estado ha cambiado
    debugPrint("Marker added at: $position");
  }*/
}
