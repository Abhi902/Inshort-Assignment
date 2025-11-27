// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';
// import 'package:inshort_assignment/src/presentation/search_bloc/bloc/search_bloc_event.dart';
  
// class SearchBloc extends Bloc<SearchBlocEvent, SearchState> {
//   final MovieRepository movieRepository;
//   Timer? _debounce;

//   SearchBloc({required this.movieRepository}) : super(SearchInitial()) {
//     on<TextChanged>((event, emit) {
//       final query = event.text.trim();

//       if (_debounce?.isActive ?? false) _debounce!.cancel();

//       _debounce = Timer(const Duration(milliseconds: 500), () async {
//         if (query.isEmpty) {
//           emit(SearchInitial());
//           return;
//         }

//         emit(SearchLoading());

//         final results = await movieRepository.searchMovies(query);

//         if (results.isEmpty) {
//           emit(SearchEmpty());
//         } else {
//           emit(SearchSuccess(results: results));
//         }
//       });
//     });
//   }

//   @override
//   Future<void> close() {
//     _debounce?.cancel();
//     return super.close();
//   }
// }
