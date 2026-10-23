import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class GetBookmarksUseCase {
  final BookmarkRepository bookmarkRepository;

  GetBookmarksUseCase({required this.bookmarkRepository});

  Future<Either<AppException, List<MovieDetail>>> execute() async {
    return bookmarkRepository.getBookmarks();
  }
}
