# Ganesh Bandobust Mobile Application
## Technical Change and Validation Report

**Date:** 10 September 2026  
**Application:** Ganesh Bandobust Mobile  
**Platform tested:** Android physical device (Samsung SM S901E)  
**Build mode:** Android release

## 1. Executive Summary

The application was reviewed and updated to address inaccurate AR idol measurements, GPS lifecycle safety, and Android build and deployment problems. The corrected release APK was successfully installed and launched on the connected Android device.

No Ganesh application records, idol records, organizer details, or business data were intentionally changed. The work was limited to measurement logic, lifecycle handling, and development/build configuration.

## 2. AR Measurement Accuracy Fix

### Problem

The AR measurement screen selected the first result returned by the AR hit test. That result could be a noisy feature-point measurement instead of a stable tracked plane. As a result, the same idol could produce different height or width readings.

### Change implemented

The measurement logic now:

- Prefers tracked plane hit results.
- Uses a feature-point hit only when no plane hit is available.
- Calculates the three-dimensional distance between the selected points.
- Converts the result from metres to feet.
- Captures the measurement timestamp.
- Stores the selected start and end coordinates.
- Includes the measurement value in the evidence image.

### User workflow

For height:

1. Scan the idol slowly until AR tracking is stable.
2. Tap the exact bottom point.
3. Tap the exact top point.
4. The measurement completes after the second tap.

For width:

1. Tap the exact left edge.
2. Tap the exact right edge.
3. The measurement completes after the second tap.

A third tap starts a new measurement. The user can also reset the measurement before confirming it.

### Accuracy conditions

AR measurement is sensor-based and approximate. Accuracy depends on lighting, device ARCore support, surface texture, camera stability, and selecting the exact physical edges. Official field records should be cross-checked when exact legal or engineering accuracy is required.

## 3. GPS and Lifecycle Safety

The location and AR screens perform asynchronous GPS operations. Previously, a screen could be closed while a GPS request was still running, potentially causing a state-update error.

The updated code checks that the screen is still mounted before updating the interface after asynchronous operations. It also handles:

- Disabled location services.
- Denied location permission.
- Permanently denied location permission.
- GPS capture failures.
- Missing GPS data before evidence confirmation.

The evidence flow records latitude, longitude, GPS accuracy, and measurement time when available.

## 4. Flutter and Android Toolchain Repairs

The original machine was using Flutter 2.10.5 with Dart 2.16.2, while the project requires Dart 3.13.1 or newer.

The Flutter SDK was upgraded and verified as:

- Flutter 3.47.3
- Dart 3.13.3

The Android phone was connected through ADB and authorized successfully. The release application was launched on device `SM S901E`.

Java 17 was installed and configured for Android Gradle builds. The valid JDK path was:

`C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot`

## 5. Gradle Stability Improvements

The Android build initially failed because the Gradle daemon exhausted native memory. The Gradle JVM was configured with excessive memory limits and repeatedly crashed during release processing.

The build configuration was adjusted to reduce resource usage:

- Reduced Gradle JVM heap.
- Reduced metaspace limit.
- Reduced code cache size.
- Reduced Java thread stack size.
- Limited Gradle workers.
- Stopped stale Gradle daemons before rebuilding.
- Disabled release code shrinking and resource shrinking for the current debug-signed client APK.

These changes avoid the memory-heavy R8 stage that caused the release build to fail on the development computer.

## 6. Build and Installation Validation

The following result was observed:

`Installing build\\app\\outputs\\flutter-apk\\app-release.apk...`

The application launched on the physical Android device. Flutter Impeller rendering and the Geolocator service initialized successfully.

The following messages were normal runtime messages, not application failures:

- Impeller Vulkan rendering initialization.
- Geolocator service creation and binding.
- Flutter engine connect and disconnect messages during lifecycle changes.

## 7. Data Integrity Statement

No application business data was modified as part of this work. No idol details, organizer data, application identifiers, or Ganesh records were intentionally changed.

The changes were limited to:

- AR hit selection.
- Measurement calculation flow.
- GPS lifecycle handling.
- Flutter and Android build configuration.
- Gradle memory and release packaging configuration.

USB disconnection does not modify application data. Users should avoid manually selecting **Clear data**, **Clear storage**, or uninstalling the application if locally stored data must be preserved.

## 8. Files Changed

- `mobile/lib/screens/measurement/ar_measurement_screen.dart`
- `mobile/lib/screens/pre_installation/location_verification_screen.dart`
- `mobile/android/app/build.gradle.kts`
- `mobile/android/gradle.properties`
- `mobile/windows/flutter/CMakeLists.txt` was cleaned of accidental stray text.

Generated files such as `generated_plugin_registrant.cc` were not manually edited.

## 9. Remaining Notices

Flutter and Android tooling may still display informational warnings about:

- Android command-line tools versions.
- Kotlin Gradle Plugin migration.
- Newer package versions.
- Visual Studio, which is only required for Windows desktop builds.

These warnings are separate from the Android release installation and do not represent changes to Ganesh application data.

## 10. Final Status

**Status: Ready for physical-device field testing.**

The corrected application has been built, installed, and launched on an Android device. The AR height and width workflow should now be tested against a known-size object, such as a verified 10-foot idol, under good lighting and with careful point selection.

**Prepared for client review**
