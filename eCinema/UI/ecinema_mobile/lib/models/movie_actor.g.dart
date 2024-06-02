// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieActor _$MovieActorFromJson(Map<String, dynamic> json) => MovieActor(
      json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
      json['actor'] == null
          ? null
          : Actor.fromJson(json['actor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieActorToJson(MovieActor instance) =>
    <String, dynamic>{
      'movie': instance.movie,
      'actor': instance.actor,
    };
