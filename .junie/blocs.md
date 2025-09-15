# BLoC Design

We use flutter_bloc with immutable Events and States. Each feature has its own bloc(s).

SearchBloc
- Responsibilities
  - Debounce user input (>=300ms) before querying
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
  - On QueryChanged: cancel in-flight search, debounce, set page=1, fetch
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

Debouncing
- Use a Debouncer utility in core/utils (e.g., based on Timer) or Rx transform.
- At bloc level, use EventTransformer.debounce for QueryChanged.

Error handling
- Map Failures to user-friendly messages in states.
- Provide RetryRequested to repeat last failed operation.

Testing
- Use bloc_test to validate transitions and side-effects.
- Mock repositories/use cases to simulate success, empty, error, pagination.
