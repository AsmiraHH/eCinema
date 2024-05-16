// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      json['description'] as String?,
      (json['releaseYear'] as num?)?.toInt(),
      (json['productionId'] as num?)?.toInt(),
      (json['languageId'] as num?)?.toInt(),
      json['photo'] as String?,
      (json['genreIDs'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      (json['genres'] as List<dynamic>?)
          ?.map((e) => MovieGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..author = json['author'] as String?
      ..duration = (json['duration'] as num?)?.toInt()
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
      'genreIDs': instance.genreIDs,
      'genres': instance.genres,
      'photo': instance.photo,
    };
