import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final int? year;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.year,
  });

  @override
  List<Object?> get props => [id, title, author, coverUrl, year];
}
