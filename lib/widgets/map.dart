import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  const Map(MapController mapController, MarkerLayer markerLayer, {super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              maxZoom: 13.0,
              initialCenter: LatLng(50.8476, 4.3572),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                // Plenty of other options available!
              ),
            ],
          ),
        ],
      ),
    );
  }
}
