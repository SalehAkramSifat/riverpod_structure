import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/home/data/models/genre_response.dart';
import 'package:riverpod_structure/features/home/data/models/movies_response.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

abstract class HomeRemoteDataSource {
  Future<Either<AppException, MoviesResponse>> getMovies({
    required String endPoint,
    required int page,
  });

  Future<Either<AppException, GenreResponse>> getGenre();
}
