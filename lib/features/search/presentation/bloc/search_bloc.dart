import 'package:bloc/bloc.dart';
import 'package:book_finder/features/search/domain/repositories/search_repository.dart';
import 'package:book_finder/features/search/presentation/bloc/search_event.dart';
import 'package:book_finder/features/search/presentation/bloc/search_state.dart';
import 'package:stream_transform/stream_transform.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(SearchInitial()) {
    on<SearchRequested>(_onSearchRequested, transformer: debounce(_duration));
    on<LoadNextPage>(_onLoadNextPage);
  }

  int _page = 1;
  String _query = '';

  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    _query = event.query;
    if (_query.isEmpty) {
      return emit(SearchInitial());
    }

    _page = 1;
    emit(SearchLoadInProgress());

    final result = await searchRepository.searchBooks(_query, page: _page);

    result.fold(
      (failure) => emit(SearchLoadFailure(failure.message)),
      (books) {
        emit(SearchLoadSuccess(books, hasReachedMax: books.isEmpty));
      },
    );
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoadSuccess) {
      final currentState = state as SearchLoadSuccess;
      if (currentState.hasReachedMax) return;

      _page++;
      final result = await searchRepository.searchBooks(_query, page: _page);

      result.fold(
        (failure) => emit(SearchLoadFailure(failure.message)),
        (newBooks) {
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
}
