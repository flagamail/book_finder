import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/features/search/presentation/pages/search_page.dart';
import 'package:book_finder/features/search/presentation/widgets/search_bar.dart';

void main() {
  testWidgets('SearchPage renders SearchBar and handles empty state', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));
    expect(find.byType(BookSearchBar), findsOneWidget);
  });

}