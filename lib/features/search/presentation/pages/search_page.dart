import '../widgets/search_bar.dart';
import '../widgets/shimmer_list.dart';
import '../widgets/error_message.dart';
import '../widgets/empty_message.dart';
import '../widgets/book_list_item.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BlocBuilder<SearchBloc, SearchState>
    final bool isLoading = false;
    final bool hasError = false;
    final bool isEmpty = false;
    final List<Map<String, String>> books = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
      ),
      body: Column(
        children: [
          BookSearchBar(
            onChanged: (query) {
              // TODO: Dispatch search event
            },
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return const ShimmerList();
                } else if (hasError) {
                  return ErrorMessage(
                    message: 'Something went wrong. Please try again.',
                    onRetry: () {
                      // TODO: Dispatch retry event
                    },
                  );
                } else if (isEmpty) {
                  return const EmptyMessage(message: 'No books found.');
                } else {
                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return BookListItem(
                        title: book['title'] ?? '',
                        author: book['author'] ?? '',
                        coverUrl: book['coverUrl'],
                        onTap: () {
                          // TODO: Navigate to details
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
