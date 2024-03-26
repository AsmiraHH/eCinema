// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Show _$ShowFromJson(Map<String, dynamic> json) => Show(
      json['id'] as int?,
      json['date'] as String?,
      json['startTime'] as String?,
      json['format'] as int?,
      json['price'] as int?,
      json['hallId'] as int?,
      json['hall'] == null
          ? null
          : Hall.fromJson(json['hall'] as Map<String, dynamic>),
      json['cinemaId'] as int?,
      json['cinema'] == null
          ? null
          : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
      json['movieId'] as int?,
      json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowToJson(Show instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'startTime': instance.startTime,
      'format': instance.format,
      'price': instance.price,
      'hallId': instance.hallId,
      'hall': instance.hall,
      'cinemaId': instance.cinemaId,
      'cinema': instance.cinema,
      'movieId': instance.movieId,
      'movie': instance.movie,
    };
