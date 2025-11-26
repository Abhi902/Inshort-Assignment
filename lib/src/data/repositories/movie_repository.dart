import 'package:hive/hive.dart';
import '../api/tmdb_api_client.dart';
import '../../domain/models/movie.dart';
import '../local/movie_hive_adapter.dart';

class MovieRepository {
  final TmdbApiClient apiClient;
  final Box<MovieHive> movieBox;
  final String apiKey;
  final String language;

  MovieRepository({
    required this.apiClient,
    required this.movieBox,
    required this.apiKey,
    this.language = 'en-US',
  });

  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      final response =
          await apiClient.getNowPlayingMovies(apiKey, language, page);
      // Cache movies in Hive
      await _cacheMovies(response.results);
      return response.results;
    } catch (_) {
      // On error, return cached movies
      return _getCachedMovies();
    }
  }

  Future<List<Movie>> getTrending({int page = 1}) async {
    try {
      final response =
          await apiClient.getTrendingMovies(apiKey, language, page);
      await _cacheMovies(response.results);
      return response.results;
    } catch (_) {
      return _getCachedMovies();
    }
  }

  Future<void> _cacheMovies(List<Movie> movies) async {
    final moviesHive = movies.map((m) => MovieHive.fromDomain(m)).toList();
    await movieBox.clear();
    await movieBox.addAll(moviesHive);
  }

  List<Movie> _getCachedMovies() {
    return movieBox.values.map((m) => m.toDomain()).toList();
  }
}
