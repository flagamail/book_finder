import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/features/details/presentation/widgets/animated_cover.dart';
import 'package:book_finder/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Book book;
  const DetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Replace with BlocBuilder<DetailsBloc, DetailsState>
    final bool isLoading = false;
    final bool hasError = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
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
                  const SizedBox(height: AppTheme.spaceMd),
                  const Text('Failed to load book details.'),
                  const SizedBox(height: AppTheme.spaceMd),
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
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Hero(
                      tag: book.id, // Use unique ID for Hero tag
                      child: AnimatedCover(
                        imageUrl: book.coverUrl,
                        size: 250, // Larger cover for details view
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  Text(
                    book.title,
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spaceSm),
                  Text(
                    'by ${book.author}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  if (book.year != null)
                    Text(
                      'Published in ${book.year}',
                      style: theme.textTheme.bodyLarge,
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
