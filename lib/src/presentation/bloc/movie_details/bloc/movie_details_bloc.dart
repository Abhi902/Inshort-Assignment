import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';
import '../../../../domain/models/movie_details.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieRepository movieRepository;

  MovieDetailsBloc({required this.movieRepository})
      : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>((event, emit) async {
      emit(MovieDetailsLoading());
      try {
        final details = await movieRepository.getMovieDetails(event.movieId);
        emit(MovieDetailsLoaded(movieDetails: details));
      } catch (e) {
        log('Error fetching movie details: $e');
        emit(MovieDetailsError(message: e.toString()));
      }
    });
  }
}
