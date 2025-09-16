import 'package:book_finder/domain/entities/book.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoadInProgress extends SearchState {}

class SearchLoadSuccess extends SearchState {
  final List<Book> books;
  final bool hasReachedMax;

  const SearchLoadSuccess(this.books, {this.hasReachedMax = false});

  @override
  List<Object> get props => [books, hasReachedMax];
}

class SearchLoadFailure extends SearchState {
  final String message;
  final List<Book>? books;

  const SearchLoadFailure(this.message, {this.books});

  @override
  List<Object?> get props => [message, books];
}
