import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/features/bookmarks/presentation/providers/state/bookmark_notifier.dart';
import 'package:riverpod_structure/features/bookmarks/presentation/providers/state/bookmark_state.dart';

final bookmarkNotifierProvider =
    NotifierProvider<BookmarkNotifier, BookmarkState>(BookmarkNotifier.new);
