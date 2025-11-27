import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:inshort_assignment/src/data/local/bookmarked_movie_hive_adapter.dart';
import 'package:inshort_assignment/src/data/local/movie_detail_hive_adapter.dart';
import '../api/tmdb_api_client.dart';
import '../../domain/models/movie.dart';
import '../local/movie_hive_adapter.dart';
import 'package:hive/hive.dart';
import '../api/tmdb_api_client.dart';
import '../../domain/models/movie.dart';
import '../../domain/models/movie_details.dart';
import '../local/movie_hive_adapter.dart';

class MovieRepository {
  final TmdbApiClient apiClient;
  final Box<MovieHive> movieBox;
  final Box<MovieDetailsHive> movieDetailsBox; // Add details box
  final Box<BookmarkedMovieHive> bookmarkedBox; // Add bookmarked movies box

  final String apiKey;
  final String language;

  MovieRepository({
    required this.apiClient,
    required this.movieBox,
    required this.movieDetailsBox,
    required this.bookmarkedBox, // pass in bookmarked box
    required this.apiKey,
    this.language = 'en-US',
  });

  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      final response =
          await apiClient.getNowPlayingMovies(apiKey, language, page);
      await _cacheMovies(response.results);
      return response.results;
    } catch (_) {
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

  Future<MovieDetails> getMovieDetails(int movieId) async {
    try {
      final details = await apiClient.getMovieDetails(movieId, language);
      log('Fetched details from API:');
      log(details.toString());
      final detailsHive = MovieDetailsHive.fromMovieDetails(details);
      await movieDetailsBox.put(movieId, detailsHive);
      return details;
    } catch (_) {
      final cached = movieDetailsBox.get(movieId);
      if (cached != null) {
        return cached.toMovieDetails();
      } else {
        rethrow;
      }
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await apiClient.searchMovies(
        apiKey, // api_key
        language, // language
        query, // query
        page, // page
        false, // include_adult ← Now this will work
      );
      return response.results;
    } catch (_) {
      return [];
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

  //Bookmarking functions
  Future<void> addBookmark(Movie movie) async {
    final bookmarkHive = BookmarkedMovieHive.fromDomain(movie);
    await bookmarkedBox.put(bookmarkHive.id, bookmarkHive);
  }

  Future<void> removeBookmark(int movieId) async {
    await bookmarkedBox.delete(movieId);
  }

  List<Movie> getBookmarkedMovies() {
    return bookmarkedBox.values.map((b) => b.toDomain()).toList();
  }

  bool isBookmarked(int movieId) {
    return bookmarkedBox.containsKey(movieId);
  }
}
