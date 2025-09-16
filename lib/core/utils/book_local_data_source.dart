import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:book_finder/domain/entities/book.dart';
import 'package:book_finder/core/errors/exceptions.dart';

import 'app_logger.dart';

class BookLocalDataSource {
  static final BookLocalDataSource _instance = BookLocalDataSource._internal();

  factory BookLocalDataSource() => _instance;

  BookLocalDataSource._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'books.db');
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id TEXT PRIMARY KEY,
            title TEXT,
            author TEXT,
            year INTEGER,
            coverUrl TEXT
          )
        ''');
        appLogger.i('Database created and books table initialized at $path');
      },
    );
    appLogger.i('Database opened at $path');
    return db;
  }

  Future<void> saveBook(Book book) async {
    try {
      final db = await database;
      await db.insert(
        'books',
        {
          'id': book.id,
          'title': book.title,
          'author': book.author,
          'year': book.year,
          'coverUrl': book.coverUrl,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      appLogger.i('Book saved successfully: ${book.id} - ${book.title}');
    } catch (e, s) {
      appLogger.e(
          'LocalDataSource error saving book: ${e.toString()}', error: e,
          stackTrace: s);
    }
  }

  Future<Book?> getBook(String id) async {
    try {
      final db = await database;
      final maps = await db.query('books', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        final map = maps.first;
        return Book(
          id: map['id'] as String,
          title: map['title'] as String,
          author: map['author'] as String,
          year: map['year'] as int?,
          coverUrl: map['coverUrl'] as String,
        );
      }
      return null;
    } catch (e, s) {
      appLogger.e(
          'LocalDataSource error getting book: ${e.toString()}', error: e,
          stackTrace: s);
      throw LocalDatabaseException('Failed to get book');
    }
  }
}