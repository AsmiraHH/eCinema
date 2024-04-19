// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Show _$ShowFromJson(Map<String, dynamic> json) => Show(
      json['id'] as int?,
      json['dateTime'] as String?,
      json['format'] as String?,
      json['price'] as int?,
      json['hallId'] as int?,
      json['hall'] == null
          ? null
          : Hall.fromJson(json['hall'] as Map<String, dynamic>),
      json['movieId'] as int?,
      json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowToJson(Show instance) => <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime,
      'format': instance.format,
      'price': instance.price,
      'hallId': instance.hallId,
      'hall': instance.hall,
      'movieId': instance.movieId,
      'movie': instance.movie,
    };
