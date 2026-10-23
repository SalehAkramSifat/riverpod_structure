import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/home/domain/repositories/home_repository.dart';
import 'package:riverpod_structure/features/home/data/models/movies.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class FetchCachedMoviesUseCase {
  final HomeRepository homeRepository;

  FetchCachedMoviesUseCase({required this.homeRepository});

  Future<Either<AppException, Movies>> execute({required String type}) {
    return homeRepository.fetchCachedMovies(type: type);
  }
}
