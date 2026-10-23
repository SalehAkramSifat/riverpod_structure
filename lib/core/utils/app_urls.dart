class AppUrls {
  // Base URLs
  static const String baseUrl = 'https://api.themoviedb.org/3/';
  static const String baseImageUrl = 'https://image.tmdb.org/t/p/';

  // Image URLs
  static String movieBackdrop(String path) => '${baseImageUrl}w780$path';
  static String moviePoster(String path) => '${baseImageUrl}w500$path';
  static String castProfile(String path) => '${baseImageUrl}w185$path';

  // API Endpoints
  static const String nowShowing = 'movie/now_playing';
  static const String popular = 'movie/top_rated';
  static const String genre = 'genre/movie/list';

  static String movie(dynamic id) => 'movie/$id';
  static String casts(int id) => '/movie/$id/credits';
}
