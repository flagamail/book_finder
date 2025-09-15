import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final VoidCallback? onTap;

  const BookListItem({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Hero(
          tag: id, // Use unique book ID for the Hero tag
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: coverUrl != null
                ? Image.network(
                    coverUrl!,
                    width: 64, // as per theme.md
                    height: 96, // as per theme.md
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 48),
                  )
                : Container(
                    width: 64,
                    height: 96,
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    child: const Icon(Icons.book, size: 48),
                  ),
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          author,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.secondary, // Muted color
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}
