// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      json['id'] as int?,
      json['title'] as String?,
      json['description'] as String?,
      json['releaseYear'] as int?,
      json['productionId'] as int?,
      json['languageId'] as int?,
      json['photo'] as String?,
    )
      ..author = json['author'] as String?
      ..duration = json['duration'] as int?;

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'duration': instance.duration,
      'releaseYear': instance.releaseYear,
      'productionId': instance.productionId,
      'languageId': instance.languageId,
      'photo': instance.photo,
    };
