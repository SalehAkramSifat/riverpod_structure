import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/features/home/data/models/movies.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_and_cache_movies_use_case.dart';
import 'package:riverpod_structure/features/home/domain/use_cases/fetch_cached_movies_use_case.dart';
import 'package:riverpod_structure/features/home/presentation/providers/home_providers.dart';
import 'package:riverpod_structure/features/home/presentation/providers/state/movie_state.dart';

class MovieNotifier extends Notifier<MovieState> {
  FetchAndCacheMoviesUseCase get _fetchAndCacheMoviesUseCase =>
      ref.read(fetchAndCacheMoviesUseCaseProvider);
  FetchCachedMoviesUseCase get _fetchCachedMoviesUseCase =>
      ref.read(fetchCachedMoviesUseCaseProvider);

  @override
  MovieState build() {
    return const MovieState.initial();
  }

  bool get isFetching =>
      state.state != MoviesConcreteState.loading &&
      state.state != MoviesConcreteState.fetchingMore;

  Future<void> getMovies({required String type}) async {
    if (state.state == MoviesConcreteState.initial) {
      final movies = await _fetchCachedMoviesUseCase.execute(type: type);
      updateStateFromGetMoviesResponse(movies);
    }
    if (isFetching && state.state != MoviesConcreteState.fetchedAllMovies) {
      state = state.copyWith(
        state: state.page > 0
            ? MoviesConcreteState.fetchingMore
            : MoviesConcreteState.loading,
        isLoading: true,
      );
      final movies = await _fetchAndCacheMoviesUseCase.execute(
        page: state.page + 1,
        type: type,
      );
      updateStateFromGetMoviesResponse(movies);
    } else {
      state = state.copyWith(
        state: MoviesConcreteState.fetchedAllMovies,
        message: 'No more movies left',
        isLoading: false,
      );
    }
  }

  void updateStateFromGetMoviesResponse(Either<AppException, Movies> response) {
    response.fold(
      (failure) {
        state = state.copyWith(
          state: MoviesConcreteState.failure,
          message: failure.message,
          isLoading: false,
        );
      },
      (movies) {
        if (state.cache && !movies.cached) {
          state = state.copyWith(movies: []);
        }
        final totalMovies = [...state.movies, ...movies.movies];
        state = state.copyWith(
          movies: totalMovies,
          state: totalMovies.length == movies.totalResults
              ? MoviesConcreteState.fetchedAllMovies
              : MoviesConcreteState.loaded,
          hasData: true,
          cache: movies.cached,
          message: totalMovies.isEmpty ? 'No Movies Found' : '',
          page: movies.page,
          totalPages: movies.totalPages,
          isLoading: false,
        );
      },
    );
  }

  void resetState() {
    state = const MovieState.initial();
  }
}
