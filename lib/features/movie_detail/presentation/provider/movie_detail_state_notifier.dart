import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/add_bookmark_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/get_movie_details_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/is_bookmark_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/remove_bookmark_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/presentation/provider/movie_detail_providers.dart';
import 'package:riverpod_structure/features/movie_detail/presentation/provider/state/movie_detail_state.dart';

final movieDetailStateNotifier =
    NotifierProvider<MovieDetailNotifier, MovieDetailState>(
  MovieDetailNotifier.new,
);

class MovieDetailNotifier extends Notifier<MovieDetailState> {
  GetMovieDetailsUseCase get _getMovieDetailsUseCase =>
      ref.read(getMovieDetailsUseCaseProvider);
  AddBookmarkUseCase get _addBookmarkUseCase =>
      ref.read(addBookmarkUseCaseProvider);
  RemoveBookmarkUseCase get _removeBookmarkUseCase =>
      ref.read(removeBookmarkUseCaseProvider);
  IsBookmarkedUseCase get _isBookmarkedUseCase =>
      ref.read(isBookmarkedUseCaseProvider);

  @override
  MovieDetailState build() {
    return const MovieDetailState();
  }

  Future<void> getMovie({required int id}) async {
    state = state.copyWith(state: MovieDetailConcreteState.loading);
    final response = await _getMovieDetailsUseCase.execute(movieId: id);
    response.fold(
      (failure) => state = state.copyWith(
        state: MovieDetailConcreteState.failure,
        message: failure.message,
      ),
      (data) => state = state.copyWith(
        state: MovieDetailConcreteState.loaded,
        movieDetail: data,
      ),
    );
  }

  Future<void> checkIfBookMarked(int id) async {
    final isBookmarked = await _isBookmarkedUseCase.execute(id);
    state = state.copyWith(isBookmarked: isBookmarked);
  }

  Future<void> bookmarkMovieDetail(MovieDetail movie) async {
    await _addBookmarkUseCase.execute(movie);
    state = state.copyWith(isBookmarked: true);
  }

  Future<void> removeBookmark(MovieDetail movie) async {
    await _removeBookmarkUseCase.execute(movie);
    state = state.copyWith(isBookmarked: false);
  }
}
