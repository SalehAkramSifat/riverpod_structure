import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/features/home/data/models/genres.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_and_cache_genre_use_case.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_cached_genre_use_case.dart';
import 'package:riverpod_structure/features/home/presentation/providers/home_providers.dart';
import 'package:riverpod_structure/features/home/presentation/providers/state/genre_state.dart';

class GenreNotifier extends Notifier<GenreState> {
  FetchAndCacheGenreUseCase get _fetchAndCacheGenreUseCase =>
      ref.read(fetchAndCacheGenreUseCaseProvider);
  FetchCacheGenresUseCase get _fetchCacheGenresUseCase =>
      ref.read(fetchCacheGenresUseCaseProvider);

  @override
  GenreState build() {
    // Automatically trigger fetch on initialization
    Future.microtask(() => getGenres());
    return const GenreState.initial();
  }

  bool get isFetching => state.state != GenreConcreteState.loading;

  Future<void> getGenres() async {
    if (isFetching) {
      state = state.copyWith(
        state: GenreConcreteState.loading,
        isLoading: true,
      );
      final cached = await _fetchCacheGenresUseCase.execute();
      cached.fold(
        (failure) async {
          state = state.copyWith(isLoading: true);
          final response = await _fetchAndCacheGenreUseCase.execute();
          updateStateFromGenreResponse(response);
        },
        (success) {
          updateStateFromGenreResponse(cached);
        },
      );
    }
  }

  void updateStateFromGenreResponse(Either<AppException, Genres> response) {
    response.fold(
      (failure) {
        state = state.copyWith(
          state: GenreConcreteState.failure,
          message: failure.message,
          isLoading: false,
        );
      },
      (success) {
        state = state.copyWith(
          genres: success.genres,
          hasData: true,
          message: success.genres.isEmpty ? 'No genre found' : '',
          isLoading: false,
          state: GenreConcreteState.loaded,
        );
      },
    );
  }

  void resetState() {
    state = const GenreState.initial();
  }
}
