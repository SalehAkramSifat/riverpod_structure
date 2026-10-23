import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/home/data/datasource/remote/home_remote_data_source.dart';
import 'package:riverpod_structure/features/home/data/models/genre_response.dart';
import 'package:riverpod_structure/features/home/data/models/movies_response.dart';
import 'package:riverpod_structure/core/services/network/network_service.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/core/utils/app_urls.dart';

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final NetworkService networkService;

  HomeRemoteDataSourceImpl({required this.networkService});

  @override
  Future<Either<AppException, MoviesResponse>> getMovies({
    required String endPoint,
    required int page,
  }) async {
    final response = await networkService.get(
      endPoint,
      queryParams: {Params.page: page},
    );

    return response.fold((l) => Left(l), (r) {
      final jsonData = r.data;
      if (jsonData == null) {
        return Left(
          AppException(
            identifier: endPoint,
            statusCode: 0,
            message: 'The data is not in the valid format',
            which: 'http',
          ),
        );
      }
      final moviesResponse = MoviesResponse.fromJson(
        jsonData,
        jsonData['results'] ?? [],
      );
      return Right(moviesResponse);
    });
  }

  @override
  Future<Either<AppException, GenreResponse>> getGenre() async {
    final response = await networkService.get(AppUrls.genre);
    return response.fold((l) => Left(l), (r) {
      final jsonData = r.data;
      if (jsonData == null) {
        return Left(
          AppException(
            identifier: AppUrls.genre,
            statusCode: 0,
            message: 'The data is not in the valid format',
            which: 'http',
          ),
        );
      }
      final genresResponse = GenreResponse(jsonData['genres'] ?? []);
      return Right(genresResponse);
    });
  }
}
