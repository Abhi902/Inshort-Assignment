import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inshort_assignment/src/presentation/bloc/movie_details/bloc/movie_details_bloc.dart';
import 'package:inshort_assignment/src/presentation/bloc/movie_details/bloc/movie_details_event.dart';
import 'package:inshort_assignment/src/presentation/bloc/movie_details/bloc/movie_details_state.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/movie_details.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({Key? key, required this.movieId}) : super(key: key);

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  void _shareMovie(MovieDetails movie) {
    final deepLink = 'myflix://movie/${movie.id}';
    final text = 'Check out "${movie.title}" on MyFlix: $deepLink';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailsBloc(movieRepository: context.read())
        ..add(FetchMovieDetails(movieId)),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.only(left: 8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            titleSpacing: 0,
            title: Text(
              'Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 20),
                onPressed: () {
                  final state = context.read<MovieDetailsBloc>().state;
                  if (state is MovieDetailsLoaded) {
                    _shareMovie(state.movieDetails);
                  }
                },
              ),
              SizedBox(width: 4.w),
            ],
          ),
          body: BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
            listener: (context, state) async {
              if (state is MovieDetailsError) {
                await _showRateLimitDialog(context);
              }
            },
            builder: (context, state) {
              if (state is MovieDetailsLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (state is MovieDetailsLoaded) {
                return _buildDetails(context, state.movieDetails);
              } else if (state is MovieDetailsError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      "TDBM API rate limit exceeded. Please try again later.",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, MovieDetails movie) {
    final genres = movie.genres.map((g) => g.name).join(', ');
    final productionCompanies =
        movie.production_companies.map((p) => p.name).join(', ');
    final productionCountries =
        movie.production_countries.map((c) => c.name).join(', ');
    final spokenLanguages =
        movie.spoken_languages.map((l) => l.englishName).join(', ');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HERO: poster + gradient overlay, Netflix-style.[web:24][web:4]
          SizedBox(
            width: double.infinity,
            height: 420.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageBaseUrl + (movie.poster_path ?? ''),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).cardColor,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image,
                      size: 80.r,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                // Top gradient (subtle)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom gradient into page background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 180.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating content card with title + meta.
          Transform.translate(
            offset: Offset(0, -40.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                    ),
                    SizedBox(height: 8.h),
                    // Meta row: year • runtime • rating
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          movie.release_date,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(width: 14.w),
                        Icon(
                          Icons.access_time,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${movie.runtime} min',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(width: 14.w),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Chips for genres
                    if (genres.isNotEmpty)
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: movie.genres
                            .map(
                              (g) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.16),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  g.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                      ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    SizedBox(height: 16.h),
                    // Primary action row like Netflix: Play + My List.[web:24]
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // No functionality change – still just UI
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 24,
                            ),
                            label: Text(
                              'Play',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Reserved for "My List" etc. – UI only
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white.withOpacity(0.9),
                              size: 22,
                            ),
                            label: Text(
                              'My List',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.6),
                                width: 1,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // The rest of the content sections.
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Overview'),
                SizedBox(height: 6.h),
                Text(
                  movie.overview,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                ),
                SizedBox(height: 20.h),
                _buildSectionTitle(context, 'Genres'),
                _buildInfoText(context, genres),
                SizedBox(height: 14.h),
                _buildSectionTitle(context, 'Production Companies'),
                _buildInfoText(context, productionCompanies),
                SizedBox(height: 14.h),
                _buildSectionTitle(context, 'Production Countries'),
                _buildInfoText(context, productionCountries),
                SizedBox(height: 14.h),
                _buildSectionTitle(context, 'Spoken Languages'),
                _buildInfoText(context, spokenLanguages),
                SizedBox(height: 14.h),
                _buildSectionTitle(context, 'Runtime'),
                _buildInfoText(context, '${movie.runtime} minutes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
    );
  }

  Widget _buildInfoText(BuildContext context, String text) {
    if (text.isEmpty) {
      return Text(
        'N/A',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Future<void> _showRateLimitDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.speed,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Rate Limit Exceeded',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        content: Text(
          'TMDB API rate limit exceeded. Please wait a moment and try again.',
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<MovieDetailsBloc>().add(FetchMovieDetails(movieId));
            },
            child: Text(
              'OK',
              style: Theme.of(ctx).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
