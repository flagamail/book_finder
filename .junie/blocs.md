# BLoC Design

We use flutter_bloc with immutable Events and States. Each feature has its own bloc(s).

SearchBloc
- Responsibilities
  - Debounce user input (300–500ms) before querying. Shorter for highly reactive UIs, longer to reduce traffic.
  - Distinct queries to avoid duplicate requests for same string
  - Paginate results (page starts at 1)
  - Prevent concurrent loads and duplicate pages
  - Pull-to-refresh resets state and reloads from page 1
- Events
  - QueryChanged(String query)
  - FetchNextPage()
  - RefreshRequested()
  - RetryRequested() (re-run last failed action)
- State shape
  - SearchState {
      status: SearchStatus {initial, loading, paging, success, empty, error},
      query: String,
      items: List<Book>,
      page: int,
      hasMore: bool,
      errorMessage: String?,
    }
- Logic
  - On QueryChanged: cancel in-flight search, debounce, distinct, set page=1, fetch
  - On FetchNextPage: if hasMore && status!=paging -> page+1 fetch
  - On RefreshRequested: page=1, fetch anew
  - Determine hasMore from accumulated items length < numFound

DetailsBloc
- Responsibilities
  - Load details for a given book/work id (optionally enrich via works endpoint)
  - Save/remove favorites via SQLite
  - Expose saved status
- Events
  - LoadRequested(String id)
  - SaveFavoriteRequested(Book book)
  - RemoveFavoriteRequested(String id)
  - ToggleFavoriteRequested(Book book)
- State shape
  - DetailsState {
      status: DetailsStatus {initial, loading, loaded, error},
      detail: BookDetail?,
      isSaved: bool,
      errorMessage: String?,
    }

Debouncing & Cancellation
- Use a Debouncer utility in core/utils (e.g., based on Timer) or Rx transform.
- For QueryChanged, prefer EventTransformer that chains: debounceTime(300–500ms) -> distinct() -> switchMap(...)
- switchMap cancels the stream mapping of the previous event so the handler won't be invoked for stale events, but it does NOT cancel any already-started Dio HTTP request. Therefore, keep a private CancelToken in the bloc and cancel it before starting the next request.
- On navigation away (bloc.close()), cancel the current CancelToken to stop in-flight requests.

Repository responsibility
- Follow SRP: repositories accept an optional CancelToken parameter so the caller (BLoC) controls cancellation and tests can verify behavior.

Error handling
- Map Failures to user-friendly messages in states.
- Provide RetryRequested to repeat last failed operation.

Testing
- Use bloc_test to validate transitions and side-effects.
- Mock repositories/use cases to simulate success, empty, error, pagination.
- Verify cancellation: when a second QueryChanged arrives quickly, the previous token is cancelled and a new token is passed to repository.

Pseudo-code snippet (SearchBloc)
- Keep field: CancelToken? _currentCancelToken;
- On each search:
  - _currentCancelToken?.cancel("new_query");
  - _currentCancelToken = CancelToken();
  - await repository.search(query, page, cancelToken: _currentCancelToken);
- @override Future<void> close() { _currentCancelToken?.cancel("dispose"); return super.close(); }
