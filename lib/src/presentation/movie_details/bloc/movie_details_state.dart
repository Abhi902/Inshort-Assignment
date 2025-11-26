import 'package:equatable/equatable.dart';
import '../../../domain/models/movie_details.dart';

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails movieDetails;

  MovieDetailsLoaded({required this.movieDetails});

  @override
  List<Object?> get props => [movieDetails];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  MovieDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
