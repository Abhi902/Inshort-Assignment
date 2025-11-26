import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inshort_assignment/src/data/api/tmdb_api_client.dart';

import '../../../domain/models/movie_details.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final TmdbApiClient apiClient;
  final String apiKey;
  final String language;

  MovieDetailsBloc({
    required this.apiClient,
    required this.apiKey,
    this.language = 'en-US',
  }) : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>((event, emit) async {
      emit(MovieDetailsLoading());
      try {
        log('Fetching details for movie ID: ${event.movieId}');
        log('Using API Key: $apiKey and Language: $language');

        final details = await apiClient.getMovieDetails(
          event.movieId,
          language,
        );
        emit(MovieDetailsLoaded(movieDetails: details));
      } catch (e) {
        log('Error fetching movie details: $e');
        emit(MovieDetailsError(message: e.toString()));
      }
    });
  }
}
