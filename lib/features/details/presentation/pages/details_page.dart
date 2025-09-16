import 'package:book_finder/app/di.dart';
import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/domain/repositories/book_repository.dart';
import 'package:book_finder/features/details/presentation/widgets/animated_cover.dart';
import 'package:book_finder/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Book book;
  const DetailsPage({super.key, required this.book});

  void _saveBook(BuildContext context) {
    // Save book locally using injected repository
    final repo = sl<BookRepository>();
    repo.saveBook(book);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveBook(context);
    });

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Builder(
        builder: (context) {
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
      ),
    );
  }
}
