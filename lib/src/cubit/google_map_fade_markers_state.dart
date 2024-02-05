part of 'google_map_fade_markers_cubit.dart';

@freezed
class GoogleMapFadeMarkersState with _$GoogleMapFadeMarkersState {
  const GoogleMapFadeMarkersState._();

  const factory GoogleMapFadeMarkersState.initial() = Initial;

  const factory GoogleMapFadeMarkersState.animationPreviousMarkers({
    required double previousOpacity,
  }) = AnimationPreviousMarkers;

  const factory GoogleMapFadeMarkersState.animationCurrentMarkers({
    required double currentOpacity,
  }) = AnimationCurrentMarkers;

  OpacityMarkers get opacityMarkers => map(
        initial: (value) => const OpacityMarkers(
          previousMarkersOpacity: 0,
          currentMarkersOpacity: 1,
        ),
        animationPreviousMarkers: (value) => OpacityMarkers(
          previousMarkersOpacity: value.previousOpacity,
          currentMarkersOpacity: 0,
        ),
        animationCurrentMarkers: (value) => OpacityMarkers(
          previousMarkersOpacity: 0,
          currentMarkersOpacity: value.currentOpacity,
        ),
      );
}
