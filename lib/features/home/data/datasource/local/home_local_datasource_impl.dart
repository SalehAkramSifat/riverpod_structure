import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/features/home/data/models/genres.dart';
import 'package:riverpod_structure/features/home/data/models/movies.dart';
import 'home_local_datasource.dart';

class HomeLocalDataSourceImpl extends HomeLocalDataSource {
  static final Map<String, Movies> _moviesCache = {};
  static Genres? _genresCache;

  HomeLocalDataSourceImpl();

  @override
  Future<void> cacheMovies({required Movies movies}) async {
    _moviesCache[movies.type] = movies;
  }

  @override
  Future<void> cacheGenres({required Genres genres}) async {
    _genresCache = genres;
  }

  @override
  Future<Either<AppException, Genres>> getGenreCache() async {
    if (_genresCache != null) {
      return Right(_genresCache!);
    }
    return Left(
      AppException(
        message: 'Genre not cached',
        statusCode: 0,
        identifier: 'genres',
        which: 'cache',
      ),
    );
  }

  @override
  Future<Either<AppException, Movies>> getCacheMovies({
    required String type,
  }) async {
    final cached = _moviesCache[type];
    if (cached != null) {
      return Right(cached);
    }
    return Left(
      AppException(
        message: 'Cache not found',
        statusCode: 0,
        identifier: type,
        which: 'cache',
      ),
    );
  }
}
