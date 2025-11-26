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
        final nowPlaying = await movieRepository.getNowPlaying();
        final trending = await movieRepository.getTrending();
        emit(
            HomeLoaded(nowPlayingMovies: nowPlaying, trendingMovies: trending));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
  }
}
