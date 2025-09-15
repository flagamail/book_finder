# API Integration

Base: https://openlibrary.org

Key endpoints
- Search: /search.json?q={query}&page={page}
- Work details (optional): /works/{workId}.json
- Covers: https://covers.openlibrary.org/b/id/{coverId}-{size}.jpg (S|M|L)

Search parameters
- q: string, required (book title or keywords)
- page: 1-based integer

Search response (fields we use)
- numFound: int (total available results)
- start: int (offset)
- docs: list of items
  - key: string (e.g., "/works/OL12345W")
  - title: string
  - author_name: [string]
  - cover_i: int (cover id)
  - first_publish_year: int (optional)

Pagination strategy
- Start at page=1. Each subsequent page increments by +1.
- Determine last page by accumulating results length >= numFound.
- Prevent duplicate in-flight requests.

Cancellation & Debounce
- Debounce queries 300–500ms in the presentation layer to reduce traffic.
- switchMap in the event transformer cancels the previous stream mapping, but it does NOT cancel an already-started Dio request.
- Use Dio CancelToken: cancel the previous token before starting a new request; pass the current token into repository methods so callers control cancellation.

Error handling
- Map DioError/DioException types to Failure and to user-friendly messages. Example mapping:
  - connectionTimeout/receiveTimeout: "Connection timed out. Please try again."
  - badResponse (4xx/5xx): "Server error. Please try again later."
  - cancel: silently ignore or show brief info if appropriate
  - other/noConnection: "You appear to be offline. Check your internet connection."
- Provide Retry action in UI states when appropriate.
- Use short timeouts and up to 2 retries with exponential backoff in the network client.

Image handling
- Prefer M size cover: https://covers.openlibrary.org/b/id/{coverId}-M.jpg
- If coverId missing, show placeholder asset or colored box.

Notes
- Open Library doesn’t require an API key.
- Be respectful with request frequency; debounce queries on the client (>=300ms).
