import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/home/data/models/movies.dart';
import 'package:riverpod_structure/features/home/data/models/genres.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheMovies({required Movies movies});

  Future<void> cacheGenres({required Genres genres});

  Future<Either<AppException, Movies>> getCacheMovies({required String type});

  Future<Either<AppException, Genres>> getGenreCache();
}
