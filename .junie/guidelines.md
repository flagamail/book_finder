# Project Guidelines – Book Finder App

You are a Lead Flutter Developer maintaining a 2-screen Book Finder application. The app uses the Open Library API for search and details and persists selected books locally using SQLite. This document defines architecture, coding standards, testing strategy (TDD), and the expected developer workflow for Junie.

This is the canonical entry point for the project documentation. Use the Table of Contents below to navigate to deeper topics.

## Table of Contents
- [API Integration](./api.md)
- [Architecture](./architecture.md)
- [Data Models](./data-models.md)
- [BLoC Design](./blocs.md)
- [Persistence (SQLite)](./persistence.md)
- [Testing (TDD)](./testing.md)
- [UI Guidelines](./ui-guidelines.md)
- [CI/CD](./ci-cd.md)
- [Developer Setup](./dev-setup.md)
- [API Contracts](./api-contracts/openlibrary-example.json)

## 1. Project Overview
- Name: Book Finder
- Purpose: Allow users to search books by title, view details, and save favorites locally.
- External API: Open Library
  - Base docs: https://openlibrary.org/developers/api
  - Search endpoint: `https://openlibrary.org/search.json?q={query}&page={page}`
  - Cover images: `https://covers.openlibrary.org/b/id/{coverId}-{size}.jpg` (sizes: S, M, L)
  - Work details (optional): `https://openlibrary.org/works/{workId}.json`
- Platforms: Android, iOS, Web (Flutter)

## 2. App Requirements (Scope)
Screens:
1) Search Screen
   - Search bar to input title (debounced queries)
   - Paginated list of results (title, author, thumbnail)
   - Pull-to-refresh
   - Shimmer loading while fetching
2) Details Screen
   - Detailed info of selected book (title, authors, publish year, cover)
   - Animated cover (simple rotation on appear or user interaction)
   - Save book locally using SQLite (favorites)

Evaluation Criteria:
- REST API integration and pagination
- State management: BLoC
- Clean Architecture: Data, Domain, Presentation
- SQLite for local storage
- Robust error handling and async loading states
- Basic animation

## 3. Architecture
Adopt Clean Architecture with separation of concerns and dependency inversion.

Top-level structure under lib/:
- lib/
  - core/
    - errors/ (Failure, exceptions)
    - network/ (HTTP client, interceptors, connectivity)
    - utils/ (mappers, debouncer)
  - features/
    - search/
      - data/
        - datasources/ (remote: Open Library; local if needed)
        - models/ (DTOs: SearchResponse, BookModel)
        - repositories/ (SearchRepositoryImpl)
      - domain/
        - entities/ (Book)
        - repositories/ (SearchRepository interface)
        - usecases/ (SearchBooks, GetNextPage)
      - presentation/
        - bloc/ (SearchBloc, SearchEvent, SearchState)
        - pages/ (SearchPage)
        - widgets/ (SearchBar, BookListItem, ShimmerList)
    - details/
      - data/
        - datasources/ (local: SQLite; remote: work details optional)
        - models/ (BookDetailModel)
        - repositories/ (BookRepositoryImpl)
      - domain/
        - entities/ (BookDetail)
        - repositories/ (BookRepository interface)
        - usecases/ (GetBookDetail, SaveBook, GetSavedBooks, RemoveSavedBook)
      - presentation/
        - bloc/ (DetailsBloc)
        - pages/ (DetailsPage)
        - widgets/ (AnimatedCover)
  - app/
    - router.dart
    - di.dart (get_it service locator)
  - main.dart

Notes:
- Keep models (DTO) and entities separate. Map via mappers in data layer.
- Repository interfaces live in domain; implementations in data.
- Presentation only depends on domain.

## 4. State Management (BLoC)
- Use flutter_bloc for events/states.
- SearchBloc responsibilities:
  - Debounced query handling (e.g., 300ms)
  - Pagination: track current page and append results
  - Pull-to-refresh: reset to page 1
  - Loading states: initial, loading, paging, success, empty, error
- DetailsBloc responsibilities:
  - Load details (combine remote and local if applicable)
  - Save/remove favorites to SQLite
  - Emit states for saving status and errors

## 5. REST API Integration & Pagination
- Client: Use http or dio; wrap in a NetworkClient (core/network) with timeouts and base error mapping.
- Search:
  - Endpoint: `/search.json`
  - Params: `q` (title), `page` (1-based)
  - Map docs to entity fields: title, author_name (first author string), cover_i (for cover), key/work key
- Images: Prefer `covers.openlibrary.org/b/id/{coverId}-M.jpg`; fall back to placeholder when missing.
- Pagination strategy:
  - Start page = 1; load next when user scrolls near end.
  - Prevent duplicate in-flight requests; handle last-page detection via `numFound` and accumulated items.

## 6. Local Storage (SQLite)
- Package: sqflite (plus path_provider for db path).
- Table: favorites
  - Columns: id (TEXT PRIMARY KEY, e.g., work key), title TEXT, author TEXT, coverId INTEGER NULL, createdAt INTEGER
- DAO in data/datasources/local with CRUD methods.
- Repository methods exposed in domain use cases.
- Migrations: simple onCreate; version 1.

## 7. Error Handling & Async Loading
- Define Failure types (NetworkFailure, ServerFailure, CacheFailure, ValidationFailure) in core/errors.
- Map exceptions from network (Dio) and SQLite to Failures in repositories.
- For network calls use exponential backoff for retries (2 tries by default).
- Debounce & Distinct:
  - Debounce user queries 300–500ms (shorter for reactive UIs, longer to reduce traffic).
  - Apply distinct() so the same query string doesn’t trigger duplicate requests.
- Cancellation best practices:
  - switchMap in the event transformer cancels the previous stream mapping, but it does NOT cancel an already-started Dio request.
  - Use Dio CancelToken and cancel the previous token before starting a new request.
  - Single responsibility: repositories accept an optional CancelToken so the caller (BLoC) controls cancellation and tests can verify it.
  - Navigation: cancel any in-flight request in bloc.close() to stop background work when leaving the screen.
- Error UX:
  - Map DioError/DioException to user-friendly messages (timeouts, offline, server errors) and provide a Retry action in UI states.
  - Show transient issues as snackbars/toasts where appropriate.
- UI shows:
  - Shimmer on initial loading
  - Pull-to-refresh indicator
  - UI should display localized/clear messages and a Retry action
  - Snackbars/toasts for transient errors
  - Empty state when no results

## 8. Animation
- Details screen: a simple rotation using AnimatedBuilder or TweenAnimationBuilder for the book cover when screen appears or on user tap.

## 9. TDD Workflow
- Always write/extend tests first (or at least alongside) for:
  - Domain use cases (pure Dart unit tests)
  - Repository implementations (with mocked data sources using mocktail)
  - BLoC tests (bloc_test)
  - Widget tests for SearchPage and DetailsPage happy-path rendering
- Test tooling:
  - Packages: test, flutter_test, mocktail, bloc_test
  - Run: `flutter test`
  - Add debug logs starting with [DEBUG_LOG] when necessary inside tests
- Aim for fast, deterministic tests; avoid hitting the real API (mock remote datasource).

## 10. DRY & SOLID Standards
- DRY: Extract common widgets (e.g., shimmer list item), utilities (debouncer), and mappers.
- SOLID:
  - SRP: Each class with one responsibility (separate data sources, repos, blocs)
  - OCP: Use interfaces/abstract classes for repositories; favor composition
  - LSP: Ensure implementations respect contracts
  - ISP: Keep interfaces lean (separate repos for search vs details)
  - DIP: Presentation depends on abstractions (domain), not concretions
  - Keep methods small, single-responsibility. Prefer composition over inheritance.
- Code style:
  - Follow Effective Dart; run `dart analyze` (analysis_options.yaml enforced)
  - Prefer immutable states/entities; use Equatable
  - Null-safety throughout

## 11. Dependency Injection
- Use get_it for service location.
- Provide blocs via MultiBlocProvider; create repositories/use cases in di.dart.

## 12. Developer Workflow for Junie
Before submitting any change:
1) Format & analyze
   - `flutter format .`
   - `dart analyze`
2) Run tests
   - `flutter test`
3) If UI/features added:
   - Build and run at least one platform locally when possible
   - Verify pagination, pull-to-refresh, shimmer, animation, and SQLite save
4) Keep PRs minimal and focused. Update README when behavior/commands change.

## 13. Packages (suggested)
- dio
- flutter_bloc, equatable
- bloc_test, mocktail (dev)
- sqflite, path_provider
- shimmer
- get_it

## 14. README Expectations
- Include feature overview, setup steps, API references, known limitations, and screenshots/GIFs if possible.

These guidelines define the expectations for implementation quality and the workflow Junie should follow: adopt TDD, write clean and testable code, keep changes minimal yet complete, and ensure the app remains stable and maintainable.
