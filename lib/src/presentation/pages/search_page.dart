import 'dart:developer';
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

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String queryCurrent = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        movieRepository: context.read<MovieRepository>(),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildNetflixAppBar(context),
            body: Container(
              decoration: BoxDecoration(
                // Netflix-like dark vertical gradient background. [web:25][web:28]
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.black.withOpacity(0.96),
                  ],
                ),
              ),
              child: BlocListener<SearchBloc, SearchState>(
                listenWhen: (prev, curr) => curr is SearchRateLimited,
                listener: (context, state) async {
                  if (state is SearchRateLimited) {
                    await _showRateLimitDialog(context);
                  }
                },
                child: Column(
                  children: [
                    _buildNetflixSearchBar(context),
                    Expanded(child: _buildResultsSection(context)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildNetflixAppBar(BuildContext context) {
    return AppBar(
      leadingWidth: 56.w,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
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
          SizedBox(width: 12.w),
          Text(
            'Search',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetflixSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      height: 52.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // solid dark gray on black BG
        borderRadius: BorderRadius.circular(10.r), // smaller radius
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Colors.white,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search for movies, TV shows...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 14,
                ),
                // No border, we rely on the outer container’s rounded pill.
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: 40.h,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 4.w),
                  child: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.75),
                    size: 22,
                  ),
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: 40.h,
                ),
                // Optional clear button, feels close to modern streaming UIs.
                suffixIcon: (queryCurrent.isNotEmpty)
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        onPressed: () {
                          queryCurrent = '';
                          // Clear text field visually.
                          FocusScope.of(context).unfocus();
                          context.read<SearchBloc>().add(const TextChanged(''));
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                queryCurrent = query;
                context.read<SearchBloc>().add(TextChanged(query));
              },
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: SizedBox(
                    width: 22.w,
                    height: 22.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }
              return SizedBox(width: 12.w);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        log('🔄 Search State: $state');

        if (state is SearchInitial) {
          return _buildNetflixEmptyState(
            context,
            'What do you want to watch?',
          );
        } else if (state is SearchLoading) {
          return _buildLoadingState(context);
        } else if (state is SearchEmpty) {
          return _buildNetflixEmptyState(
            context,
            'No results found for "$queryCurrent"',
          );
        } else if (state is SearchError) {
          return _buildErrorState(context, state.message);
        } else if (state is SearchSuccess) {
          return _buildNetflixResultsGrid(context, state.results);
        }
        return _buildNetflixEmptyState(context, 'Start searching...');
      },
    );
  }

  Widget _buildNetflixEmptyState(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_movies,
              size: 80.sp,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.35),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Try searching for “Avengers”, “Inception”, or “Stranger Things”.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Searching...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () =>
                  context.read<SearchBloc>().add(const TextChanged('')),
              child: Text(
                'Try Again',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetflixResultsGrid(BuildContext context, List<Movie> movies) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Search Results',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final movie = movies[index];
                return _NetflixMovieCard(movie: movie);
              },
              childCount: movies.length,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showRateLimitDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Theme.of(ctx).cardColor,
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
              context.read<SearchBloc>().add(const TextChanged(''));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).textTheme.labelLarge?.color,
              backgroundColor: Theme.of(ctx).cardColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'OK',
              style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetflixMovieCard extends StatelessWidget {
  final Movie movie;
  const _NetflixMovieCard({required this.movie});

  static const String imageBaseUrl =
      'https://image.tmdb.org/t/p/w220_and_h330_face';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailsPage(movieId: movie.id),
        ),
      ),
      child: Container(
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
              // Poster
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageBaseUrl + (movie.posterPath ?? ''),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).cardColor,
                    child: Icon(
                      Icons.movie,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.5),
                      size: 40,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).cardColor,
                    child: Icon(
                      Icons.broken_image,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.5),
                      size: 40,
                    ),
                  ),
                ),
              ),
              // Bottom gradient overlay
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
              // Title + metadata
              Positioned(
                left: 8.w,
                right: 8.w,
                bottom: 8.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
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
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            movie.releaseDate?.split('-').first ?? 'N/A',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.8),
                          size: 14,
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
