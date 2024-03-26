// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Actor _$ActorFromJson(Map<String, dynamic> json) => Actor(
      json['id'] as int?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String?,
      json['gender'] as int?,
      json['birthDate'] as String?,
    );

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
    };
