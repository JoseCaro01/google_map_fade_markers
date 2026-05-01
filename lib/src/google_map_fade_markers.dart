import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_map_fade_markers/src/notifier/marker_fade_notifier.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ZoomType { zoomIn, zoomOut }

class GoogleMapFadeMarkers extends StatelessWidget {
  const GoogleMapFadeMarkers({
    super.key,
    required this.initialCameraPosition,
    this.onZoomMove,
    this.duration = const Duration(seconds: 1),
    this.style,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.webGestureHandling,
    this.webCameraControlPosition,
    this.webCameraControlEnabled = true,
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = true,
    this.fortyFiveDegreeImageryEnabled = false,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.layoutDirection,
    this.padding = EdgeInsets.zero,
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers = const <Marker>{},
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.circles = const <Circle>{},
    this.clusterManagers = const <ClusterManager>{},
    this.heatmaps = const <Heatmap>{},
    this.onCameraMoveStarted,
    this.tileOverlays = const <TileOverlay>{},
    this.groundOverlays = const <GroundOverlay>{},
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onLongPress,
    this.markerType = GoogleMapMarkerType.marker,
    this.colorScheme,
    this.mapId,
  });

  /// Callback method for when the map move zoom in or zoom out
  final void Function(ZoomType zoomType, double actualZoom)? onZoomMove;

  /// The duration of the markers fade animation. The animation total duration is the double of the specified value
  final Duration duration;

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;

  /// The style for the map.
  ///
  /// Set to null to clear any previous custom styling.
  ///
  /// If problems were detected with the [mapStyle], including un-parsable
  /// styling JSON, unrecognized feature type, unrecognized element type, or
  /// invalid styler keys, the style is left unchanged, and the error can be
  /// retrieved with [GoogleMapController.getStyleError].
  ///
  /// The style string can be generated using the
  /// [map style tool](https://mapstyle.withgoogle.com/).
  final String? style;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if the map should show a toolbar when you interact with the map. Android only.
  final bool mapToolbarEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  /// Type of map tiles to be rendered.
  final MapType mapType;

  /// The layout direction to use for the embedded view.
  ///
  /// If this is null, the ambient [Directionality] is used instead. If there is
  /// no ambient [Directionality], [TextDirection.ltr] is used.
  final TextDirection? layoutDirection;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  final bool zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should be in lite mode. Android only.
  ///
  /// See https://developers.google.com/maps/documentation/android-sdk/lite#overview_of_lite_mode for more details.
  final bool liteModeEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// True if 45 degree imagery should be enabled. Web only.
  final bool fortyFiveDegreeImageryEnabled;

  /// Padding to be set on map. See https://developers.google.com/maps/documentation/android-sdk/map#map_padding for more details.
  ///
  /// If no padding is specified, the default padding is 0.
  final EdgeInsets padding;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  /// Circles to be placed on the map.
  final Set<Circle> circles;

  /// Heatmaps to show on the map.
  final Set<Heatmap> heatmaps;

  /// Tile overlays to be placed on the map.
  final Set<TileOverlay> tileOverlays;

  /// Cluster Managers to be initialized for the map.
  ///
  /// On the web, an extra step is required to enable clusters.
  /// See https://pub.dev/packages/google_maps_flutter_web.
  final Set<ClusterManager> clusterManagers;

  /// Ground overlays to be initialized for the map.
  ///
  /// Support table for Ground Overlay features:
  /// | Feature                     | Android                  | iOS                      | Web |
  /// |-----------------------------|--------------------------|--------------------------|-----|
  /// | [GroundOverlay.image]       | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.bounds]      | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.position]    | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.width]       | Yes (with position only) | No                       | No  |
  /// | [GroundOverlay.height]      | Yes (with position only) | No                       | No  |
  /// | [GroundOverlay.anchor]      | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.zoomLevel]   | No                       | Yes (with position only) | No  |
  /// | [GroundOverlay.bearing]     | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.transparency]| Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.zIndex]      | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.visible]     | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.clickable]   | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.onTap]       | Yes                      | Yes                      | Yes |
  ///
  /// - On Android, [GroundOverlay.width] is required if
  ///   [GroundOverlay.position] is set.
  /// - On iOS, [GroundOverlay.zoomLevel] is required if
  ///   [GroundOverlay.position] is set.
  /// - [GroundOverlay.image] must be a [MapBitmap]. See [AssetMapBitmap] and
  ///   [BytesMapBitmap]. [MapBitmap.bitmapScaling] must be set to
  ///   [MapBitmapScaling.none].
  final Set<GroundOverlay> groundOverlays;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an
  /// onCameraMoveStarted call.
  ///
  /// This may be called as often as once every frame and should
  /// not perform expensive operations.
  final CameraPositionCallback? onCameraMove;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;

  /// Called every time a [GoogleMap] is tapped.
  final ArgumentCallback<LatLng>? onTap;

  /// Called every time a [GoogleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// This feature is not present in the Google Maps SDK for the web.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  final bool myLocationButtonEnabled;

  /// Enables or disables the indoor view from the map
  final bool indoorViewEnabled;

  /// Enables or disables the traffic layer of the map
  final bool trafficEnabled;

  /// Enables or disables showing 3D buildings where available
  final bool buildingsEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// This setting controls how the API handles gestures on the map. Web only.
  ///
  /// See [WebGestureHandling] for more details.
  final WebGestureHandling? webGestureHandling;

  /// This setting controls how the API handles cameraControl button position on the map. Web only.
  ///
  /// If null, the Google Maps API will use its default camera control position.
  ///
  /// See [WebCameraControlPosition] for more details.
  final WebCameraControlPosition? webCameraControlPosition;

  /// Enables or disables the Camera controls. Web only.
  ///
  /// See https://developers.google.com/maps/documentation/javascript/controls for more details.
  final bool webCameraControlEnabled;

  /// Identifier that's associated with a specific cloud-based map style.
  ///
  /// See https://developers.google.com/maps/documentation/get-map-id
  /// for more details.
  final String? mapId;

  /// Indicates whether map uses [AdvancedMarker]s or [Marker]s.
  ///
  /// [AdvancedMarker] and [Marker]s classes might not be related to each other
  /// in the platform implementation. It's important to set the correct
  /// [GoogleMapMarkerType] so that the platform implementation can handle the
  /// markers:
  /// * If [GoogleMapMarkerType.advancedMarker] is used, all markers must be of
  ///   type [AdvancedMarker].
  /// * If [GoogleMapMarkerType.marker] is used, markers cannot be of type
  ///   [AdvancedMarker].
  ///
  /// While some features work with either type, using the incorrect type
  /// may result in unexpected behavior.
  final GoogleMapMarkerType markerType;

  /// Color scheme for the cloud-style map. Web only.
  ///
  /// The colorScheme option can only be set when the map is initialized;
  /// setting this option after the map is created will have no effect.
  ///
  /// See https://developers.google.com/maps/documentation/javascript/mapcolorscheme for more details.
  final MapColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    return _CustomMap(
      onZoomMove: onZoomMove,
      duration: duration,
      clusterManagers: clusterManagers,
      colorScheme: colorScheme,
      groundOverlays: groundOverlays,
      heatmaps: heatmaps,
      mapId: mapId,
      markerType: markerType,
      style: style,
      webCameraControlEnabled: webCameraControlEnabled,
      webCameraControlPosition: webCameraControlPosition,
      buildingsEnabled: buildingsEnabled,
      webGestureHandling: webGestureHandling,
      cameraTargetBounds: cameraTargetBounds,
      circles: circles,
      compassEnabled: compassEnabled,
      fortyFiveDegreeImageryEnabled: fortyFiveDegreeImageryEnabled,
      gestureRecognizers: gestureRecognizers,
      indoorViewEnabled: indoorViewEnabled,
      layoutDirection: layoutDirection,
      liteModeEnabled: liteModeEnabled,
      mapToolbarEnabled: mapToolbarEnabled,
      mapType: mapType,
      minMaxZoomPreference: minMaxZoomPreference,
      myLocationButtonEnabled: myLocationButtonEnabled,
      myLocationEnabled: myLocationEnabled,
      onCameraMove: onCameraMove,
      onCameraMoveStarted: onCameraMoveStarted,
      onLongPress: onLongPress,
      onTap: onTap,
      padding: padding,
      polygons: polygons,
      polylines: polylines,
      rotateGesturesEnabled: rotateGesturesEnabled,
      scrollGesturesEnabled: scrollGesturesEnabled,
      tileOverlays: tileOverlays,
      tiltGesturesEnabled: tiltGesturesEnabled,
      trafficEnabled: trafficEnabled,
      zoomControlsEnabled: zoomControlsEnabled,
      zoomGesturesEnabled: zoomGesturesEnabled,
      initialCameraPosition: initialCameraPosition,
      markers: markers.map((e) => e.copyWith(alphaParam: 0)).toSet(),
      onCameraIdle: onCameraIdle,
      onMapCreated: onMapCreated,
    );
  }
}

class _CustomMap extends StatefulWidget {
  const _CustomMap({
    required this.initialCameraPosition,
    required this.duration,
    this.onZoomMove,
    this.style,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.webGestureHandling,
    this.webCameraControlPosition,
    this.webCameraControlEnabled = true,
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = true,
    this.fortyFiveDegreeImageryEnabled = false,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.layoutDirection,
    this.padding = EdgeInsets.zero,
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers = const <Marker>{},
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.circles = const <Circle>{},
    this.clusterManagers = const <ClusterManager>{},
    this.heatmaps = const <Heatmap>{},
    this.onCameraMoveStarted,
    this.tileOverlays = const <TileOverlay>{},
    this.groundOverlays = const <GroundOverlay>{},
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onLongPress,
    this.markerType = GoogleMapMarkerType.marker,
    this.colorScheme,
    this.mapId,
  });

  /// Callback method for when the map move zoom in or zoom out
  final void Function(ZoomType zoomType, double actualZoom)? onZoomMove;

  /// The duration of the markers fade animation. The animation total duration is the double of the specified value
  final Duration duration;

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;

  /// The style for the map.
  ///
  /// Set to null to clear any previous custom styling.
  ///
  /// If problems were detected with the [mapStyle], including un-parsable
  /// styling JSON, unrecognized feature type, unrecognized element type, or
  /// invalid styler keys, the style is left unchanged, and the error can be
  /// retrieved with [GoogleMapController.getStyleError].
  ///
  /// The style string can be generated using the
  /// [map style tool](https://mapstyle.withgoogle.com/).
  final String? style;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if the map should show a toolbar when you interact with the map. Android only.
  final bool mapToolbarEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  /// Type of map tiles to be rendered.
  final MapType mapType;

  /// The layout direction to use for the embedded view.
  ///
  /// If this is null, the ambient [Directionality] is used instead. If there is
  /// no ambient [Directionality], [TextDirection.ltr] is used.
  final TextDirection? layoutDirection;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  final bool zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should be in lite mode. Android only.
  ///
  /// See https://developers.google.com/maps/documentation/android-sdk/lite#overview_of_lite_mode for more details.
  final bool liteModeEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// True if 45 degree imagery should be enabled. Web only.
  final bool fortyFiveDegreeImageryEnabled;

  /// Padding to be set on map. See https://developers.google.com/maps/documentation/android-sdk/map#map_padding for more details.
  ///
  /// If no padding is specified, the default padding is 0.
  final EdgeInsets padding;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  /// Circles to be placed on the map.
  final Set<Circle> circles;

  /// Heatmaps to show on the map.
  final Set<Heatmap> heatmaps;

  /// Tile overlays to be placed on the map.
  final Set<TileOverlay> tileOverlays;

  /// Cluster Managers to be initialized for the map.
  ///
  /// On the web, an extra step is required to enable clusters.
  /// See https://pub.dev/packages/google_maps_flutter_web.
  final Set<ClusterManager> clusterManagers;

  /// Ground overlays to be initialized for the map.
  ///
  /// Support table for Ground Overlay features:
  /// | Feature                     | Android                  | iOS                      | Web |
  /// |-----------------------------|--------------------------|--------------------------|-----|
  /// | [GroundOverlay.image]       | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.bounds]      | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.position]    | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.width]       | Yes (with position only) | No                       | No  |
  /// | [GroundOverlay.height]      | Yes (with position only) | No                       | No  |
  /// | [GroundOverlay.anchor]      | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.zoomLevel]   | No                       | Yes (with position only) | No  |
  /// | [GroundOverlay.bearing]     | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.transparency]| Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.zIndex]      | Yes                      | Yes                      | No  |
  /// | [GroundOverlay.visible]     | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.clickable]   | Yes                      | Yes                      | Yes |
  /// | [GroundOverlay.onTap]       | Yes                      | Yes                      | Yes |
  ///
  /// - On Android, [GroundOverlay.width] is required if
  ///   [GroundOverlay.position] is set.
  /// - On iOS, [GroundOverlay.zoomLevel] is required if
  ///   [GroundOverlay.position] is set.
  /// - [GroundOverlay.image] must be a [MapBitmap]. See [AssetMapBitmap] and
  ///   [BytesMapBitmap]. [MapBitmap.bitmapScaling] must be set to
  ///   [MapBitmapScaling.none].
  final Set<GroundOverlay> groundOverlays;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an
  /// onCameraMoveStarted call.
  ///
  /// This may be called as often as once every frame and should
  /// not perform expensive operations.
  final CameraPositionCallback? onCameraMove;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;

  /// Called every time a [GoogleMap] is tapped.
  final ArgumentCallback<LatLng>? onTap;

  /// Called every time a [GoogleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// This feature is not present in the Google Maps SDK for the web.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  final bool myLocationButtonEnabled;

  /// Enables or disables the indoor view from the map
  final bool indoorViewEnabled;

  /// Enables or disables the traffic layer of the map
  final bool trafficEnabled;

  /// Enables or disables showing 3D buildings where available
  final bool buildingsEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// This setting controls how the API handles gestures on the map. Web only.
  ///
  /// See [WebGestureHandling] for more details.
  final WebGestureHandling? webGestureHandling;

  /// This setting controls how the API handles cameraControl button position on the map. Web only.
  ///
  /// If null, the Google Maps API will use its default camera control position.
  ///
  /// See [WebCameraControlPosition] for more details.
  final WebCameraControlPosition? webCameraControlPosition;

  /// Enables or disables the Camera controls. Web only.
  ///
  /// See https://developers.google.com/maps/documentation/javascript/controls for more details.
  final bool webCameraControlEnabled;

  /// Identifier that's associated with a specific cloud-based map style.
  ///
  /// See https://developers.google.com/maps/documentation/get-map-id
  /// for more details.
  final String? mapId;

  /// Indicates whether map uses [AdvancedMarker]s or [Marker]s.
  ///
  /// [AdvancedMarker] and [Marker]s classes might not be related to each other
  /// in the platform implementation. It's important to set the correct
  /// [GoogleMapMarkerType] so that the platform implementation can handle the
  /// markers:
  /// * If [GoogleMapMarkerType.advancedMarker] is used, all markers must be of
  ///   type [AdvancedMarker].
  /// * If [GoogleMapMarkerType.marker] is used, markers cannot be of type
  ///   [AdvancedMarker].
  ///
  /// While some features work with either type, using the incorrect type
  /// may result in unexpected behavior.
  final GoogleMapMarkerType markerType;

  /// Color scheme for the cloud-style map. Web only.
  ///
  /// The colorScheme option can only be set when the map is initialized;
  /// setting this option after the map is created will have no effect.
  ///
  /// See https://developers.google.com/maps/documentation/javascript/mapcolorscheme for more details.
  final MapColorScheme? colorScheme;

  @override
  State<_CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<_CustomMap> {
  late final Set<Marker> _ghostMarkers = {};
  late final Map<String, MarkerAnimationType> _markersAnimationType;
  late final GoogleMapController _googleMapController;
  final fadeInNotifier = MarkerFadeNotifier(0.0);
  final fadeOutNotifier = MarkerFadeNotifier(1.0);
  double _initialZoom = 0;
  double _finalZoom = 0;

  @override
  void initState() {
    super.initState();
    _initialZoom = widget.initialCameraPosition.zoom;
    _finalZoom = widget.initialCameraPosition.zoom;
    _markersAnimationType = Map.fromIterables(
        widget.markers.map((e) => e.markerId.value),
        widget.markers.map((e) => MarkerAnimationType.fadeIn));
    _startAnimationSequence();

    // _previousMarkers = {...widget.markers};
  }

  @override
  void didUpdateWidget(covariant _CustomMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _classifyMarkerChanges(oldWidget.markers, widget.markers);
    _startAnimationSequence();
  }

  @override
  void dispose() {
    fadeInNotifier.dispose();
    fadeOutNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final opacityMarkers = context
    //     .select((GoogleMapFadeMarkersCubit bloc) => bloc.state.opacityMarkers);
    return ValueListenableBuilder(
      valueListenable: fadeInNotifier,
      builder: (context, fadeInOpacity, child) => ValueListenableBuilder(
          valueListenable: fadeOutNotifier,
          builder: (context, outOpacity, child) => GoogleMap(
                  initialCameraPosition: widget.initialCameraPosition,
                  onMapCreated: (controller) {
                    _googleMapController = controller;
                    widget.onMapCreated?.call(controller);
                  },
                  onCameraIdle: () async {
                    widget.onCameraIdle?.call();
                    _finalZoom = await _googleMapController.getZoomLevel();
                    if (_initialZoom != _finalZoom) {
                      widget.onZoomMove?.call(
                          _initialZoom > _finalZoom
                              ? ZoomType.zoomOut
                              : ZoomType.zoomIn,
                          _finalZoom);
                    }
                  },
                  buildingsEnabled: widget.buildingsEnabled,
                  webGestureHandling: widget.webGestureHandling,
                  cameraTargetBounds: widget.cameraTargetBounds,
                  circles: widget.circles,
                  mapId: widget.mapId,
                  clusterManagers: widget.clusterManagers,
                  colorScheme: widget.colorScheme,
                  groundOverlays: widget.groundOverlays,
                  heatmaps: widget.heatmaps,
                  markerType: widget.markerType,
                  style: widget.style,
                  webCameraControlEnabled: widget.webCameraControlEnabled,
                  webCameraControlPosition: widget.webCameraControlPosition,
                  compassEnabled: widget.compassEnabled,
                  fortyFiveDegreeImageryEnabled:
                      widget.fortyFiveDegreeImageryEnabled,
                  gestureRecognizers: widget.gestureRecognizers,
                  indoorViewEnabled: widget.indoorViewEnabled,
                  layoutDirection: widget.layoutDirection,
                  liteModeEnabled: widget.liteModeEnabled,
                  mapToolbarEnabled: widget.mapToolbarEnabled,
                  mapType: widget.mapType,
                  minMaxZoomPreference: widget.minMaxZoomPreference,
                  myLocationButtonEnabled: widget.myLocationButtonEnabled,
                  myLocationEnabled: widget.myLocationEnabled,
                  onCameraMove: widget.onCameraMove,
                  onCameraMoveStarted: () async {
                    widget.onCameraMoveStarted?.call();
                    _initialZoom = await _googleMapController.getZoomLevel();
                  },
                  onLongPress: widget.onLongPress,
                  onTap: widget.onTap,
                  padding: widget.padding,
                  polygons: widget.polygons,
                  polylines: widget.polylines,
                  rotateGesturesEnabled: widget.rotateGesturesEnabled,
                  scrollGesturesEnabled: widget.scrollGesturesEnabled,
                  tileOverlays: widget.tileOverlays,
                  tiltGesturesEnabled: widget.tiltGesturesEnabled,
                  trafficEnabled: widget.trafficEnabled,
                  zoomControlsEnabled: widget.zoomControlsEnabled,
                  zoomGesturesEnabled: widget.zoomGesturesEnabled,
                  markers: {
                    // 1. Procesamos los marcadores actuales
                    ...widget.markers.map((m) {
                      final type = _markersAnimationType[m.markerId.value] ??
                          MarkerAnimationType.none;
                      double finalAlpha;

                      switch (type) {
                        case MarkerAnimationType.fadeIn:
                          finalAlpha = fadeInOpacity;
                          break;
                        case MarkerAnimationType.fadeOut:
                        case MarkerAnimationType.none:
                          finalAlpha = 1.0;
                          break;
                      }

                      return m.copyWith(alphaParam: finalAlpha);
                    }).where((m) => m.alpha > 0.0),

                    ..._ghostMarkers.map((m) {
                      return m.copyWith(alphaParam: outOpacity);
                    }).where((m) => m.alpha > 0.0),
                  })),
    );
  }

  void _classifyMarkerChanges(Set<Marker> oldMarkers, Set<Marker> newMarkers) {
    _markersAnimationType.clear();
    _ghostMarkers.clear();

    final oldIds = oldMarkers.map((m) => m.markerId.value).toSet();
    final newIds = newMarkers.map((m) => m.markerId.value).toSet();

    for (final newMarker in newMarkers) {
      final String id = newMarker.markerId.value;

      if (!oldIds.contains(id)) {
        _markersAnimationType[id] = MarkerAnimationType.fadeIn;
      } else {
        // Ya existía, comprobamos si se ha movido
        final oldMarker = oldMarkers.firstWhere((m) => m.markerId.value == id);

        if (oldMarker.position != newMarker.position) {
          // ID igual pero posición distinta: necesita desaparecer en A y aparecer en B
          Marker ogMarker = Marker(
            markerId: MarkerId('${oldMarker.markerId.value}-old'),
            alpha: oldMarker.alpha,
            position: oldMarker.position,
            icon: oldMarker.icon,
            anchor: oldMarker.anchor,
            draggable: oldMarker.draggable,
            flat: oldMarker.flat,
            infoWindow: oldMarker.infoWindow,
            rotation: oldMarker.rotation,
            visible: oldMarker.visible,
            onTap: oldMarker.onTap,
            onDragStart: oldMarker.onDragStart,
            onDrag: oldMarker.onDrag,
            onDragEnd: oldMarker.onDragEnd,
            clusterManagerId: oldMarker.clusterManagerId,
            consumeTapEvents: oldMarker.consumeTapEvents,
            zIndexInt: oldMarker.zIndexInt,
          );
          _ghostMarkers.add(ogMarker);
          _markersAnimationType[ogMarker.markerId.value] =
              MarkerAnimationType.fadeOut;
          _markersAnimationType[id] = MarkerAnimationType.fadeIn;
        } else {
          // Está en el mismo sitio: no le molestamos
          _markersAnimationType[id] = MarkerAnimationType.none;
        }
      }
    }

    // 2. Analizamos los marcadores que se han ido (los "fantasmas")
    for (final oldMarker in oldMarkers) {
      final String id = oldMarker.markerId.value;

      if (!newIds.contains(id)) {
        // Estaba antes pero ya no está en la nueva lista
        _markersAnimationType[id] = MarkerAnimationType.fadeOut;
        _ghostMarkers
            .add(oldMarker); // Lo retenemos para poder animar su salida
      }
    }
  }

  Future<void> _startAnimationSequence() async {
    // 1. ¿Necesitamos limpiar algo antes de mostrar lo nuevo?
    bool needsFadeOut = _markersAnimationType.values
        .any((type) => type == MarkerAnimationType.fadeOut);
    bool needsFadeIn = _markersAnimationType.values
        .any((type) => type == MarkerAnimationType.fadeIn);

    if (needsFadeOut) {
      await fadeOutNotifier.fadeOut(duration: widget.duration);
      setState(() {
        _ghostMarkers.clear();
      });
      fadeOutNotifier.value = 1.0;
    }
    if (needsFadeIn) {
      await fadeInNotifier.fadeIn(duration: widget.duration);
      fadeInNotifier.value = 0.0;
      _markersAnimationType.updateAll((key, value) => MarkerAnimationType.none);
    }

    fadeInNotifier.value = 0;
  }
}
