import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/features/details/presentation/pages/details_page.dart';

void main() {
  testWidgets('DetailsPage renders book details', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DetailsPage()));
    await tester.pumpAndSettle();
    expect(find.text('Sample Book'), findsOneWidget);
    expect(find.text('Author Name'), findsOneWidget);
  });
}
