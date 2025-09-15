# Developer Setup

Prerequisites
- Flutter SDK (stable channel). Verify with: flutter --version
- Dart SDK (bundled with Flutter)
- IDE: Android Studio, IntelliJ IDEA, or VS Code
- Platforms:
  - Android: Android SDK + emulator or device
  - iOS (macOS only): Xcode + CocoaPods
  - Web: Chrome

Initial Setup
1) Clone repo and open in your IDE
2) Run: flutter pub get
3) Ensure toolchains are OK: flutter doctor -v

Running the App
- Android: flutter run -d emulator-5554 (or select a device in IDE)
- iOS: flutter run -d ios (first build may take longer)
- Web: flutter run -d chrome

Project Commands
- Format: flutter format .
- Analyze: dart analyze
- Tests: flutter test

Enabling Platforms
- Web: flutter config --enable-web
- iOS: requires macOS + Xcode; run pod install in ios/ if needed

Environment Variables
- None required; Open Library API is public and does not need an API key.

Troubleshooting
- Stale pub cache: flutter pub cache repair
- Clean builds: flutter clean && flutter pub get
- iOS CocoaPods: (cd ios && pod repo update && pod install)

Folder Overview
- lib/core: cross-cutting utilities (errors, network, utils)
- lib/features/search and lib/features/details: Clean Architecture slices
- app/di.dart: get_it registrations; app/router.dart: navigation

Verification Checklist
- dart analyze shows 0 issues
- flutter test passes
- App runs on at least one target (Android emulator or Chrome)
