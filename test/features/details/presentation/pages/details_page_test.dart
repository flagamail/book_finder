import 'package:book_finder/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/features/details/presentation/pages/details_page.dart';

void main() {
  testWidgets('DetailsPage renders book details', (WidgetTester tester) async {
    const book = Book(id: '1', title: 'Sample Book', author: 'Author Name');
    await tester.pumpWidget(const MaterialApp(home: DetailsPage(book: book)));
    await tester.pumpAndSettle();
    expect(find.text('Sample Book'), findsOneWidget);
    expect(find.text('by Author Name'), findsOneWidget);
  });
}
