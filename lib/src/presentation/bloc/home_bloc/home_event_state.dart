import 'package:equatable/equatable.dart';
import 'package:inshort_assignment/src/domain/models/movie.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> nowPlayingMovies;
  final List<Movie> trendingMovies;

  HomeLoaded({required this.nowPlayingMovies, required this.trendingMovies});

  @override
  List<Object?> get props => [nowPlayingMovies, trendingMovies];
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
