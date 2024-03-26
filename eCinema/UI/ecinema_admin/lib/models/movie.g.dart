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
      ..duration = json['duration'] as int?
      ..production = json['production'] == null
          ? null
          : Production.fromJson(json['production'] as Map<String, dynamic>)
      ..language = json['language'] == null
          ? null
          : Language.fromJson(json['language'] as Map<String, dynamic>);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'duration': instance.duration,
      'releaseYear': instance.releaseYear,
      'productionId': instance.productionId,
      'production': instance.production,
      'languageId': instance.languageId,
      'language': instance.language,
      'photo': instance.photo,
    };
