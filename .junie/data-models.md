# Data Models

Domain Entities (pure, immutable, equatable)
- Book
  - id: String (work key, e.g., "/works/OL12345W")
  - title: String
  - author: String
  - coverId: int? (nullable)
  - firstPublishYear: int? (nullable)
- BookDetail
  - id: String
  - title: String
  - authors: List<String>
  - description: String?
  - coverId: int?
  - firstPublishYear: int?

DTOs (Data Layer)
- SearchResponseDto
  - numFound: int
  - start: int
  - docs: List<SearchDocDto>
- SearchDocDto
  - key: String
  - title: String
  - author_name: List<String>
  - cover_i: int?
  - first_publish_year: int?
- BookDetailDto (from works endpoint if used)
  - key: String
  - title: String
  - description: String|Map? (normalize to string)
  - covers: List<int>?
  - authors: List<{author: {key: String}}>

Mappers
- SearchDocDto -> Book
  - id = key
  - author = first(author_name) or "Unknown"
  - coverId = cover_i
  - firstPublishYear = first_publish_year
- BookDetailDto -> BookDetail
  - id = key
  - title = title
  - description = normalize description
  - coverId = first(covers)
  - authors = resolve via additional calls (optional) or leave as provided names list if available

Database Schema (SQLite)
- Table: favorites
  - id TEXT PRIMARY KEY (work key)
  - title TEXT NOT NULL
  - author TEXT NOT NULL
  - coverId INTEGER NULL
  - createdAt INTEGER NOT NULL (epoch millis)

Persistence Models
- FavoriteEntity (DB row)
  - id, title, author, coverId, createdAt
- Mapping
  - Book -> FavoriteEntity (for save)
  - FavoriteEntity -> Book (for listing saved)

Image URLs
- Build cover URL when needed:
  - If coverId != null -> https://covers.openlibrary.org/b/id/{coverId}-M.jpg
  - Else -> placeholder asset or colored container.
