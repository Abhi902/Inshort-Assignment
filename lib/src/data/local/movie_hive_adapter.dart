import 'package:hive/hive.dart';
import '../../domain/models/movie.dart';

part 'movie_hive_adapter.g.dart';

@HiveType(typeId: 0)
class MovieHive extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final String releaseDate;

  MovieHive({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
  });

  factory MovieHive.fromDomain(Movie movie) {
    return MovieHive(
      id: movie.id,
      title: movie.title,
      overview: movie.overview ?? "",
      posterPath: movie.posterPath ?? "",
      releaseDate: movie.releaseDate ?? "",
    );
  }

  Movie toDomain() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      releaseDate: releaseDate,
    );
  }
}
