import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/network_service.dart';
import 'package:riverpod_structure/features/movie_detail/data/repositories/movie_detail_repository_impl.dart';
import 'package:riverpod_structure/features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/add_bookmark_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/get_casts_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/get_movie_details_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/is_bookmark_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/remove_bookmark_use_case.dart';

// Repository
final movieDetailRepositoryProvider = Provider<MovieDetailRepository>((ref) {
  return MovieDetailRepositoryImpl(
    networkService: ref.watch(networkServiceProvider),
  );
});

// Use Cases
final getMovieDetailsUseCaseProvider = Provider<GetMovieDetailsUseCase>((ref) {
  return GetMovieDetailsUseCase(
    movieDetailRepository: ref.watch(movieDetailRepositoryProvider),
  );
});

final getCastsUseCaseProvider = Provider<GetCastsUseCase>((ref) {
  return GetCastsUseCase(
    movieDetailRepository: ref.watch(movieDetailRepositoryProvider),
  );
});

final addBookmarkUseCaseProvider = Provider<AddBookmarkUseCase>((ref) {
  return AddBookmarkUseCase(
    movieDetailRepository: ref.watch(movieDetailRepositoryProvider),
  );
});

final removeBookmarkUseCaseProvider = Provider<RemoveBookmarkUseCase>((ref) {
  return RemoveBookmarkUseCase(
    movieDetailRepository: ref.watch(movieDetailRepositoryProvider),
  );
});

final isBookmarkedUseCaseProvider = Provider<IsBookmarkedUseCase>((ref) {
  return IsBookmarkedUseCase(
    movieDetailRepository: ref.watch(movieDetailRepositoryProvider),
  );
});
