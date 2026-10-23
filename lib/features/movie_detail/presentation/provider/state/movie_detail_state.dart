import 'package:equatable/equatable.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';

enum MovieDetailConcreteState { initial, loading, loaded, failure }

class MovieDetailState extends Equatable {
  final MovieDetailConcreteState state;
  final MovieDetail? movieDetail;
  final bool isBookmarked;
  final String message;

  const MovieDetailState({
    this.state = MovieDetailConcreteState.initial,
    this.movieDetail,
    this.isBookmarked = false,
    this.message = '',
  });

  MovieDetailState copyWith({
    MovieDetailConcreteState? state,
    MovieDetail? movieDetail,
    bool? isBookmarked,
    String? message,
  }) {
    return MovieDetailState(
      state: state ?? this.state,
      movieDetail: movieDetail ?? this.movieDetail,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movieDetail, isBookmarked, message];
}
