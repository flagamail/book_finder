# Testing (TDD)

Principles
- Write or extend tests alongside implementation (prefer before changes).
- Unit test Domain and Data layers thoroughly; Bloc and Widget tests for Presentation.
- Do not hit real network or SQLite in unit tests; mock dependencies.

Tooling
- Packages: test, flutter_test, mocktail, bloc_test
- Run all tests: flutter test
- Lint/analyze: dart analyze

Test Types
1) Domain
- Use cases are pure functions. Test business rules and edge cases.

2) Data
- Repositories: mock remote/local data sources. Verify mapping to Failures.
- Mappers: test DTO <-> Entity transforms.
- Cancellation: ensure repository method signatures accept CancelToken; write tests that verify the token is forwarded to the network client.

3) BLoC
- Use bloc_test to assert state sequences for:
  - query change with debounce (300–500ms)
  - distinct queries (same string does not re-fire)
  - pagination success and last-page detection
  - refresh resets to page 1
  - error surfaces with retry
- Cancellation behavior:
  - Simulate long-running request on first QueryChanged, then dispatch a second QueryChanged quickly; assert the previous CancelToken was cancelled and a new token was used for the second call.
  - On bloc.close() (navigation away), assert the current CancelToken is cancelled (no further repository emissions).

4) Widgets
- SearchPage: renders shimmer on initial load, list on success, pull-to-refresh, pagination trigger near end.
- DetailsPage: shows title/author, animated cover present, save/remove favorite button toggles.

Mocking
- Use mocktail to mock repositories/use cases; stub responses and failures.

Examples (pseudo)
- bloc_test<SearchBloc, SearchState>(
  'debounces and cancels stale requests',
  build: () => SearchBloc(mockRepo),
  act: (b) {
    b.add(QueryChanged('harry'));
    b.add(QueryChanged('harry p'));
  },
  wait: const Duration(milliseconds: 350),
  verify: (_) {
    // verify repository.search called twice with different CancelTokens
    // and that the first token had cancel() invoked
  },
);

- test('cancels in-flight on close', () async {
  final bloc = SearchBloc(mockRepo);
  bloc.add(QueryChanged('lord of the rings'));
  await Future.delayed(const Duration(milliseconds: 100));
  await bloc.close();
  // verify the latest CancelToken.cancel('dispose') was called
});

Debug logs
- Prefix with [DEBUG_LOG] in tests when printing troubleshooting info.

CI
- Ensure tests run in CI (see ci-cd.md). Fail the pipeline on any failing test.
