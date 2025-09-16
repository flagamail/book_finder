import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/features/search/presentation/bloc/search_bloc.dart';
import 'package:book_finder/features/search/presentation/bloc/search_event.dart';
import 'package:book_finder/features/search/presentation/bloc/search_state.dart';
import 'package:book_finder/features/search/presentation/pages/search_page.dart';
import 'package:book_finder/features/search/presentation/widgets/book_list_item.dart';
import 'package:book_finder/features/search/presentation/widgets/empty_message.dart';
import 'package:book_finder/features/search/presentation/widgets/error_message.dart';
import 'package:book_finder/features/search/presentation/widgets/search_bar.dart';
import 'package:book_finder/features/search/presentation/widgets/shimmer_list.dart';
import 'package:book_finder/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// MockSearchBloc for testing purposes
class MockSearchBloc extends MockBloc<SearchEvent, SearchState> implements SearchBloc {}

void main() {
  late MockSearchBloc searchBloc;

  setUp(() {
    searchBloc = MockSearchBloc();
  });
  tearDown((){
    searchBloc.close();
  });

  // Helper function to pump the widget with the bloc
  Widget buildTestableWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme(),
      home: BlocProvider<SearchBloc>.value(
        value: searchBloc,
        child: const SearchPage(),
      ),
    );
  }

  testWidgets('renders SearchBar and shows initial message when state is SearchInitial', (WidgetTester tester) async {
    // Arrange
    when(() => searchBloc.state).thenReturn(SearchInitial());

    // Act
    await tester.pumpWidget(buildTestableWidget());

    // Assert
    expect(find.byType(BookSearchBar), findsOneWidget);
    expect(find.byType(EmptyMessage), findsOneWidget);
    expect(find.text('Search for books to get started!'), findsOneWidget);
  });

  testWidgets('shows ShimmerList when state is SearchLoadInProgress', (WidgetTester tester) async {
    // Arrange
    when(() => searchBloc.state).thenReturn(SearchLoadInProgress());

    // Act
    await tester.pumpWidget(buildTestableWidget());

    // Assert
    expect(find.byType(ShimmerList), findsOneWidget);
  });

  testWidgets('shows ErrorMessage when state is SearchLoadFailure without books', (WidgetTester tester) async {
    // Arrange
    when(() => searchBloc.state).thenReturn(const SearchLoadFailure('Error'));

    // Act
    await tester.pumpWidget(buildTestableWidget());

    // Assert
    expect(find.byType(ErrorMessage), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('shows book list when state is SearchLoadSuccess with books', (WidgetTester tester) async {
    // Arrange
    final books = [Book(id: '1', title: 'Title', author: 'Author')];
    when(() => searchBloc.state).thenReturn(SearchLoadSuccess(books));

    // Act
    await tester.pumpWidget(buildTestableWidget());

    // Assert
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(BookListItem), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
  });

  testWidgets('shows empty message when state is SearchLoadSuccess with no books', (WidgetTester tester) async {
    // Arrange
    when(() => searchBloc.state).thenReturn(const SearchLoadSuccess([]));

    // Act
    await tester.pumpWidget(buildTestableWidget());

    // Assert
    expect(find.byType(EmptyMessage), findsOneWidget);
    expect(find.text('No books found.'), findsOneWidget);
  });

  testWidgets('shows book list and snackbar when state is SearchLoadFailure with books', (WidgetTester tester) async {
    // Arrange
    final books = [Book(id: '1', title: 'Title', author: 'Author')];
    final stateController = StreamController<SearchState>.broadcast(); // <-- fix: use broadcast

    when(() => searchBloc.stream).thenAnswer((_) => stateController.stream);
    when(() => searchBloc.state).thenReturn(SearchLoadSuccess(books));

    // Act
    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);

    // Emit the failure state with books
    stateController.add(SearchLoadFailure('Error loading more', books: books));
    await tester.pump(); // allow rebuild
    await tester.pump(const Duration(seconds: 1)); // allow SnackBar animation

    // Assert: list is still visible
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);

    // Assert: snackbar appears
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Error loading more'), findsOneWidget);
  });

  testWidgets('adds SearchRequested event when text is changed in BookSearchBar', (WidgetTester tester) async {
    // Arrange
    when(() => searchBloc.state).thenReturn(SearchInitial());
    await tester.pumpWidget(buildTestableWidget());

    // Act
    await tester.enterText(find.byType(TextField), 'flutter');

    // Assert
    verify(() => searchBloc.add(const SearchRequested('flutter'))).called(1);
  });
}
