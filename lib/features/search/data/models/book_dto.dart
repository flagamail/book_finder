import 'package:equatable/equatable.dart';

class BookDto extends Equatable {
  final String key;
  final String title;
  final List<String>? authorName;
  final int? coverI;

  const BookDto({
    required this.key,
    required this.title,
    this.authorName,
    this.coverI,
  });

  factory BookDto.fromJson(Map<String, dynamic> json) {
    return BookDto(
      key: json['key'] as String,
      title: json['title'] as String,
      authorName: json['author_name'] != null
          ? List<String>.from(json['author_name'])
          : null,
      coverI: json['cover_i'] as int?,
    );
  }

  @override
  List<Object?> get props => [key, title, authorName, coverI];
}
