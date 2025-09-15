import 'package:book_finder/features/search/data/models/book_dto.dart';

abstract class SearchRemoteDataSource {
  Future<List<BookDto>> searchBooks(String query, {int page = 1});
}
