import 'package:dio/dio.dart';
import 'package:inshort_assignment/src/domain/models/movie_details.dart';
import 'package:retrofit/retrofit.dart';
import '../../domain/models/movie.dart';

part 'tmdb_api_client.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  @GET("/movie/now_playing")
  Future<MovieResponse> getNowPlayingMovies(
    @Query("api_key") String apiKey,
    @Query("language") String language,
    @Query("page") int page,
  );

  @GET("/movie/popular")
  Future<MovieResponse> getTrendingMovies(
    @Query("api_key") String apiKey,
    @Query("language") String language,
    @Query("page") int page,
  );

// In your TmdbApiClient interface
  @GET('/search/movie')
  Future<MovieResponse> searchMovies(
    @Query('api_key') String apiKey,
    @Query('language') String language,
    @Query('query') String query,
    @Query('page') int page,
    @Query('include_adult') bool? includeAdult, // Make nullable/optional
  );

  @GET("/movie/{movie_id}")
  Future<MovieDetails> getMovieDetails(
    @Path("movie_id") int movieId,
    @Query("language") String language,
  );
}
