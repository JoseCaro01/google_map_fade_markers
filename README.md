

# Google Map Fade Markers

This package This package integrate for the markers a fade animation when the markers changes

## Installation 

1. Add the latest version of package to your pubspec.yaml (and run`dart pub get`):
```yaml
dependencies:
  google_map_fade_markers:^0.0.3
```

2. Prepare for your platform:

### Android
1. Set the `minSdkVersion` in `android/app/build.gradle`:

```groovy
android {
    defaultConfig {
        minSdkVersion 20
    }
}
```

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

```

