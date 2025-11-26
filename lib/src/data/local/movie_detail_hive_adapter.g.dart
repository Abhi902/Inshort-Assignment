// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailsHiveAdapter extends TypeAdapter<MovieDetailsHive> {
  @override
  final int typeId = 1;

  @override
  MovieDetailsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetailsHive(
      id: fields[0] as int,
      title: fields[1] as String?,
      overview: fields[2] as String?,
      posterPath: fields[3] as String?,
      genres: (fields[4] as List?)?.cast<String>(),
      runtime: fields[5] as int?,
      releaseDate: fields[6] as String?,
      voteAverage: fields[7] as double?,
      productionCompanies: (fields[8] as List?)?.cast<String>(),
      productionCountries: (fields[9] as List?)?.cast<String>(),
      spokenLanguages: (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailsHive obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.genres)
      ..writeByte(5)
      ..write(obj.runtime)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.voteAverage)
      ..writeByte(8)
      ..write(obj.productionCompanies)
      ..writeByte(9)
      ..write(obj.productionCountries)
      ..writeByte(10)
      ..write(obj.spokenLanguages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
