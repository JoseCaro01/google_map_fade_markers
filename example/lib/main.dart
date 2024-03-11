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
  final Set<Marker> markers = {
    const Marker(
        markerId: MarkerId("1"), position: LatLng(40.463669, -4.749220)),
    const Marker(
        markerId: MarkerId("2"), position: LatLng(39.463669, -4.749220)),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: GoogleMapFadeMarkers(
        initialCameraPosition: const CameraPosition(
          target: LatLng(40.463669, -3.749220),
        ),
        markers: markers,
        onZoomMove: (zoomType, actualZoom) {
          log(zoomType.toString());
        },
        onTap: (argument) {
          markers
            ..clear()
            ..addAll(changeMarkers());
          setState(() {});
        },
      )),
    );
  }

  Set<Marker> changeMarkers() => {
        const Marker(
            markerId: MarkerId("3"), position: LatLng(37.463669, -4.749220)),
        const Marker(
            markerId: MarkerId("4"), position: LatLng(34.463669, -4.749220)),
      };
}
