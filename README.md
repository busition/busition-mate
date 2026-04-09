# Busition Mate

Busition Mate is the passenger-facing mobile app for the Busition shuttle platform. The app is built with Flutter and helps riders sign in, check their shuttle schedule, view route information on a map, and follow live vehicle movement from the Busition backend.

## Overview

This repository contains the client app used by passengers. Based on the current codebase, the main flow is:

- Authenticate with Firebase using email/password or Google Sign-In
- Register a new user account
- Fetch passenger schedule data from the Busition API
- Show route and stop information with Google Maps
- Receive live shuttle updates through Socket.IO
- Use location, background service, notifications, and Bluetooth-related features for boarding and proximity workflows

The project is primarily configured for Android and iOS. A `web/` directory exists, but the active platform integrations in this codebase are mobile-first.

## Features

- Firebase Authentication
  - Email/password login
  - Google Sign-In
  - Basic sign-up flow
- Passenger schedule view
  - Fetches assigned shuttle schedule data
  - Shows trip cards and departure information
- Route map
  - Displays route polylines and stops
  - Tracks the current bus position on the map
- Real-time updates
  - Connects to the Busition Socket.IO server
  - Updates bus movement and boarding-related state
- Background behavior
  - Uses a foreground service on Android
  - Requests location, notification, and Bluetooth permissions

## Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Google Maps Flutter
- HTTP APIs
- Socket.IO client
- Geolocator
- Permission Handler
- Flutter Foreground Task

## Requirements

The repository configuration currently indicates:

- Dart SDK: `>=2.12.0 <3.0.0`
- Flutter SDK: any version compatible with the Dart constraint above
- Android:
  - `minSdkVersion 26`
  - `targetSdkVersion 33`
  - `compileSdkVersion 33`
- iOS:
  - minimum deployment target `12.0`

## Configuration

Before running the app, confirm that the environment-specific configuration matches the backend and Firebase project you intend to use.

### Firebase

The project already includes Firebase configuration files in the repository:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

If you are connecting this app to a different Firebase project, replace those files with the correct values for that environment.

### Google Maps

Android uses a Google Maps API key defined in:

- `android/app/src/main/AndroidManifest.xml`

If you are moving to another environment or rotating credentials, update the key there. If iOS map credentials are required for your setup, add the corresponding platform configuration as well.

### Backend Endpoints

The app currently calls Busition development endpoints directly from the source code, including:

- `http://api.dev.busition.com:8001`
- `http://api.dev.busition.com:3000`

These URLs are referenced in multiple files such as:

- `lib/LoginClass.dart`
- `lib/Page_Timeline/TimeData.dart`
- `lib/Page_Maps/RouteData/MapRoute.dart`
- `lib/utils/SocketServices.dart`

If you need staging or production support, centralize and update these endpoints before release.

## Getting Started

1. Install Flutter with a version compatible with Dart 2.x for this project.
2. Clone the repository.
3. Install dependencies:

```bash
flutter pub get
```

4. Verify Firebase and Google Maps configuration for your environment.
5. Connect a device or start an emulator.
6. Run the app:

```bash
flutter run
```

## Common Commands

```bash
flutter pub get
flutter analyze
flutter run
flutter build apk
flutter build ios
```

## Permissions

From the current Android and iOS configuration, the app may request:

- Fine and coarse location
- Background location
- Bluetooth advertise/connect/scan
- Notifications
- Foreground service access
- System alert window access on Android

These permissions support route tracking, real-time updates, and boarding-related behavior.

## Project Structure

```text
lib/
  main.dart                  App entry point and login flow
  MainPage.dart              Main shell and foreground task integration
  Page_SignUp/               Sign-up screens and validation
  Page_Timeline/             Schedule and timeline UI
  Page_Maps/                 Map, route, and stop UI
  Page_Etc/                  Settings and miscellaneous screens
  utils/                     Permissions, sockets, Bluetooth, and location helpers
```

## License

This repository is licensed under `AGPL-3.0-only`.

See the [LICENSE](./LICENSE) file for the full license text.

## Development Notes

- The login screen currently includes prefilled development credentials in `lib/main.dart`.
- Backend URLs are hard-coded instead of being managed through environment-based configuration.
- Mobile permissions and foreground/background behavior are an important part of the current implementation, so testing on real devices is recommended.

## Running a Debug Build

```bash
flutter run
```
