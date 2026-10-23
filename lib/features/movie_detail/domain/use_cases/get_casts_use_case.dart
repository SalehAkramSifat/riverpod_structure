import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/casts_response.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class GetCastsUseCase {
  final MovieDetailRepository movieDetailRepository;

  GetCastsUseCase({required this.movieDetailRepository});

  Future<Either<AppException, CastsResponse>> execute({
    required int movieId,
  }) async {
    return movieDetailRepository.getCasts(id: movieId);
  }
}
