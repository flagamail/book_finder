import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  final String title;
  final String author;
  final String? coverUrl;
  final VoidCallback? onTap;
  const BookListItem({
    super.key,
    required this.title,
    required this.author,
    this.coverUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: title,
        child: coverUrl != null
            ? Image.network(coverUrl!, width: 48, height: 72, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.book))
            : const Icon(Icons.book),
      ),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(author, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}
