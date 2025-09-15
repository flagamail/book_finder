import 'package:book_finder/core/errors/exceptions.dart';
import 'package:book_finder/features/search/data/datasources/search_remote_data_source.dart';
import 'package:book_finder/features/search/data/models/book_dto.dart';
import 'package:dio/dio.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookDto>> searchBooks(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        'https://openlibrary.org/search.json',
        queryParameters: {'q': query, 'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final docs = data['docs'] as List;
        return docs.map((doc) => BookDto.fromJson(doc)).toList();
      } else {
        throw ServerException();
      }
    } on DioError {
      throw ServerException();
    }
  }
}
