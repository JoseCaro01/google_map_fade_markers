import 'package:equatable/equatable.dart';

class OpacityMarkers extends Equatable {
  const OpacityMarkers({
    required this.previousMarkersOpacity,
    required this.currentMarkersOpacity,
  });
  final double previousMarkersOpacity;
  final double currentMarkersOpacity;

  @override
  List<Object?> get props => [previousMarkersOpacity, currentMarkersOpacity];
}
