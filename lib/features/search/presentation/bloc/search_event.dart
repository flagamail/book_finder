import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchRequested extends SearchEvent {
  final String query;

  const SearchRequested(this.query);

  @override
  List<Object> get props => [query];
}

class LoadNextPage extends SearchEvent {}

class RetryRequested extends SearchEvent {}
