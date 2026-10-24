import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/network_service.dart';
import 'package:riverpod_structure/features/home/data/datasource/local/home_local_datasource.dart';
import 'package:riverpod_structure/features/home/data/datasource/local/home_local_datasource_impl.dart';
import 'package:riverpod_structure/features/home/data/datasource/remote/home_remote_data_source.dart';
import 'package:riverpod_structure/features/home/data/datasource/remote/home_remote_datasource.dart';
import 'package:riverpod_structure/features/home/data/repositories/home_repository_impl.dart';
import 'package:riverpod_structure/features/home/domain/repositories/home_repository.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_and_cache_genre_use_case.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_and_cache_movies_use_case.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_cached_genre_use_case.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_cached_movies_use_case.dart';

// Data Sources
final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSourceImpl();
});

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(
    networkService: ref.watch(networkServiceProvider),
  );
});

// Repository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    homeRemoteDataSource: ref.watch(homeRemoteDataSourceProvider),
    homeLocalDataSource: ref.watch(homeLocalDataSourceProvider),
  );
});

// Use Cases
final fetchAndCacheGenreUseCaseProvider =
    Provider<FetchAndCacheGenreUseCase>((ref) {
  return FetchAndCacheGenreUseCase(
    homeRepository: ref.watch(homeRepositoryProvider),
  );
});

final fetchAndCacheMoviesUseCaseProvider =
    Provider<FetchAndCacheMoviesUseCase>((ref) {
  return FetchAndCacheMoviesUseCase(
    homeRepository: ref.watch(homeRepositoryProvider),
  );
});

final fetchCacheGenresUseCaseProvider =
    Provider<FetchCacheGenresUseCase>((ref) {
  return FetchCacheGenresUseCase(
    homeRepository: ref.watch(homeRepositoryProvider),
  );
});

final fetchCachedMoviesUseCaseProvider =
    Provider<FetchCachedMoviesUseCase>((ref) {
  return FetchCachedMoviesUseCase(
    homeRepository: ref.watch(homeRepositoryProvider),
  );
});
