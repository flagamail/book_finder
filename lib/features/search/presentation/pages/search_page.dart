import 'package:book_finder/core/utils/app_logger.dart';
import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/features/details/presentation/pages/details_page.dart';
import 'package:book_finder/features/search/presentation/bloc/search_bloc.dart';
import 'package:book_finder/features/search/presentation/bloc/search_event.dart';
import 'package:book_finder/features/search/presentation/bloc/search_state.dart';
import 'package:book_finder/features/search/presentation/widgets/book_list_item.dart';
import 'package:book_finder/features/search/presentation/widgets/empty_message.dart';
import 'package:book_finder/features/search/presentation/widgets/error_message.dart';
import 'package:book_finder/features/search/presentation/widgets/search_bar.dart';
import 'package:book_finder/features/search/presentation/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
      ),
      body: Column(
        children: [
          BookSearchBar(
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchRequested(query));
            },
          ),
          Expanded(
            child: BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchLoadFailure && state.books != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                }
              },
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const EmptyMessage(message: 'Search for books to get started!');
                }
                if (state is SearchLoadInProgress) {
                  return const ShimmerList();
                }
                if (state is SearchLoadFailure && state.books == null) {
                  return ErrorMessage(
                    message: state.message,
                    onRetry: () {
                      context.read<SearchBloc>().add(RetryRequested());
                    },
                  );
                }

                List<Book>? books;
                bool hasReachedMax = false;

                if (state is SearchLoadSuccess) {
                  books = state.books;
                  hasReachedMax = state.hasReachedMax;
                } else if (state is SearchLoadFailure && state.books != null) {
                  books = state.books;
                  hasReachedMax = true;
                }

                if (books != null) {
                  if (books.isEmpty) {
                    return const EmptyMessage(message: 'No books found.');
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<SearchBloc>().add(RetryRequested());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: hasReachedMax ? books.length : books.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= books!.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final book = books[index];
                        return BookListItem(
                          id: book.id,
                          title: book.title,
                          author: book.author,
                          coverUrl: book.coverUrl,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(book: book),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      appLogger.i('Scroll reaching bottom, try loading next page');
      context.read<SearchBloc>().add(LoadNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }
}
