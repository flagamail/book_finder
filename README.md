# book_finder

A Flutter project for searching, viewing, and saving books locally using SQLite. This app demonstrates best practices in architecture, dependency injection, error handling, and logging.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Hidden Gems & UX Features](#hidden-gems--ux-features)
- [Architecture](#architecture)
- [Setup](#setup)
- [Folder Structure](#folder-structure)
- [Running the App](#running-the-app)
- [Testing](#testing)
- [Contributing](#contributing)
- [Resources](#resources)

## Overview
book_finder allows users to search for books, view details, and save them locally. It uses SQLite for local storage and follows clean architecture principles for maintainability and testability.

## Features
- Search for books
- View book details
- Save books locally using SQLite
- Retrieve saved books
- Error handling with custom exceptions
- Logging (including errors and stacktraces)
- Dependency injection for testability

## Hidden Gems & UX Features
- **Hide Keyboard on Scroll**: When users scroll through book lists, the keyboard automatically hides for a cleaner experience. This is implemented in the book list view using scroll listeners.
- **Loading Indicator During Pagination**: When loading more books ("load next"), a loading spinner is shown at the bottom of the list, providing clear feedback during data fetches. See the book list widget for implementation details.
- **Error Snackbars**: User-friendly error messages are shown as snackbars for network or database issues, improving transparency and usability.

## Architecture
- **Domain Layer**: Entities and repositories (see `lib/domain/`)
- **Data Layer**: Local data source (SQLite), repository implementations (see `lib/features/`)
- **Presentation Layer**: UI and themes (see `lib/presentation/`)
- **Dependency Injection**: Managed in `lib/app/di.dart` for testability
- **Error Handling**: Custom exceptions in `lib/core/errors/`
- **Logging**: Uses the `logger` package throughout, including for errors and stacktraces

## Setup
### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart (comes with Flutter)
- Android Studio, VS Code, or IntelliJ IDEA

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/book_finder.git
   cd book_finder
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```

## Folder Structure
```
lib/
  app/           # Dependency injection
  core/          # Errors, utilities
  domain/        # Entities, repositories
  features/      # Book search & details
  presentation/  # UI, themes
main.dart        # App entry point
```
- **android/**, **ios/**, **web/**: Platform-specific code
- **test/**: Unit and widget tests

## Running the App
To run on a device or emulator:
```sh
flutter run
```

## Testing
To run all tests:
```sh
flutter test
```

## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a pull request

## Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Packages](https://pub.dev/)
- [sqflite](https://pub.dev/packages/sqflite)
- [logger](https://pub.dev/packages/logger)

## Notes
- All database operations are logged (including creation and successful book saves).
- Abstract classes are used for base models and cannot be instantiated directly.
- Custom exceptions are used instead of hiding/renaming external exceptions.

For any issues, open a GitHub issue or contact the maintainer.
