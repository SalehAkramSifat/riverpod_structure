import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'bookmark_local_datasource.dart';

class BookmarkLocalDataSourceImpl extends BookmarkLocalDataSource {
  static final List<MovieDetail> _bookmarks = [];

  BookmarkLocalDataSourceImpl();

  @override
  Future<Either<AppException, List<MovieDetail>>> getBookMarkMovies() async {
    return Right(List<MovieDetail>.from(_bookmarks));
  }

  @override
  Future<void> removeBookMark(MovieDetail movieDetail) async {
    _bookmarks.removeWhere((item) => item.id == movieDetail.id);
  }
}
