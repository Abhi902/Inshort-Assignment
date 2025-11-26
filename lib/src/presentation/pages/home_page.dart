import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inshort_assignment/src/presentation/bloc/home_event_bloc.dart';
import 'package:inshort_assignment/src/presentation/bloc/home_event_event.dart';
import 'package:inshort_assignment/src/presentation/bloc/home_event_state.dart';
import 'package:inshort_assignment/src/presentation/pages/movie_details_page.dart';
import '../../domain/models/movie.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Discover Movies',
            style: (Theme.of(context).textTheme.titleLarge ?? const TextStyle())
                .copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              context.read<HomeBloc>().add(FetchHomeMovies());
              return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor));
            } else if (state is HomeLoading) {
              return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor));
            } else if (state is HomeLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: 'Now Playing'),
                    SizedBox(
                      height: 270.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.nowPlayingMovies.length,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        itemBuilder: (context, index) {
                          final movie = state.nowPlayingMovies[index];
                          return _MovieCard(movie: movie);
                        },
                      ),
                    ),
                    SectionTitle(title: 'Trending Now'),
                    SizedBox(
                      height: 270.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.trendingMovies.length,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        itemBuilder: (context, index) {
                          final movie = state.trendingMovies[index];
                          return _MovieCard(movie: movie);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  state.message,
                  style: (Theme.of(context).textTheme.titleLarge ??
                          const TextStyle())
                      .copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Theme.of(context).hoverColor,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 0, 12.h),
      child: Text(
        title,
        style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
            .copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard({Key? key, required this.movie}) : super(key: key);

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsPage(movie: movie),
          ),
        );
      },
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 8.r,
              offset: Offset(0, 6.h),
            ),
          ],
          color: Theme.of(context).cardColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageBaseUrl + movie.posterPath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.broken_image,
                        color: Colors.white30, size: 64),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 65.h,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10.h,
                left: 10.w,
                right: 10.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: (Theme.of(context).textTheme.bodyMedium ??
                              const TextStyle())
                          .copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                              blurRadius: 6,
                              color: Colors.black,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4.w),
                        Text(
                          4.0.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
