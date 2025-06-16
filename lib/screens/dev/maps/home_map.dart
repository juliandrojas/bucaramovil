import 'package:bucaramovil/controllers/map_controller.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeMapPage extends StatelessWidget {
  const HomeMapPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapController>(
      create: (_) => MapController(),
      child: Scaffold(
        appBar: CustomAppBar(title: "Mapa"),
        body: Consumer<MapController>(
          builder: (_, controller, _) => GoogleMap(
            markers: controller.markers, // Marcadores del controlador
            initialCameraPosition: controller.initialCameraPosition,
            myLocationButtonEnabled: true, // Botón de ubicación
            myLocationEnabled: true, // Ubicación del usuario
            mapType: MapType.normal, // Tipo de mapa normal
            compassEnabled: true, // Brújula
            zoomControlsEnabled: true, // Controles de zoom
            rotateGesturesEnabled: true, // Gestos de rotación
            onTap: controller.onTap,
            onLongPress: (position) {
              // Aquí puedes manejar el evento de long press en el mapa
              debugPrint("Long Pressed at: $position");
            },
          ),
        ),
      ),
    );
  }
}
