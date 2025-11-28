// lib/src/presentation/pages/home_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';
import 'package:inshort_assignment/src/presentation/home_bloc/home_event_bloc.dart';
import 'package:inshort_assignment/src/presentation/home_bloc/home_event_event.dart';
import 'package:inshort_assignment/src/presentation/home_bloc/home_event_state.dart';
import 'package:inshort_assignment/src/presentation/pages/bookmark_page.dart';
import 'package:inshort_assignment/src/presentation/pages/movie_details_page.dart';
import 'package:inshort_assignment/src/presentation/pages/search_page.dart';
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
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 12.w,
          title: Row(
            children: [
              // Netflix "N" style mark
              Container(
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'N',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Home',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.bookmark_outline,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedMoviesPage()),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
        body: Container(
          // Netflix-style subtle vertical gradient background
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Colors.black.withOpacity(0.96),
              ],
            ),
          ),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeInitial) {
                context.read<HomeBloc>().add(FetchHomeMovies());
                return _buildLoadingState(context);
              } else if (state is HomeLoading) {
                return _buildLoadingState(context);
              } else if (state is HomeLoaded) {
                return _buildNetflixContent(context, state);
              } else if (state is HomeError) {
                return _buildErrorState(context, state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor, // Netflix red
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading movies...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNetflixContent(BuildContext context, HomeLoaded state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: 8.h),
        ),
        SliverToBoxAdapter(
          child: _buildHeroBanner(
            state.nowPlayingMovies.isNotEmpty
                ? state.nowPlayingMovies.first
                : null,
            context,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20.h),
        ),
        _buildSectionSliver(
          context,
          'Now Playing',
          state.nowPlayingMovies,
        ),
        _buildSectionSliver(
          context,
          'Trending Now',
          state.trendingMovies,
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 100.h),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(Movie? movie, BuildContext context) {
    if (movie == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            // Poster background
            CachedNetworkImage(
              imageUrl: imageBaseUrl + (movie.posterPath ?? ''),
              width: double.infinity,
              height: 300.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 300.h,
                color: Colors.grey.shade900,
              ),
              errorWidget: (context, url, error) => Container(
                height: 300.h,
                color: Colors.grey.shade900,
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
            // Top to bottom vignette
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom content
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 18.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      shadows: const [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          'Now Playing',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '4.0',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MovieDetailsPage(movieId: movie.id),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 24,
                        ),
                        label: Text(
                          'Play',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          elevation: 0,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MovieDetailsPage(movieId: movie.id),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'More info',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.6),
                            width: 1,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSliver(
    BuildContext context,
    String title,
    List<Movie> movies,
  ) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 260.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return _NetflixMovieCard(movie: movie);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_creation_outlined,
            size: 80.sp,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.read<HomeBloc>().add(FetchHomeMovies()),
            child: Text(
              'Retry',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetflixMovieCard extends StatefulWidget {
  final Movie movie;
  const _NetflixMovieCard({Key? key, required this.movie}) : super(key: key);

  static const String imageBaseUrl =
      'https://image.tmdb.org/t/p/w220_and_h330_face';

  @override
  State<_NetflixMovieCard> createState() => _NetflixMovieCardState();
}

class _NetflixMovieCardState extends State<_NetflixMovieCard> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    final repo = context.read<MovieRepository>();
    isBookmarked = repo.isBookmarked(widget.movie.id);
  }

  void toggleBookmark() async {
    final repo = context.read<MovieRepository>();
    setState(() {
      isBookmarked = !isBookmarked;
    });

    if (isBookmarked) {
      await repo.addBookmark(widget.movie);
    } else {
      await repo.removeBookmark(widget.movie.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsPage(movieId: widget.movie.id),
          ),
        );
      },
      child: Container(
        width: 140.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor ??
                  Colors.black.withOpacity(0.5),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              // Movie Poster
              CachedNetworkImage(
                imageUrl: _NetflixMovieCard.imageBaseUrl +
                    (widget.movie.posterPath ?? ''),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).cardColor,
                  child: Icon(
                    Icons.movie,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                    size: 40,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).cardColor,
                  child: Icon(
                    Icons.broken_image,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                    size: 40,
                  ),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              // Bookmark button
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: toggleBookmark,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ),
              ),
              // Title & Rating
              Positioned(
                bottom: 8.h,
                left: 8.w,
                right: 8.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title ?? '',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '4.0',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                        ),
                      ],
                    ),
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
