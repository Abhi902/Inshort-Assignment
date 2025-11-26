import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';
import 'package:inshort_assignment/src/presentation/pages/movie_details_page.dart';

class SavedMoviesPage extends StatelessWidget {
  const SavedMoviesPage({Key? key}) : super(key: key);

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MovieRepository>();
    final bookmarkedMovies = repo.getBookmarkedMovies();

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Movies')),
      body: bookmarkedMovies.isEmpty
          ? Center(
              child: Text(
                'No bookmarks yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: bookmarkedMovies.length,
              itemBuilder: (context, index) {
                final movie = bookmarkedMovies[index];

                return ListTile(
                  leading: movie.posterPath != null
                      ? Image.network(
                          imageBaseUrl + movie.posterPath!,
                          width: 50.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.movie),
                  title: Text(movie.title),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsPage(movieId: movie.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
