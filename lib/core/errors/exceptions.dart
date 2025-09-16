class ServerException implements Exception {}

class CacheException implements Exception {}

class LocalDatabaseException implements Exception {
  final String message;
  LocalDatabaseException(this.message);
  @override
  String toString() => 'LocalDatabaseException: $message';
}
