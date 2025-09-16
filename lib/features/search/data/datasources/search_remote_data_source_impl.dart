import 'package:book_finder/core/errors/exceptions.dart';
import 'package:book_finder/core/utils/app_logger.dart';
import 'package:book_finder/features/search/data/datasources/search_remote_data_source.dart';
import 'package:book_finder/features/search/data/models/book_dto.dart';
import 'package:dio/dio.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookDto>> searchBooks(String query, {int page = 1}) async {
    final path = '/search.json';
    /// Fixes: convert all query parameters to String for Uri. Expects /*String?|Iterable<String>*/
    final Map<String, String> queryParametersForUri = {
      'q': query,
      'page': page.toString(),
      'limit': '15',
    };
    String fullUrl = '';
    try {
      fullUrl = '${dio.options.baseUrl}$path?${Uri(queryParameters: queryParametersForUri).query}';
    } catch (e, s) {
     appLogger.e('Failed to create URL for path $path params $queryParametersForUri', stackTrace: s,error: e);
    }

    appLogger.d('Making API call to search books: $fullUrl');
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParametersForUri,
      );

      if (response.statusCode == 200) {
        appLogger.i('API call successful for query: $fullUrl');
        final data = response.data;
        final docs = data['docs'] as List;
        appLogger.d('Parsing ${docs.length} BookDto objects.');
        return docs.map((doc) => BookDto.fromJson(doc)).toList();
      } else {
        appLogger.e(
          'API call failed with status code: ${response.statusCode} for $fullUrl',
          error: 'Server Error',
          stackTrace: StackTrace.current,
        );
        throw ServerException();
      }
    } on DioException catch (e, stackTrace) {
      appLogger.e(
        'DioException occurred during API call for $fullUrl: ${e.message}',
        error: e,
        stackTrace: stackTrace,
      );
      throw ServerException();
    } catch (e, stackTrace) {
      appLogger.e(
        'An unexpected error occurred in remote data source for $fullUrl: $e',
        error: e,
        stackTrace: stackTrace,
      );
      throw ServerException();
    }
  }
}
