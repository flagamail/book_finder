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

3) BLoC
- Use bloc_test to assert state sequences for:
  - query change with debounce
  - pagination success and last-page detection
  - refresh resets to page 1
  - error surfaces with retry

4) Widgets
- SearchPage: renders shimmer on initial load, list on success, pull-to-refresh, pagination trigger near end.
- DetailsPage: shows title/author, animated cover present, save/remove favorite button toggles.

Mocking
- Use mocktail to mock repositories/use cases; stub responses and failures.

Examples (pseudo)
- bloc_test<SearchBloc, SearchState>(
  'emits loading->success when query returns items',
  build: () => SearchBloc(mockSearchBooks, mockGetNextPage),
  act: (b) => b.add(QueryChanged('harry potter')),
  wait: const Duration(milliseconds: 350),
  expect: () => [isA<SearchLoading>(), isA<SearchSuccess>()],
);

Debug logs
- Prefix with [DEBUG_LOG] in tests when printing troubleshooting info.

CI
- Ensure tests run in CI (see ci-cd.md). Fail the pipeline on any failing test.
