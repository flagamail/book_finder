import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/core/utils/book_local_data_source.dart';
import 'package:book_finder/core/errors/exceptions.dart';
import 'package:book_finder/core/utils/app_logger.dart';

class BookRepository {
  final BookLocalDataSource _localDataSource;

  BookRepository(this._localDataSource);

  Future<void> saveBook(Book book) async {
    try {
      await _localDataSource.saveBook(book);
    } on LocalDatabaseException catch (e, stack) {
      appLogger.e('Repository error saving book: ${e.message}', error: e, stackTrace: stack);
      rethrow;
    } catch (e, stack) {
      appLogger.e('Unexpected error saving book', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<Book?> getBook(String id) async {
    try {
      return await _localDataSource.getBook(id);
    } on LocalDatabaseException catch (e, stack) {
      appLogger.e('Repository error getting book: ${e.message}', error: e, stackTrace: stack);
      rethrow;
    } catch (e, stack) {
      appLogger.e('Unexpected error getting book', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
