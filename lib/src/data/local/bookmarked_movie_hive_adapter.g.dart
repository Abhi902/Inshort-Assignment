// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarked_movie_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkedMovieHiveAdapter extends TypeAdapter<BookmarkedMovieHive> {
  @override
  final int typeId = 2;

  @override
  BookmarkedMovieHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkedMovieHive(
      id: fields[0] as int,
      title: fields[1] as String?,
      posterPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkedMovieHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkedMovieHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
