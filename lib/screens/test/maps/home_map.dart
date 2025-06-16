/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bucaramovil/controllers/map_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomeMapPage extends StatelessWidget {
  const HomeMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final controller = MapState();
        // Puedes agregar listeners adicionales aquí si es necesario
        return controller;
      },
      child: Scaffold(body: const _HomeMapView()),
    );
  }
}

class _HomeMapView extends StatelessWidget {
  const _HomeMapView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapState>();

    return GoogleMap(
      markers: controller.markers,
      onMapCreated: controller.onMapCreated,
      initialCameraPosition: controller.initialCameraPosition,
      myLocationEnabled: controller.locationGranted,
      myLocationButtonEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      mapType: MapType.normal,
      onTap: controller.onTap,
    );
  }
}

class MapState with ChangeNotifier {
  final MapController _mapController = MapController();
  GoogleMapController? _googleMapController;
  bool _locationGranted = false;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(7.119349, -73.122741), // Coordenadas de Bucaramanga
    zoom: 15.0,
  );

  MapState() {
    _mapController.addListener(() {
      notifyListeners();
    });
    _checkLocationPermission();
  }

  bool get locationGranted => _locationGranted;
  Set<Marker> get markers => _mapController.markers;
  Function(LatLng)? get onTap => _mapController.onTap;
  Function(GoogleMapController)? get onMapCreated => _onMapCreated;

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _locationGranted = false;
      notifyListeners();
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    _locationGranted = true;
    initialCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15.0,
    );
    notifyListeners();

    _googleMapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    // Puedes agregar lógica adicional cuando el mapa se crea
  }
}
 */
