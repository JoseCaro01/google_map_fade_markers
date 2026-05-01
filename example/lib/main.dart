import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_map_fade_markers/google_map_fade_markers.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ClusterManagerId _managerId = const ClusterManagerId("zona_norte");
  int _testStep = 0;
  late final Set<Marker> markers;

  @override
  void initState() {
    markers = {
      Marker(
        markerId: MarkerId("1"),
        position: LatLng(40.463669, -4.749220),
        clusterManagerId: _managerId,
      ),
      Marker(
        markerId: MarkerId("11"),
        position: LatLng(40.463675, -4.749220),
        clusterManagerId: _managerId,
      ),
      Marker(
        markerId: MarkerId("1111"),
        position: LatLng(40.463680, -4.749220),
        clusterManagerId: _managerId,
      ),
      Marker(
        markerId: MarkerId("2"),
        position: LatLng(39.463669, -4.749220),
        clusterManagerId: _managerId,
      ),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMapFadeMarkers(
          initialCameraPosition: const CameraPosition(
            target: LatLng(40.463669, -3.749220),
          ),
          markers: markers,
          clusterManagers: {ClusterManager(clusterManagerId: _managerId)},
          onZoomMove: (zoomType, actualZoom) {
            log(zoomType.toString());
          },
          onTap: (argument) {
            _handleMapTap();
            setState(() {});
          },
        ),
      ),
    );
  }

  void _handleMapTap() {
    setState(() {
      switch (_testStep) {
        case 0:
          markers.clear();
          markers.addAll({
            Marker(
              markerId: MarkerId("1"),
              position: LatLng(41.000000, -4.000000),
              clusterManagerId: _managerId,
            ),
            Marker(
              markerId: MarkerId("11"),
              position: LatLng(40.463675, -4.749220),
              clusterManagerId: _managerId,
            ),
            Marker(
              markerId: MarkerId("1111"),
              position: LatLng(40.463680, -4.749220),
              clusterManagerId: _managerId,
            ),
            Marker(
              markerId: MarkerId("2"),
              position: LatLng(39.463669, -4.749220),
              clusterManagerId: _managerId,
            ),
          });
          break;

        case 1:
          markers.add(
            Marker(
              markerId: MarkerId("3"),
              position: LatLng(40.000000, -3.000000),
              clusterManagerId: _managerId,
            ),
          );
          break;

        case 2:
          markers.removeWhere((m) => m.markerId.value == "2");
          break;

        case 3:
          markers.clear();
          markers.addAll({
            Marker(
              markerId: MarkerId("10"),
              position: LatLng(38.0, -3.5),
              clusterManagerId: _managerId,
            ),
            Marker(
              markerId: MarkerId("11"),
              position: LatLng(38.5, -3.5),
              clusterManagerId: _managerId,
            ),
          });
          break;
      }
      _testStep = (_testStep + 1) % 4; // Rotar ciclo
    });
  }
}
