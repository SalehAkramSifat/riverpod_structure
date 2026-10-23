import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/home/domain/repositories/home_repository.dart';
import 'package:riverpod_structure/features/home/data/models/movies.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class FetchAndCacheMoviesUseCase {
  final HomeRepository homeRepository;

  FetchAndCacheMoviesUseCase({required this.homeRepository});

  Future<Either<AppException, Movies>> execute({
    required int page,
    required String type,
  }) {
    return homeRepository.fetchAndCacheMovies(page: page, type: type);
  }
}
