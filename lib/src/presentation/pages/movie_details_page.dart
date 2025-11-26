import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inshort_assignment/src/presentation/movie_details/bloc/movie_details_bloc.dart';
import 'package:inshort_assignment/src/presentation/movie_details/bloc/movie_details_event.dart';
import 'package:inshort_assignment/src/presentation/movie_details/bloc/movie_details_state.dart';

import '../../domain/models/movie_details.dart';
import '../../data/api/tmdb_api_client.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({Key? key, required this.movieId}) : super(key: key);

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    // Retrieve apiClient and apiKey from RepositoryProvider
    final apiClient = RepositoryProvider.of<TmdbApiClient>(context);
    final apiKey = RepositoryProvider.of<String>(context);

    return BlocProvider(
      create: (_) =>
          MovieDetailsBloc(movieRepository: RepositoryProvider.of(context))
            ..add(FetchMovieDetails(movieId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Movie Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          elevation: Theme.of(context).appBarTheme.elevation,
        ),
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsLoaded) {
              return _buildDetails(context, state.movieDetails);
            } else if (state is MovieDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, MovieDetails movie) {
    String genres = movie.genres.map((g) => g.name).join(', ');
    String productionCompanies =
        movie.production_companies.map((p) => p.name).join(', ');
    String productionCountries =
        movie.production_countries.map((c) => c.name).join(', ');
    String spokenLanguages =
        movie.spoken_languages.map((l) => l.englishName).join(', ');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 400.h,
            child: CachedNetworkImage(
              imageUrl: imageBaseUrl + (movie.poster_path ?? ''),
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child:
                    Icon(Icons.broken_image, size: 80.r, color: Colors.white30),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              movie.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  movie.release_date,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(width: 20.w),
                Icon(Icons.star, color: Colors.amber, size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Overview',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              movie.overview,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Genres: $genres',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Production Companies: $productionCompanies',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Production Countries: $productionCountries',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Spoken Languages: $spokenLanguages',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Runtime: ${movie.runtime} minutes',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
