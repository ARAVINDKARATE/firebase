# Flutter Firebase — MVVM

A Flutter app wiring Firebase Auth, Cloud Firestore and Remote Config together
behind an MVVM structure.

## Features

- Email/password signup and login (`firebase_auth`)
- Firestore-backed comments feed with live reads
- Remote Config for server-driven values
- Form validation isolated in `utilities/validation_util.dart`
- Cached remote images (`cached_network_image`)

## Structure

```
lib/
├── pages/            login/ · signup/ · home/          (View)
├── viewmodela/       login_viewmodel · signup_viewmodel · home_view_model
├── services/         auth_service · comments_services   (Firebase SDK boundary)
├── models/comments_model.dart
├── utilities/validation_util.dart
└── firebase_options.dart
```

Pages never call the Firebase SDK directly — they go through a view model, which
goes through a service. That keeps the Firebase dependency in one layer.

## State management

`provider`, exposing one view model per screen.

## Setup

This app needs your own Firebase project:

1. Create a project in the [Firebase console](https://console.firebase.google.com/)
2. Enable **Email/Password** under Authentication, and create a **Firestore** database
3. Run `flutterfire configure` to regenerate `lib/firebase_options.dart`
4. Drop in your own `google-services.json` / `GoogleService-Info.plist`

```bash
flutter pub get
flutter run
```

## Stack

Flutter · Dart · firebase_auth · cloud_firestore · firebase_remote_config · provider · cached_network_image
