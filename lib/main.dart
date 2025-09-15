import 'package:book_finder/app/di.dart' as di;
import 'package:book_finder/features/search/presentation/bloc/search_bloc.dart';
import 'package:book_finder/features/search/presentation/pages/search_page.dart';
import 'package:book_finder/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (_) => di.sl<SearchBloc>(),
        child: const SearchPage(),
      ),
    );
  }
}
