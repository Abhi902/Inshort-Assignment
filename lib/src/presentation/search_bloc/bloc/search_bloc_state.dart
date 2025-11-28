import 'package:equatable/equatable.dart';
import 'package:inshort_assignment/src/domain/models/movie.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Movie> results;

  const SearchSuccess({required this.results});

  @override
  List<Object> get props => [results];
}

// search_bloc_state.dart
class SearchRateLimited extends SearchState {
  final String message;
  const SearchRateLimited(this.message);

  @override
  List<Object> get props => [message];
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}
