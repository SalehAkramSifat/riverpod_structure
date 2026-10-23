import 'package:riverpod_structure/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';

class RemoveBookmarkUseCase {
  final BookmarkRepository bookmarkRepository;

  RemoveBookmarkUseCase({required this.bookmarkRepository});

  Future<void> execute(MovieDetail movieDetail) async {
    return bookmarkRepository.removeBookmark(movieDetail);
  }
}
