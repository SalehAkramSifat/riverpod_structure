import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/core/services/network_service.dart';
import 'package:riverpod_structure/core/utils/app_urls.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/casts_response.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'package:riverpod_structure/features/movie_detail/domain/repositories/movie_detail_repository.dart';

class MovieDetailRepositoryImpl implements MovieDetailRepository {
  final NetworkService networkService;

  MovieDetailRepositoryImpl({required this.networkService});

  @override
  Future<Either<AppException, MovieDetail>> getMovie({required int id}) async {
    try {
      final response = await networkService.get(AppUrls.movie(id));
      return response.fold(
        (l) => Left(l),
        (r) => Right(MovieDetail.fromJson(r.data as Map<String, dynamic>)),
      );
    } catch (e) {
      return Left(
        AppException(
          message: e.toString(),
          statusCode: 0,
          identifier: 'MovieDetailRepositoryImpl.getMovie',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, CastsResponse>> getCasts({required int id}) async {
    try {
      final response = await networkService.get(AppUrls.casts(id));
      return response.fold(
        (l) => Left(l),
        (r) => Right(CastsResponse.fromJson(r.data as Map<String, dynamic>)),
      );
    } catch (e) {
      return Left(
        AppException(
          message: e.toString(),
          statusCode: 0,
          identifier: 'MovieDetailRepositoryImpl.getCasts',
        ),
      );
    }
  }

  @override
  Future<int> bookmarkMovieDetail(MovieDetail movieDetail) async {
    return 1;
  }

  @override
  Future<bool> removeBookmark(MovieDetail movieDetail) async {
    return true;
  }

  @override
  Future<bool> isBookmarked(int id) async {
    return false;
  }
}
