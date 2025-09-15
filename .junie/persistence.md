# Persistence (SQLite)

Database
- Use sqflite for SQLite access; path_provider to locate the database directory.
- DB name: book_finder.db, version: 1

Schema (v1)
- Table: favorites
  - id TEXT PRIMARY KEY
  - title TEXT NOT NULL
  - author TEXT NOT NULL
  - coverId INTEGER NULL
  - createdAt INTEGER NOT NULL

DAO (Data Access Object)
- Methods
  - Future<void> insertFavorite(FavoriteEntity entity)
  - Future<void> deleteFavorite(String id)
  - Future<FavoriteEntity?> getFavorite(String id)
  - Future<List<FavoriteEntity>> getAllFavorites()

Migrations
- onCreate executes CREATE TABLE for favorites.
- For future versions, add ALTER TABLE statements in onUpgrade.

Repository Integration
- BookRepositoryImpl depends on DAO for save/remove/get saved books.
- Map FavoriteEntity <-> Book in the repository layer.

Error Handling
- Wrap sqflite exceptions and map to CacheFailure in repositories.

Testing
- Prefer DAO tests with an in-memory database or mocked sqflite channel.

Example SQL
- CREATE TABLE favorites (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    coverId INTEGER,
    createdAt INTEGER NOT NULL
  );
