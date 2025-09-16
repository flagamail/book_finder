import 'package:book_finder/core/network/network_info.dart';
import 'package:book_finder/core/network/network_info_impl.dart';
import 'package:book_finder/features/search/data/datasources/search_remote_data_source.dart';
import 'package:book_finder/features/search/data/datasources/search_remote_data_source_impl.dart';
import 'package:book_finder/features/search/data/repositories/search_repository_impl.dart';
import 'package:book_finder/features/search/domain/repositories/search_repository.dart';
import 'package:book_finder/features/search/presentation/bloc/search_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory<SearchBloc>(() => SearchBloc(searchRepository: sl()));

  // Repositories
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton<Dio>(() => Dio(
        BaseOptions(
          baseUrl: 'https://openlibrary.org',
          headers: {'User-Agent': 'Book Finder/1.0 (flagamail@gmail.com)'},
        ),
      ));
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<Logger>(() => Logger());
}
