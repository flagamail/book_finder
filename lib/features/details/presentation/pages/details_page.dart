import '../widgets/animated_cover.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BlocBuilder<DetailsBloc, DetailsState>
    final bool isLoading = false;
    final bool hasError = false;
    final Map<String, dynamic> book = {
      'title': 'Sample Book',
      'author': 'Author Name',
      'year': '2022',
      'coverUrl': null,
    };

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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (book['coverUrl'] != null)
                    AnimatedCover(imageUrl: book['coverUrl'])
                  else
                    Container(
                      width: 160,
                      height: 240,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 48),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    book['title'] ?? '',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book['author'] ?? '',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book['year'] != null ? 'Published: ${book['year']}' : '',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
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
