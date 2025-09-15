import 'package:book_finder/core/errors/exceptions.dart';
import 'package:book_finder/core/errors/failure.dart';
import 'package:book_finder/core/network/network_info.dart';
import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/features/search/data/datasources/search_remote_data_source.dart';
import 'package:book_finder/features/search/data/models/book_dto.dart';
import 'package:book_finder/features/search/domain/repositories/search_repository.dart';
import 'package:either_dart/either.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Book>>> searchBooks(String query, {int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBooks = await remoteDataSource.searchBooks(query, page: page);
        return Right(remoteBooks.map((dto) => dto.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure('A server error occurred.'));
      }
    } else {
      return Left(NetworkFailure('No internet connection.'));
    }
  }
}

extension on BookDto {
  Book toEntity() {
    return Book(
      id: key,
      title: title,
      author: authorName?.join(', ') ?? 'Unknown Author',
      coverUrl: coverI != null
          ? 'https://covers.openlibrary.org/b/id/$coverI-M.jpg'
          : null,
    );
  }
}
