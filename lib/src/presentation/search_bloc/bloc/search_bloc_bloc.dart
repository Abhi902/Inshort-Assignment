import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';
import 'search_bloc_event.dart';
import 'search_bloc_state.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchState> {
  final MovieRepository movieRepository;
  Timer? _debounce;
  DateTime? _lastSearchTime;

  SearchBloc({required this.movieRepository}) : super(SearchInitial()) {
    on<TextChanged>(_onTextChanged);
    on<SearchQuery>(_onSearchQuery);
    on<ClearSearch>(_onClearSearch);
  }

  void _onTextChanged(TextChanged event, Emitter<SearchState> emit) {
    final query = event.text.trim();
    log('👤 User typed: "$query"');

    // Cancel previous debounce
    _debounce?.cancel();

    log('⏳ Starting debounce timer for: "$query"');

    _debounce = Timer(const Duration(milliseconds: 500), () {
      log('✅ Debounce timer fired for: "$query"');

      if (query.isEmpty) {
        add(const ClearSearch());
      } else {
        add(SearchQuery(query));
      }
    });
  }

  Future<void> _onSearchQuery(
      SearchQuery event, Emitter<SearchState> emit) async {
    log('🔍 API CALL: searchMovies("${event.query}")');
    emit(SearchLoading());
    final now = DateTime.now();
    if (_lastSearchTime != null) {
      final diff = now.difference(_lastSearchTime!).inSeconds;
      if (diff < 1) {
        log('⏳ Rate limited, waiting ${1 - diff}s');
        await Future.delayed(Duration(seconds: 1 - diff));
      }
    }
    _lastSearchTime = now;
    try {
      final results = await movieRepository.searchMovies(event.query);
      log('✅ API SUCCESS: ${results.length} results for "${event.query}"');

      if (results.isEmpty) {
        log('📭 No results for "${event.query}"');
        emit(SearchEmpty());
      } else {
        log('🎬 Found ${results.length} movies');
        log(results[1].title);

        emit(SearchSuccess(results: results));
      }
    } catch (e, stackTrace) {
      log('❌ API ERROR: $e');
      log('📍 Stack trace: $stackTrace');
      emit(SearchError(message: e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    log('🧹 Clearing search');
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    log('🔒 Closing SearchBloc');
    _debounce?.cancel();
    return super.close();
  }
}
