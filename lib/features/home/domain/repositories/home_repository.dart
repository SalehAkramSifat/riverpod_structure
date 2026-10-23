import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/home/data/models/movies.dart';
import 'package:riverpod_structure/features/home/data/models/genres.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

abstract class HomeRepository {
  Future<Either<AppException, Movies>> fetchAndCacheMovies({
    required int page,
    required String type,
  });

  Future<Either<AppException, Genres>> fetchAndCacheGenres();

  Future<Either<AppException, Genres>> fetchCachedGenres();

  Future<Either<AppException, Movies>> fetchCachedMovies({
    required String type,
  });
}
