import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/features/details/presentation/widgets/animated_cover.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Book book;
  const DetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BlocBuilder<DetailsBloc, DetailsState>
    final bool isLoading = false;
    final bool hasError = false;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Details'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    const Text('Failed to load book details.'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Dispatch retry event
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsetsGeometry.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCover(imageUrl: book.coverUrl),

                    /*  Hero(
                        tag: book.title,
                        child: AnimatedCover(imageUrl: book.coverUrl),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'by ${book.author}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              book.year != null
                                  ? 'Published in ${book.year}'
                                  : 'Year not available',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
