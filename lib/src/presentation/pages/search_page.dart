import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inshort_assignment/src/presentation/pages/movie_details_page.dart';
import 'package:inshort_assignment/src/presentation/search_bloc/bloc/search_bloc_bloc.dart';
import 'package:inshort_assignment/src/presentation/search_bloc/bloc/search_bloc_event.dart';
import 'package:inshort_assignment/src/presentation/search_bloc/bloc/search_bloc_state.dart';
import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';
import '../../domain/models/movie.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w92';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        movieRepository: context.read<MovieRepository>(),
      )..add(const TextChanged('')),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Search Movies',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Search Input Field
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for movies...',
                  prefixIcon:
                      Icon(Icons.search, color: Theme.of(context).hintColor),
                  suffixIcon: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoading) {
                        return SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(strokeWidth: 2.w),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade900.withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
                onChanged: (query) {
                  context.read<SearchBloc>().add(TextChanged(query));
                },
              ),
            ),
            // Results List
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _buildEmptyState(
                        context, 'Start typing to search movies');
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchEmpty) {
                    return _buildEmptyState(context, 'No movies found');
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is SearchSuccess) {
                    return _buildMoviesList(state.results, context);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_creation_outlined,
            size: 80.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList(List<Movie> movies, BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _SearchMovieTile(movie: movie);
      },
    );
  }
}

class _SearchMovieTile extends StatelessWidget {
  final Movie movie;

  const _SearchMovieTile({required this.movie});
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: imageBaseUrl + (movie.posterPath ?? ''),
          width: 60.w,
          height: 90.h,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 60.w,
            height: 90.h,
            color: Colors.grey.shade800,
            child: const Icon(Icons.movie, color: Colors.white30),
          ),
          errorWidget: (context, url, error) => Container(
            width: 60.w,
            height: 90.h,
            color: Colors.grey.shade800,
            child: const Icon(Icons.broken_image, color: Colors.white30),
          ),
        ),
      ),
      title: Text(
        movie.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.overview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4.h),
          Text(
            movie.releaseDate,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: Colors.grey.shade400,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsPage(movieId: movie.id),
          ),
        );
      },
    );
  }
}
