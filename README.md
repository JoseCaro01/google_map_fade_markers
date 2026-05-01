

# Google Map Fade Markers

This package This package integrate for the markers a fade animation when the markers changes

## Installation 

1. Add the latest version of package to your pubspec.yaml (and run`dart pub get`):
```yaml
dependencies:
  google_map_fade_markers:^0.0.6
```

2. Prepare for your platform:

This means that app will only be available for users that run Android SDK 20 or higher.

2. Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

### iOS

To set up, specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

```objectivec
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

Or in your swift code, specify your API key in the application delegate `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Web

You'll need to modify the `web/index.html` file of your Flutter Web application
to include the Google Maps JS SDK.

Check [the `google_maps_flutter_web` README](https://pub.dev/packages/google_maps_flutter_web)
for the latest information on how to prepare your App to use Google Maps on the
web.

3. Import the package and use it in your Flutter App.
```dart
import 'package:google_map_fade_markers/google_map_fade_markers.dart';
```

## Example

```dart
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
      _testStep = (_testStep + 1) % 4; 
    });
  }
}
```

