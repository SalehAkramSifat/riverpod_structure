import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

abstract class BookmarkLocalDataSource {
  Future<Either<AppException, List<MovieDetail>>> getBookMarkMovies();
  Future<void> removeBookMark(MovieDetail movieDetail);
}
