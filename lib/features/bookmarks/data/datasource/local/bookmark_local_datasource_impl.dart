import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/core/services/storage/local_db.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'bookmark_local_datasource.dart';

class BookmarkLocalDataSourceImpl extends BookmarkLocalDataSource {
  final LocalDb localDb;

  BookmarkLocalDataSourceImpl({required this.localDb});

  @override
  Future<Either<AppException, List<MovieDetail>>> getBookMarkMovies() async {
    try {
      final bookmarks = await localDb.getDb().movieDetails.where().findAll();
      return Right(bookmarks);
    } catch (e) {
      return Left(
        AppException(
          message: e.toString(),
          statusCode: 0,
          identifier: 'BookmarkLocalDataSourceImpl.getBookMarkMovies',
          which: 'localDb',
        ),
      );
    }
  }

  @override
  Future<void> removeBookMark(MovieDetail movieDetail) async {
    await localDb.getDb().writeTxn(() async {
      await localDb.getDb().movieDetails.delete(movieDetail.id);
    });
  }
}
