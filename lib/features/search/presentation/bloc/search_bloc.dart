import 'package:bloc/bloc.dart';
import 'package:book_finder/core/utils/app_logger.dart';
import 'package:book_finder/features/search/domain/repositories/search_repository.dart';
import 'package:book_finder/features/search/presentation/bloc/search_event.dart';
import 'package:book_finder/features/search/presentation/bloc/search_state.dart';
import 'package:stream_transform/stream_transform.dart';

const _duration = Duration(milliseconds: 300);
const _durationLoadNext = Duration(milliseconds: 500);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) {
    return events.asyncExpand((event) {
      appLogger.d('[debounce] Event received: $event');
      return Stream.value(event);
    }).debounce(duration).asyncExpand((event) {
      appLogger.d('[debounce] Event sent to handler after debounce: $event');
      return mapper(event);
    });
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(SearchInitial()) {
    on<SearchRequested>(_onSearchRequested, transformer: debounce(_duration));
    on<LoadNextPage>(_onLoadNextPage, transformer: debounce(_durationLoadNext));
    on<RetryRequested>(_onRetryRequested);
    appLogger.d('SearchBloc initialized');
  }

  int _page = 1;
  String _query = '';

  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    appLogger.d('SearchRequested event received: ${event.query}');
    _query = event.query;
    if (_query.isEmpty) {
      appLogger.i('Search query is empty, emitting SearchInitial');
      return emit(SearchInitial());
    }

    _page = 1;
    emit(SearchLoadInProgress());
    appLogger.i('Emitting SearchLoadInProgress for query: $_query');

    final result = await searchRepository.searchBooks(_query, page: _page);

    result.fold(
      (failure) {
        appLogger.e(
          'SearchLoadFailure: ${failure.message}',
        );
        emit(SearchLoadFailure(failure.message));
      },
      (books) {
        appLogger.i('SearchLoadSuccess with ${books.length} books');
        emit(SearchLoadSuccess(books, hasReachedMax: books.isEmpty));
      },
    );
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<SearchState> emit,
  ) async {
    appLogger.d('LoadNextPage event received');
    if (state is SearchLoadSuccess) {
      final currentState = state as SearchLoadSuccess;
      if (currentState.hasReachedMax) {
        appLogger.i('Already reached max results, not loading next page');
        return;
      }

      _page++;
      appLogger.i('Loading next page: $_page for query: $_query');
      final result = await searchRepository.searchBooks(_query, page: _page);

      result.fold(
        (failure) {
          appLogger.e(
            'LoadNextPage Failure: ${failure.message}',
          );
          emit(SearchLoadFailure(failure.message, books: currentState.books));
        },
        (newBooks) {
          appLogger.i('Loaded ${newBooks.length} new books for page $_page');
          emit(
            SearchLoadSuccess(
              currentState.books + newBooks,
              hasReachedMax: newBooks.isEmpty,
            ),
          );
        },
      );
    }
  }

  Future<void> _onRetryRequested(
    RetryRequested event,
    Emitter<SearchState> emit,
  ) async {
    appLogger.d('RetryRequested event received');
    if (_query.isNotEmpty) {
      appLogger.i('Retrying search for query: $_query');
      add(SearchRequested(_query));
    } else {
      appLogger.i('No query to retry, emitting SearchInitial');
      emit(SearchInitial());
    }
  }
}
