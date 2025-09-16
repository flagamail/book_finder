# Architecture

We adopt Clean Architecture with separation of concerns and dependency inversion. Presentation depends only on Domain; Data implements Domain repositories.

Layers
- Presentation (Flutter UI + BLoC): Widgets, pages, blocs emit events/states and call use cases.
- Domain (pure Dart): Entities, repository interfaces, and use cases.
- Data (framework-facing): DTO models, mappers, data sources (remote/local), repository implementations.
- Core: cross-cutting utilities (errors, network client, debouncer).

Dependencies
- Presentation -> Domain
- Data -> Domain
- Core -> used by all layers as needed

Folder structure (under lib/)
- core/
  - errors/ (Failure, Exceptions)
  - network/ (HTTP client wrapper, interceptors, connectivity checker)
  - utils/ (debouncer, mappers helpers)
- features/
  - search/
    - data/
      - datasources/ (remote Open Library API)
      - models/ (SearchResponse, SearchDoc)
      - repositories/ (SearchRepositoryImpl)
    - domain/
      - entities/ (Book)
      - repositories/ (SearchRepository)
      - usecases/ (SearchBooks, GetNextPage)
    - presentation/
      - bloc/ (SearchBloc, events, states)
      - pages/ (SearchPage)
      - widgets/ (SearchBar, BookListItem, ShimmerList)
  - details/
    - data/
      - datasources/ (local SQLite DAO; optional remote works)
      - models/ (BookDetailModel)
      - repositories/ (BookRepositoryImpl)
    - domain/
      - entities/ (BookDetail)
      - repositories/ (BookRepository)
      - usecases/ (GetBookDetail, SaveBook, GetSavedBooks, RemoveSavedBook)
    - presentation/
      - bloc/ (DetailsBloc)
      - pages/ (DetailsPage)
      - widgets/ (AnimatedCover)
- app/
  - di.dart (get_it registrations)
  - router.dart (GoRouter/Route management)
- main.dart

Networking
- Use dio or http wrapped in a NetworkClient with:
  - baseUrl = https://openlibrary.org
  - timeouts
  - error mapping -> Failure types
  - simple retry (max 2) with exponential backoff for idempotent GETs

Pagination
- Search starts at page=1; accumulate results; stop when accumulated >= numFound.
- Guard against concurrent loads and duplicate pages.

Persistence
- SQLite via sqflite: favorites table (id, title, author, coverId, createdAt)
- DAO exposes CRUD used by BookRepositoryImpl

Dependency Injection (get_it)
- Register singletons: NetworkClient, DatabaseProvider/DAO
- Register repositories as lazy singletons bound to domain interfaces
- Register use cases as lazy singletons
- Provide blocs with MultiBlocProvider in app root

Error Handling
- Map exceptions in repositories to Failure (NetworkFailure, ServerFailure, CacheFailure, ValidationFailure) and emit user-friendly messages in presentation.

Testing
- Domain use cases: unit tests
- Repositories: mock data sources (mocktail)
- Blocs: bloc_test
- Widgets: golden/widget tests for SearchPage, DetailsPage

---

## Use Cases vs. Repositories: The Golden Rule

To maintain a clean and scalable architecture, it's crucial to differentiate the responsibilities of the Use Case and Repository layers.

### Use Cases

**Responsibility:** Orchestrate and merge data from **DIFFERENT repositories**.

- Use cases are for encapsulating complex business rules.
- They are essential when a single user action requires data from multiple, distinct repositories (e.g., combining `UserRepository` and `BookRepository` to create a personalized book list).

### Repositories

**Responsibility:** Orchestrate and merge data from **DIFFERENT data sources** for the *same entity*.

- Repositories are responsible for abstracting the origin of data. The rest of the app should not know if the data is coming from a remote API, a local database, or a combination of both.
- This is the correct place to implement logic like caching, offline-first strategies, or any other data source management.
