// movie.dart
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  final String overview;
  @JsonKey(name: 'poster_path')
  final String posterPath;
  @JsonKey(name: 'release_date')
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class MovieResponse {
  final List<Movie> results;
  final int page;
  final int total_pages;
  final int total_results;

  MovieResponse({
    required this.results,
    required this.page,
    required this.total_pages,
    required this.total_results,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      results: (json['results'] as List).map((e) => Movie.fromJson(e)).toList(),
      page: json['page'] ?? 1,
      total_pages: json['total_pages'] ?? 1,
      total_results: json['total_results'] ?? 0,
    );
  }
}
