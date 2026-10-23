import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/core_service_providers.dart';
import 'package:riverpod_structure/features/bookmarks/data/datasource/local/bookmark_local_datasource.dart';
import 'package:riverpod_structure/features/bookmarks/data/datasource/local/bookmark_local_datasource_impl.dart';
import 'package:riverpod_structure/features/bookmarks/data/repositories/bookmark_repository_impl.dart';
import 'package:riverpod_structure/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:riverpod_structure/features/bookmarks/domain/use_cases/get_bookmarks_use_case.dart';
import 'package:riverpod_structure/features/bookmarks/domain/use_cases/remove_bookmarks_use_case.dart';

// Data Source
final bookmarkLocalDataSourceProvider =
    Provider<BookmarkLocalDataSource>((ref) {
  return BookmarkLocalDataSourceImpl();
});

// Repository
final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(
    bookmarkLocalDataSource: ref.watch(bookmarkLocalDataSourceProvider),
  );
});

// Use Cases
final getBookmarksUseCaseProvider = Provider<GetBookmarksUseCase>((ref) {
  return GetBookmarksUseCase(
    bookmarkRepository: ref.watch(bookmarkRepositoryProvider),
  );
});

final removeBookmarkUseCaseProvider = Provider<RemoveBookmarkUseCase>((ref) {
  return RemoveBookmarkUseCase(
    bookmarkRepository: ref.watch(bookmarkRepositoryProvider),
  );
});
