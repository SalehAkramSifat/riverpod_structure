import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/features/home/presentation/providers/state/genre_notifier.dart';
import 'package:riverpod_structure/features/home/presentation/providers/state/genre_state.dart';
import 'package:riverpod_structure/features/home/presentation/providers/state/movie_notifier.dart';
import 'package:riverpod_structure/features/home/presentation/providers/state/movie_state.dart';

final nowShowingMoviesStateNotifier =
    NotifierProvider<MovieNotifier, MovieState>(MovieNotifier.new);

final popularMoviesStateNotifier =
    NotifierProvider<MovieNotifier, MovieState>(MovieNotifier.new);

final genreStateNotifier =
    NotifierProvider<GenreNotifier, GenreState>(GenreNotifier.new);
