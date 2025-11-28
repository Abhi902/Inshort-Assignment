import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovieDetails extends MovieDetailsEvent {
  final int movieId;

  FetchMovieDetails(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
