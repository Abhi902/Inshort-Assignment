import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';
import 'search_bloc_event.dart';
import 'search_bloc_state.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchState> {
  final MovieRepository movieRepository;
  Timer? _debounce;

  SearchBloc({required this.movieRepository}) : super(SearchInitial()) {
    on<TextChanged>(_onTextChanged);
  }

  void _onTextChanged(TextChanged event, Emitter<SearchState> emit) {
    final query = event.text.trim();

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        emit(SearchInitial());
        return;
      }

      emit(SearchLoading());
      try {
        final results = await movieRepository.searchMovies(query);
        if (results.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchSuccess(results: results));
        }
      } catch (e) {
        emit(SearchError(message: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
