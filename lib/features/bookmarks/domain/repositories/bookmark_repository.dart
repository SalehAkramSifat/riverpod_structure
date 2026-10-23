import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

abstract class BookmarkRepository {
  Future<Either<AppException, List<MovieDetail>>> getBookmarks();

  Future<void> removeBookmark(MovieDetail movieDetail);
}
