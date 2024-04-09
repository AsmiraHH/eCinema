// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieGenre _$MovieGenreFromJson(Map<String, dynamic> json) => MovieGenre(
      json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
      json['genre'] == null
          ? null
          : Genre.fromJson(json['genre'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieGenreToJson(MovieGenre instance) =>
    <String, dynamic>{
      'movie': instance.movie,
      'genre': instance.genre,
    };
