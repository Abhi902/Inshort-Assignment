import 'package:json_annotation/json_annotation.dart';

part 'movie_details.g.dart';

@JsonSerializable()
class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
class ProductionCompany {
  final int id;
  final String? logo_path;
  final String name;
  final String origin_country;

  ProductionCompany(
      {required this.id,
      this.logo_path,
      required this.name,
      required this.origin_country});

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionCompanyToJson(this);
}

@JsonSerializable()
class ProductionCountry {
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;

  ProductionCountry({required this.iso31661, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionCountryToJson(this);
}

@JsonSerializable()
class SpokenLanguage {
  @JsonKey(name: 'english_name')
  final String englishName;
  @JsonKey(name: 'iso_639_1')
  final String iso6391;
  final String name;

  SpokenLanguage(
      {required this.englishName, required this.iso6391, required this.name});

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguageFromJson(json);
  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);
}

@JsonSerializable()
class MovieDetails {
  final bool adult;
  final String? backdrop_path;
  final int budget;
  final List<Genre> genres;
  final String? homepage;
  final int id;
  final String? imdb_id;
  final String original_language;
  final String original_title;
  final String overview;
  final double popularity;
  final String? poster_path;
  final List<ProductionCompany> production_companies;
  final List<ProductionCountry> production_countries;
  final String release_date;
  final int revenue;
  final int runtime;
  final List<SpokenLanguage> spoken_languages;
  final String status;
  final String? tagline;
  final String title;
  final bool video;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;

  MovieDetails({
    required this.adult,
    this.backdrop_path,
    required this.budget,
    required this.genres,
    this.homepage,
    required this.id,
    this.imdb_id,
    required this.original_language,
    required this.original_title,
    required this.overview,
    required this.popularity,
    this.poster_path,
    required this.production_companies,
    required this.production_countries,
    required this.release_date,
    required this.revenue,
    required this.runtime,
    required this.spoken_languages,
    required this.status,
    this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);
}
