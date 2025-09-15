import 'package:book_finder/core/errors/failure.dart';
import 'package:book_finder/domain/entities/book.dart';
import 'package:either_dart/either.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Book>>> searchBooks(String query, {int page = 1});
}
