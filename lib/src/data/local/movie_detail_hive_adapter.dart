import 'package:hive/hive.dart';
import '../../domain/models/movie_details.dart';

part 'movie_detail_hive_adapter.g.dart';

@HiveType(typeId: 1)
class MovieDetailsHive extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? overview;

  @HiveField(3)
  String? posterPath;

  @HiveField(4)
  List<String>? genres;

  @HiveField(5)
  int? runtime;

  @HiveField(6)
  String? releaseDate;

  @HiveField(7)
  double? voteAverage;

  @HiveField(8)
  List<String>? productionCompanies;

  @HiveField(9)
  List<String>? productionCountries;

  @HiveField(10)
  List<String>? spokenLanguages;

  // Add more fields as required.

  MovieDetailsHive({
    required this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.genres,
    this.runtime,
    this.releaseDate,
    this.voteAverage,
    this.productionCompanies,
    this.productionCountries,
    this.spokenLanguages,
  });

  // Factory method to create Hive model from domain model (MovieDetails)
  factory MovieDetailsHive.fromMovieDetails(MovieDetails movie) {
    return MovieDetailsHive(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.poster_path,
      genres: movie.genres.map((g) => g.name).toList(),
      runtime: movie.runtime,
      releaseDate: movie.release_date,
      voteAverage: movie.voteAverage,
      productionCompanies:
          movie.production_companies.map((p) => p.name).toList(),
      productionCountries:
          movie.production_countries.map((c) => c.name).toList(),
      spokenLanguages:
          movie.spoken_languages.map((l) => l.englishName).toList(),
    );
  }

  // Convert back from Hive model to domain model
  MovieDetails toMovieDetails() {
    return MovieDetails(
      id: id,
      adult: false,
      title: title ?? '',
      original_title: title ?? '',
      original_language: '',
      overview: overview ?? '',
      poster_path: posterPath,
      genres: genres?.map((name) => Genre(name: name, id: 0)).toList() ?? [],
      runtime: runtime ?? 0,
      release_date: releaseDate ?? '',
      popularity: 0.0,
      budget: 0,
      revenue: 0,
      status: '',
      video: false,
      voteAverage: voteAverage ?? 0,
      voteCount: 0,
      production_companies: productionCompanies
              ?.map((name) =>
                  ProductionCompany(id: 0, name: name, origin_country: ''))
              .toList() ??
          [],
      production_countries: productionCountries
              ?.map((name) => ProductionCountry(name: name, iso31661: ''))
              .toList() ??
          [],
      spoken_languages: spokenLanguages
              ?.map((name) =>
                  SpokenLanguage(englishName: name, iso6391: '', name: name))
              .toList() ??
          [],
    );
  }
}
