import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class GetMovieDetailsUseCase {
  final MovieDetailRepository movieDetailRepository;

  GetMovieDetailsUseCase({required this.movieDetailRepository});

  Future<Either<AppException, MovieDetail>> execute({
    required int movieId,
  }) async {
    return movieDetailRepository.getMovie(id: movieId);
  }
}
