import 'package:bloc_test/bloc_test.dart';
import 'package:book_finder/core/errors/failure.dart';
import 'package:book_finder/features/search/presentation/bloc/search_bloc.dart';
import 'package:book_finder/features/search/presentation/bloc/search_event.dart';
import 'package:book_finder/features/search/presentation/bloc/search_state.dart';
import 'package:book_finder/features/search/domain/repositories/search_repository.dart';
import 'package:book_finder/domain/entities/book.dart';
import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late SearchBloc bloc;
  late MockSearchRepository repository;

  setUp(() {
    repository = MockSearchRepository();
    bloc = SearchBloc(searchRepository: repository);
  });

  final books = [Book(id: '1', title: 'Book 1', author: 'Author 1'), Book(id: '2', title: 'Book 2', author: 'Author 2')];

  group('SearchBloc debounce', () {
    test('initial state is SearchInitial', () {
      expect(bloc.state, SearchInitial());
    });

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoadInProgress, SearchLoadSuccess] for single event after debounce',
      build: () {
        when(() => repository.searchBooks('flutter', page: 1))
            .thenAnswer((_) async => Right(books));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchRequested('flutter')),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits only last event after rapid multiple events (debounce)',
      build: () {
        when(() => repository.searchBooks(any(), page: any(named: 'page')))
            .thenAnswer((_) async => Right(books));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(SearchRequested('a'));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(SearchRequested('b'));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(SearchRequested('c'));
      },
      wait: const Duration(milliseconds: 400),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
      ],
      verify: (_) {
        verify(() => repository.searchBooks('c', page: 1)).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits nothing if no event is added',
      build: () => bloc,
      act: (_) {},
      expect: () => [],
    );

    blocTest<SearchBloc, SearchState>(
      'emits for each event if spaced out longer than debounce',
      build: () {
        when(() => repository.searchBooks(any(), page: any(named: 'page')))
            .thenAnswer((_) async => Right(books));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(SearchRequested('x'));
        await Future.delayed(const Duration(milliseconds: 350));
        bloc.add(SearchRequested('y'));
      },
      wait: const Duration(milliseconds: 800),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
      ],
      verify: (_) {
        verify(() => repository.searchBooks('x', page: 1)).called(1);
        verify(() => repository.searchBooks('y', page: 1)).called(1);
      },
    );
  });

  group('SearchBloc edge cases', () {
    blocTest<SearchBloc, SearchState>(
      'emits SearchInitial if query is empty',
      build: () => bloc,
      act: (bloc) => bloc.add(SearchRequested('')),
      wait: const Duration(milliseconds: 350),
      expect: () => [SearchInitial()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits SearchLoadFailure on repository failure',
      build: () {
        when(() => repository.searchBooks('fail', page: 1))
            .thenAnswer((_) async => Left(NetworkFailure('Something went wrong')));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchRequested('fail')),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        SearchLoadInProgress(),
        isA<SearchLoadFailure>(),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits next page results when LoadNextPage is added',
      build: () {
        when(() => repository.searchBooks('flutter', page: 1))
            .thenAnswer((_) async => Right(books));
        when(() => repository.searchBooks('flutter', page: 2))
            .thenAnswer((_) async => Right([Book(id: '3', title: 'Book 3', author: 'Author 3')]));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(SearchRequested('flutter'));
        await Future.delayed(const Duration(milliseconds: 350));
        bloc.add(LoadNextPage());
      },
      wait: const Duration(milliseconds: 900),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
        SearchLoadSuccess(
          [...books, Book(id: '3', title: 'Book 3', author: 'Author 3')],
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'does not load next page if hasReachedMax is true',
      build: () {
        when(() => repository.searchBooks('flutter', page: 1))
            .thenAnswer((_) async => Right([]));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(SearchRequested('flutter'));
        await Future.delayed(const Duration(milliseconds: 350));
        bloc.add(LoadNextPage());
      },
      wait: const Duration(milliseconds: 900),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess([], hasReachedMax: true),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits only last event after rapid multiple LoadNextPage events (debounce)',
      build: () {
        when(() => repository.searchBooks('flutter', page: 1))
            .thenAnswer((_) async => Right(books));
        when(() => repository.searchBooks('flutter', page: 2))
            .thenAnswer((_) async => Right([Book(id: '3', title: 'Book 3', author: 'Author 3')]));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(SearchRequested('flutter'));
        await Future.delayed(const Duration(milliseconds: 350));
        bloc.add(LoadNextPage());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(LoadNextPage());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(LoadNextPage());
      },
      wait: const Duration(milliseconds: 900),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
        SearchLoadSuccess(
          [...books, Book(id: '3', title: 'Book 3', author: 'Author 3')],
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => repository.searchBooks('flutter', page: 2)).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits failure for last event after rapid multiple LoadNextPage events with repository failure',
      build: () {
        when(() => repository.searchBooks('flutter', page: 1))
            .thenAnswer((_) async => Right(books));
        when(() => repository.searchBooks('flutter', page: 2))
            .thenAnswer((_) async => Left(NetworkFailure('Something went wrong')));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(SearchRequested('flutter'));
        await Future.delayed(const Duration(milliseconds: 350));
        bloc.add(LoadNextPage());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(LoadNextPage());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(LoadNextPage());
      },
      wait: const Duration(milliseconds: 900),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
        SearchLoadFailure('Something went wrong', books: books),
      ],
      verify: (_) {
        verify(() => repository.searchBooks('flutter', page: 2)).called(1);
        verifyNever(() => repository.searchBooks('flutter', page: 3));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'retries search on RetryRequested',
      build: () {
        when(() => repository.searchBooks('flutter', page: 1))
            .thenAnswer((_) async => Right(books));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(SearchRequested('flutter'));
        await Future.delayed(const Duration(milliseconds: 350));
        bloc.add(RetryRequested());
      },
      wait: const Duration(milliseconds: 800),
      expect: () => [
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
        SearchLoadInProgress(),
        SearchLoadSuccess(books, hasReachedMax: false),
      ],
    );
  });
}
