import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/home/domain/repositories/home_repository.dart';
import 'package:riverpod_structure/features/home/data/models/genres.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class FetchAndCacheGenreUseCase {
  final HomeRepository homeRepository;

  FetchAndCacheGenreUseCase({required this.homeRepository});

  Future<Either<AppException, Genres>> execute() {
    return homeRepository.fetchAndCacheGenres();
  }
}
