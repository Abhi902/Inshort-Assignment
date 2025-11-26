import 'package:hive/hive.dart';
import 'package:inshort_assignment/src/domain/models/movie.dart';

part 'bookmarked_movie_hive_adapter.g.dart';

@HiveType(typeId: 2)
class BookmarkedMovieHive extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? posterPath;

  // You can add more minimal fields if needed.

  BookmarkedMovieHive({
    required this.id,
    this.title,
    this.posterPath,
  });

  factory BookmarkedMovieHive.fromDomain(Movie movie) {
    return BookmarkedMovieHive(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
    );
  }

  Movie toDomain() {
    return Movie(
      id: id,
      title: title ?? '',
      posterPath: posterPath ?? '',
      // Fill other Movie fields with default or empty values if required
      overview: '',
      releaseDate: '',
    );
  }
}
