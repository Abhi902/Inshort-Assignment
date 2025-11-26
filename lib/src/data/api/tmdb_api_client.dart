import 'package:dio/dio.dart';
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

  @GET("/search/movie")
  Future<MovieResponse> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );

  @GET("/movie/{movie_id}")
  Future<Movie> getMovieDetails(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );
}
