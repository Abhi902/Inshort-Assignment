import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inshort_assignment/src/presentation/bloc/home_event_event.dart';
import 'package:inshort_assignment/src/presentation/bloc/home_event_state.dart';
import '../../data/repositories/movie_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository movieRepository;

  HomeBloc({required this.movieRepository}) : super(HomeInitial()) {
    on<FetchHomeMovies>((event, emit) async {
      emit(HomeLoading());
      try {
        log('Fetching now playing movies...');
        final nowPlaying = await movieRepository.getNowPlaying();
        log('Fetched ${nowPlaying.length} now playing movies.');

        log('Fetching trending movies...');
        final trending = await movieRepository.getTrending();
        log('Fetched ${trending.length} trending movies.');

        emit(
            HomeLoaded(nowPlayingMovies: nowPlaying, trendingMovies: trending));
      } catch (e, stackTrace) {
        log('Error fetching movies: $e');
        log('Stack trace: $stackTrace');
        emit(HomeError(message: e.toString()));
      }
    });
  }
}
