import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/casts_response.dart';

import 'package:riverpod_structure/core/exceptions/app_exception.dart';

abstract class MovieDetailRepository {
  Future<Either<AppException, MovieDetail>> getMovie({required int id});

  Future<Either<AppException, CastsResponse>> getCasts({required int id});

  Future<int> bookmarkMovieDetail(MovieDetail movieDetail);

  Future<bool> removeBookmark(MovieDetail movieDetail);

  Future<bool> isBookmarked(int id);
}
