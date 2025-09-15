import 'package:flutter/material.dart';

class BookSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;
  const BookSearchBar({super.key, required this.onChanged, this.initialValue = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: const Key('searchBar'),
        decoration: const InputDecoration(
          hintText: 'Search books by title...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
        controller: TextEditingController(text: initialValue),
      ),
    );
  }
}

